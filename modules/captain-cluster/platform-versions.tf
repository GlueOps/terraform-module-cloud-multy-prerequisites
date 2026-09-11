# GlueOps platform component version pins (NOT terraform/provider requirements —
# those live in providers.tf). These are the values a cluster upgrades to when
# its ?ref= pin moves to the release carrying this file.
locals {
  argocd_app_version        = "v3.2.12"
  codespace_version         = "v0.161.1"
  argocd_helm_chart_version = "9.3.7"
  # MUST be a released chart version in https://helm.gpkg.io/platform. captain_utils
  # installs the platform chart ONLY from that repo -- `helm upgrade --install
  # glueops-platform glueops-platform/glueops-platform --version "$version"` -- so a
  # git branch name is passed to helm as a semver constraint and fails with
  # "improper constraint". The ?ref= in generate-helm-values.tf is a different thing:
  # that is a terraform module source and renders platform.yaml, not the chart.
  #
  # WARNING for venus: no RELEASED chart carries the OTel monitoring migration yet
  # (platform-helm-chart-platform#1486 is still open), so applying this version to a
  # cluster already running that stack removes application-monitoring.yaml. That
  # Application is helm-managed and carries resources-finalizer.argocd.argoproj.io,
  # so the delete cascades through its 11 child Applications and the 10 PVCs in
  # glueops-core-monitoring. Until #1486 and #1461 are released, venus is fed the
  # feat/otel-integration-venus branch through captain_utils' `custom` option
  # (glueops-platform -> custom -> local checkout), which is the supported path for
  # an unreleased chart. `helm history glueops-platform -n glueops-core` is then the
  # only record of what is actually running -- this pin will not describe it.
  glueops_platform_version = "v0.79.2"            # keep in sync with the ?ref= of module.glueops_platform_helm_values in generate-helm-values.tf. TODO(before merge): the release cut once BOTH #1486 and #1461 have landed on main
  platform_crds_version    = "feat/otel-20260902" # pin of GlueOps/platform-crds (the layer-0 CRD bundle), applied by captain_utils `crds` before argocd and before the platform chart.
  # DELIBERATELY not a release tag. captain_utils only enables the bundle when this matches ^v?[0-9]+\.[0-9]+\.[0-9]+$;
  # anything else keeps the legacy path (ArgoCD's CRDs from the argocd step, the rest already on the cluster). v0.1.4
  # IS release-shaped and would therefore enable the bundle — applying a set that drops the opentelemetry-operator CRDs
  # and downgrades kube-prometheus-stack off 86.1.0, which the monitoring stack above needs. This names the branch the
  # CRDs on these clusters actually came from until then. TODO(before merge): the v0.1.5 release cut from
  # platform-crds#68, which is the first release-shaped pin that is also correct.
  # >= v0.1.3 ships CRDs for conditionally-deployed components in profile subcharts, selected from the cluster's
  # platform.yaml — it needs a codespace_version whose captain_utils renders with `helm template --include-crds`.
  calico_helm_chart_version = "v3.31.4"
  calico_ctl_version        = "v3.31.4"
  tigera_operator_version   = "v1.40.7"
  terraform_module_version  = "v0.51.0"
  gatekeeper_tag            = "v0.1.1@sha256:33f96e0ecc628078c00c68722a670fb72693860219219972503df0ee2c6a3ece"

}
