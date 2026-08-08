#!/usr/bin/env bash
# Generates the moved blocks needed to migrate a tenant repo from the legacy
# monolithic call (module "tenant" sourcing this repo's pre-split root) to
# direct per-cluster module calls (module "tenant_base" + one
# module "cluster_<environment_name>" block per cluster environment).
#
# Usage, in the tenant repo AFTER rewriting tenant.tf, with this repo checked
# out at the ref the new tenant_base/cluster_* blocks pin:
#   bash /path/to/this-repo/docs/generate-moved-blocks.sh > moved-migration.tf
# The checkout/pin match is enforced: the script aborts when the ?ref= pins in
# the tenant's .tf files do not match what this checkout is at (set
# ALLOW_REF_MISMATCH=1 to override deliberately).
#
# Environment names are derived from the module "cluster_<env>" labels in
# the root .tf files (pass them explicitly as arguments to override).
#
# No state access needed: the full address set is derived from the module
# sources — shared resource/module names from modules/tenant-base, and
# (per-environment names from modules/captain-cluster) x (environment names).
# Blocks for instances that do not exist in a tenant's state (e.g.
# generate_gluekube_creds for environments without provider_credentials) are
# ignored by tofu — emitting them unconditionally is safe.
#
# The output is chained (hop 1 relocates legacy root-level addresses into the
# tenant-base/captain-cluster shape, hop 2 splits them out to the new module
# blocks), and tofu follows the chain — so the moves resolve cleanly
# regardless of which module version the tenant last applied. Verified
# empirically from both state forms: moves only, 0/0/0. Address-independence
# does NOT cover generated-file content: a tenant whose last applied release
# predates the latest pre-split tag also sees in-place changes at the gate —
# apply that tag first (see docs/migration/MIGRATION.md, Prerequisite).
#
# Assumptions:
#   - the old call is named module "tenant" (set OLD_MODULE_LABEL if the tenant
#     named it something else; generate-migration.sh detects and passes it
#     automatically) and is DELETED in the same PR (OpenTofu rejects moved
#     blocks whose "from" is still declared in config)
#   - the new per-cluster blocks are named module "cluster_<environment_name>"
#   - every cluster block passes cluster_environments = [<that one environment>]
#     so all for_each keys keep their environment name
#
# The migration PR's CI plan must show ONLY "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy." Delete moved-migration.tf in a
# follow-up PR once the migration has applied.
set -euo pipefail

# label of the legacy module call in the tenant repo (state addresses derive
# from it). Overridable because tenants may have named the call anything.
OLD_LABEL="${OLD_MODULE_LABEL:-tenant}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# the moved-block inventory is derived from THIS checkout, while the tenant's
# new module blocks apply whatever their ?ref= pins name — a mismatch
# generates moves for the wrong module shape. describe works for tag clones
# (git clone --branch vX.Y.Z); the branch-name fallback covers branch pins.
if ls ./*.tf > /dev/null 2>&1 && [ "${ALLOW_REF_MISMATCH:-}" != "1" ]; then
  checkout_at="$(git -C "$REPO_ROOT" describe --tags --exact-match 2> /dev/null \
    || git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2> /dev/null || echo unknown)"
  pinned_refs="$(grep -hoE 'terraform-module-cloud-multy-prerequisites[^"]*[?&]ref=[^"&]+' ./*.tf 2> /dev/null \
    | sed -E 's/.*[?&]ref=//' | sort -u)"
  for r in $pinned_refs; do
    if [ "$r" != "$checkout_at" ]; then
      echo "tenant .tf files pin ?ref=$r but this checkout is at '$checkout_at' — the moved" >&2
      echo "blocks would describe a different module shape than tenants apply. Re-clone at" >&2
      echo "the pinned ref (git clone --depth 1 --branch $r …), or set ALLOW_REF_MISMATCH=1" >&2
      echo "if you know the two match." >&2
      exit 1
    fi
  done
fi

# every resource/module name declared in a module dir, skipping heredoc bodies
# (generated-file templates contain blocks that are text, not declarations)
inventory() {
  awk '
    FNR == 1 { inheredoc = 0 }
    inheredoc { if ($0 ~ ("^[[:space:]]*" tag "$")) inheredoc = 0; next }
    /^[[:space:]]*(#|\/\/)/ { next }
    /<<-?[A-Za-z_][A-Za-z0-9_]*[[:space:]]*$/ {
      tmp = $0
      sub(/.*<<-?/, "", tmp)
      sub(/[^A-Za-z0-9_].*/, "", tmp)
      if (tmp != "") { tag = tmp; inheredoc = 1 }
    }
    { print }
  ' "$1"/*.tf \
    | grep -oE '^(resource "[a-z0-9_]+" "[a-z0-9_]+"|module "[a-z0-9_]+")' \
    | sed -E 's/^resource "([^"]+)" "([^"]+)"$/\1.\2/; s/^module "([^"]+)"$/module.\1/' \
    | sort -u
}

