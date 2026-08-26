#!/usr/bin/env bash
#
# versions-consistency.sh — guards the platform version pins in
# modules/captain-cluster against drifting apart from each other and from the
# GlueOps/platform-crds layer-0 CRD bundle they reference.
#
# Checks:
#   (a) local.glueops_platform_version (platform-versions.tf) equals the
#       platform-helm-chart-platform ?ref= in generate-helm-values.tf.
#   (b) the upstream pins recorded as annotations on the platform-crds chart at
#       local.platform_crds_version equal the chart versions the platform chart
#       at local.glueops_platform_version actually deploys (targetRevision of
#       each CRD-bearing Application, rendered with default values), and the
#       bundle's argo-cd pin equals local.argocd_app_version. A bundle bump and
#       a platform bump therefore have to land in the same module release.
#   (c) every *_placeholder in modules/platform-chart-version/0.1.0/version.tpl
#       is substituted by a replace() in main.tf (and vice versa), so a new pin
#       cannot reach VERSIONS/glueops.yaml unrendered.
#
# Requires: bash, helm (with OCI support), yq (mikefarah v4), sed, grep.
# Network: pulls both charts from ghcr.io (anonymous). Override with
# PLATFORM_CRDS_CHART / PLATFORM_CHART (an OCI reference or a local path).
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CAPTAIN_DIR="$REPO_ROOT/modules/captain-cluster"
VERSIONS_TF="$CAPTAIN_DIR/platform-versions.tf"
HELM_VALUES_TF="$CAPTAIN_DIR/generate-helm-values.tf"
VERSION_TPL="$REPO_ROOT/modules/platform-chart-version/0.1.0/version.tpl"
VERSION_MAIN="$REPO_ROOT/modules/platform-chart-version/0.1.0/main.tf"

PLATFORM_CRDS_CHART="${PLATFORM_CRDS_CHART:-oci://ghcr.io/glueops/platform-crds}"
PLATFORM_CHART="${PLATFORM_CHART:-oci://ghcr.io/glueops/platform-helm-chart-platform/glueops-platform}"

failures=()
fail() { failures+=("$*"); echo "FAIL: $*" >&2; }
ok() { echo "ok:   $*"; }
die() { echo "ERROR: $*" >&2; exit 1; }

for tool in helm yq sed grep; do
  command -v "$tool" >/dev/null 2>&1 || die "required tool not found: $tool"
done

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

# tf_local NAME — value of `NAME = "..."` inside the locals block of platform-versions.tf
tf_local() {
  local value
  value=$(sed -nE "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*\"([^\"]+)\".*/\1/p" "$VERSIONS_TF")
  [ -n "$value" ] || die "local.$1 not found in $VERSIONS_TF"
  echo "$value"
}

# strip_v VERSION — drop a single leading "v" (bundle pins and Application targetRevisions disagree on it)
strip_v() { echo "${1#v}"; }

glueops_platform_version=$(tf_local glueops_platform_version)
platform_crds_version=$(tf_local platform_crds_version)
argocd_app_version=$(tf_local argocd_app_version)
echo "glueops_platform_version=$glueops_platform_version platform_crds_version=$platform_crds_version argocd_app_version=$argocd_app_version"

# ---------------------------------------------------------------------------
# (a) glueops_platform_version == platform-helm-chart-platform ?ref=
# ---------------------------------------------------------------------------
platform_ref=$(sed -nE 's/.*platform-helm-chart-platform\.git\?ref=([^"[:space:]]+)".*/\1/p' "$HELM_VALUES_TF")
[ -n "$platform_ref" ] || die "platform-helm-chart-platform ?ref= not found in $HELM_VALUES_TF"
if [ "$platform_ref" = "$glueops_platform_version" ]; then
  ok "(a) glueops_platform_version $glueops_platform_version == platform-helm-chart-platform ?ref=$platform_ref"
