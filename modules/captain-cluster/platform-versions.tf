# GlueOps platform component version pins (NOT terraform/provider requirements —
# those live in providers.tf). These are the values a cluster upgrades to when
# its ?ref= pin moves to the release carrying this file.
locals {
  argocd_app_version        = "v3.2.12"
  codespace_version         = "v0.160.0"
  argocd_helm_chart_version = "9.3.7"
  glueops_platform_version  = "feat/otel-extention-backend-app" # keep in sync with the ?ref= of module.glueops_platform_helm_values in generate-helm-values.tf. TODO(before merge): the release cut from platform-helm-chart-platform#1461
  platform_crds_version     = "feat/otel-20260902"              # pin of GlueOps/platform-crds (the layer-0 CRD bundle), applied by captain_utils `crds` before argocd and before the platform chart.
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