if [ $# -eq 0 ]; then
  # derive environment names from the root .tf files in the current directory:
  # only module "cluster_<env>" blocks that actually source //modules/captain-cluster
  # count (a pre-existing unrelated module that happens to be named cluster_*
  # must not produce moved blocks)
  ls ./*.tf > /dev/null 2>&1 || { echo "no .tf files in current directory; pass environment names explicitly" >&2; exit 1; }
  if grep -qE "^module \"$OLD_LABEL\"" ./*.tf; then
    echo "a root .tf file still declares module \"$OLD_LABEL\" — delete the old call first" >&2
    exit 1
  fi
  envs=$(awk '
    FNR == 1 { pending = "" }
    /^module "cluster_[A-Za-z0-9_-]+"[[:space:]]*\{/ {
      # extract the label from the quoted string itself — never from a
      # whitespace-delimited field, which a brace hugging the closing quote
      # (module "cluster_x"{) would corrupt into an invalid address
      lbl = $0
      sub(/^module "cluster_/, "", lbl)
      sub(/".*$/, "", lbl)
      pending = lbl
      next
    }
    pending != "" && $0 ~ /^[[:space:]]*source[[:space:]]*=/ {
      if ($0 ~ /\/\/modules\/captain-cluster/) print pending
      pending = ""
    }
    /^\}/ { pending = "" }
  ' ./*.tf | sort -u)
  [ -n "$envs" ] || { echo 'no module "cluster_<env>" blocks sourcing //modules/captain-cluster found in root .tf files' >&2; exit 1; }
  # shellcheck disable=SC2086
  set -- $envs
fi

# hop 1: legacy root-level addresses -> tenant-base/captain-cluster shape.
# Pure prefix rewrites; no-ops for state already past this hop.
inventory "$REPO_ROOT/modules/tenant-base" | while IFS= read -r name; do
  printf 'moved {\n  from = module.%s.%s\n  to   = module.%s.module.tenant_base.%s\n}\n\n' "$OLD_LABEL" "$name" "$OLD_LABEL" "$name"
done
inventory "$REPO_ROOT/modules/captain-cluster" | while IFS= read -r name; do
  printf 'moved {\n  from = module.%s.%s\n  to   = module.%s.module.captain_cluster.%s\n}\n\n' "$OLD_LABEL" "$name" "$OLD_LABEL" "$name"
done

# hop 2: tenant-base/captain-cluster shape -> the new per-cluster blocks
printf 'moved {\n  from = module.%s.module.tenant_base\n  to   = module.tenant_base\n}\n' "$OLD_LABEL"

inventory "$REPO_ROOT/modules/captain-cluster" | while IFS= read -r name; do
  for env in "$@"; do
    printf '\nmoved {\n  from = module.%s.module.captain_cluster.%s["%s"]\n  to   = module.cluster_%s.%s["%s"]\n}\n' "$OLD_LABEL" "$name" "$env" "$env" "$name" "$env"
  done
done