else
  fail "(a) local.glueops_platform_version is $glueops_platform_version but generate-helm-values.tf pins platform-helm-chart-platform.git?ref=$platform_ref — both must move together"
fi

# ---------------------------------------------------------------------------
# (c) version.tpl placeholders <-> main.tf replace() calls
# ---------------------------------------------------------------------------
placeholders=$(grep -oE '[A-Za-z0-9_]+_placeholder' "$VERSION_TPL" | sort -u)
placeholder_count=$(grep -o '_placeholder' "$VERSION_TPL" | wc -l | tr -d ' ')
replace_count=$(grep -o 'replace(' "$VERSION_MAIN" | wc -l | tr -d ' ')
if [ "$placeholder_count" = "$replace_count" ]; then
  ok "(c) $placeholder_count _placeholder occurrences in version.tpl == $replace_count replace() calls in main.tf"
else
  fail "(c) version.tpl has $placeholder_count _placeholder occurrences but main.tf has $replace_count replace() calls — every placeholder needs exactly one replace()"
fi
for ph in $placeholders; do
  grep -q "\"$ph\"" "$VERSION_MAIN" || fail "(c) placeholder $ph from version.tpl has no replace() in main.tf"
done

# ---------------------------------------------------------------------------
# (b) platform-crds bundle pins == platform chart targetRevisions
# ---------------------------------------------------------------------------
crds_chart_version=$(strip_v "$platform_crds_version")
if ! helm show chart "$PLATFORM_CRDS_CHART" --version "$crds_chart_version" >"$WORKDIR/crds-chart.yaml" 2>"$WORKDIR/crds-chart.err"; then
  cat "$WORKDIR/crds-chart.err" >&2
  fail "(b) cannot fetch $PLATFORM_CRDS_CHART --version $crds_chart_version: GlueOps/platform-crds v$crds_chart_version must be published first (release it, then re-run this check)"
else
  # pin KEY — value of annotation glueops.dev/pin.KEY on the bundle chart
  pin() {
    local value
    value=$(yq -r ".annotations[\"glueops.dev/pin.$1\"] // \"\"" "$WORKDIR/crds-chart.yaml")
    [ -n "$value" ] || die "annotation glueops.dev/pin.$1 missing from platform-crds v$crds_chart_version Chart.yaml"
    echo "$value"
  }

  platform_chart_version=$(strip_v "$glueops_platform_version")
  if [ -d "$PLATFORM_CHART" ]; then
    chart_src="$PLATFORM_CHART"
  else
    helm pull "$PLATFORM_CHART" --version "$platform_chart_version" --destination "$WORKDIR" \
      || die "cannot pull $PLATFORM_CHART --version $platform_chart_version"
    chart_src=$(ls "$WORKDIR"/glueops-platform-*.tgz)
  fi
  helm template glueops-platform "$chart_src" >"$WORKDIR/platform.yaml" \
    || die "helm template of the platform chart $platform_chart_version failed"

  # app_field NAME EXPR — yq expression evaluated on the Application named NAME
  app_field() {
    local value
    value=$(yq -N "select(.kind==\"Application\" and .metadata.name==\"$1\") | $2" "$WORKDIR/platform.yaml")
    [ -n "$value" ] && [ "$value" != "null" ] || die "Application $1: $2 not found in the rendered platform chart $platform_chart_version"
    echo "$value"
  }

  # compare LABEL EXPECTED ACTUAL — after the shared normalisation (strip a leading v on both sides)
  compare() {
    local label=$1 expected=$2 actual=$3
    if [ "$(strip_v "$expected")" = "$(strip_v "$actual")" ]; then
      ok "(b) $label: bundle pin $expected == platform $actual"
    else
      fail "(b) $label: platform-crds v$crds_chart_version bundles CRDs for $expected but the platform chart $glueops_platform_version deploys $actual"
    fi
  }

  # Application name -> bundle pin annotation key. targetRevision is the chart version deployed.
  compare "kube-prometheus-stack" "$(pin kube-prometheus-stack)" "$(app_field kube-prometheus-stack .spec.source.targetRevision)"
  compare "cert-manager" "$(pin cert-manager)" "$(app_field cert-manager .spec.source.targetRevision)"
  compare "external-secrets" "$(pin external-secrets)" "$(app_field external-secrets .spec.source.targetRevision)"
  compare "keda" "$(pin keda)" "$(app_field keda .spec.source.targetRevision)"
  for traefik_app in glueops-core-platform-traefik glueops-core-public-traefik glueops-core-internal-traefik; do
    compare "traefik ($traefik_app)" "$(pin traefik)" "$(app_field "$traefik_app" .spec.source.targetRevision)"
  done
  compare "metacontroller" "$(pin metacontroller)" "$(app_field metacontroller .spec.source.targetRevision)"
  compare "fluent-operator" "$(pin fluent-operator)" "$(app_field fluent-operator .spec.source.targetRevision)"
  # external-dns is deployed from a git tag named external-dns-helm-chart-X.Y.Z; the bundle pins X.Y.Z
  external_dns_rev=$(app_field external-dns .spec.source.targetRevision)
  compare "external-dns" "$(pin external-dns)" "${external_dns_rev#external-dns-helm-chart-}"
  # vpa: the CRDs come from kubernetes/autoscaler at the VPA *image* version, not the fairwinds chart
  # version, so compare container_images.app_vpa.recommender.image.tag as rendered into the Application
  vpa_tag=$(app_field glueops-core-vpa '.spec.source.helm.values' | yq -r '.recommender.image.tag // ""')
  [ -n "$vpa_tag" ] || die "Application glueops-core-vpa: recommender.image.tag not found in helm values"
  compare "vpa (recommender image tag)" "$(pin vpa)" "$vpa_tag"
  # argo-cd CRDs are in the bundle too; argocd itself is installed by captain_utils at local.argocd_app_version
  compare "argo-cd" "$(pin argo-cd)" "$argocd_app_version"
  # every pin the bundle carries must have a comparison rule above (an unknown pin means a new CRD source the
  # platform chart may not deploy, or a rule that still needs writing)
  known_pins="kube-prometheus-stack cert-manager external-secrets keda traefik metacontroller fluent-operator external-dns vpa argo-cd"
  while IFS= read -r key; do
    [ -n "$key" ] || continue
    case " $known_pins " in *" $key "*) ;; *) fail "(b) bundle pin glueops.dev/pin.$key has no comparison rule in hack/versions-consistency.sh — add one (and add $key to known_pins)";; esac
  done < <(yq -r '.annotations // {} | keys | .[] | select(test("^glueops\\.dev/pin\\.")) | sub("^glueops\\.dev/pin\\."; "")' "$WORKDIR/crds-chart.yaml")
fi

# ---------------------------------------------------------------------------
# (d) the pinned codespace ships a captain_utils with the `crds` menu item that the generated tenant README documents
codespace_version=$(tf_local codespace_version)
cu_url="https://raw.githubusercontent.com/GlueOps/codespaces/${codespace_version}/.devcontainer/tools/captain_utils.sh"
if curl -fsSL "$cu_url" -o "$WORKDIR/captain_utils.sh"; then
  if grep -q 'handle_crds' "$WORKDIR/captain_utils.sh"; then ok "(d) codespace $codespace_version ships the captain_utils crds menu item"
  else fail "(d) codespace $codespace_version has no crds menu item; bump codespace_version to a release containing GlueOps/codespaces#566"; fi
else
  fail "(d) cannot fetch $cu_url"
fi

if [ "${#failures[@]}" -gt 0 ]; then
  echo
  echo "${#failures[@]} consistency check(s) failed:" >&2
  for f in "${failures[@]}"; do echo "  - $f" >&2; done
  exit 1
fi
echo
echo "all version consistency checks passed"
