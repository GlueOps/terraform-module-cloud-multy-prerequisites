# GlueOps platform component version pins (NOT terraform/provider requirements —
# those live in providers.tf). These are the values a cluster upgrades to when
# its ?ref= pin moves to the release carrying this file.
locals {
  argocd_app_version        = "v3.2.12"
  codespace_version         = "v0.160.0"
  argocd_helm_chart_version = "9.3.7"
  glueops_platform_version  = "feat/otel-extention-backend-app" # keep in sync with the ?ref= of module.glueops_platform_helm_values in generate-helm-values.tf. TODO(before merge): the release cut from platform-helm-chart-platform#1461
  platform_crds_version     = "v0.1.5-rc1"                      # pin of GlueOps/platform-crds (the layer-0 CRD bundle), applied by captain_utils `crds` before argocd and before the platform chart.
  # v0.1.5-rc1 is a prerelease tag cut from platform-crds#68 (kube-prometheus-stack 86.1.0 + opentelemetry-operator
  # CRDs) — the monitoring stack in the platform chart above cannot start without them, and v0.1.4 does not carry
  # them. TODO(before merge): move this to the stable release once #68 lands on main.
  # >= v0.1.3 ships CRDs for conditionally-deployed components in profile subcharts, selected from the cluster's
  # platform.yaml — it needs a codespace_version whose captain_utils renders with `helm template --include-crds`.
  calico_helm_chart_version = "v3.31.4"
  calico_ctl_version        = "v3.31.4"
  tigera_operator_version   = "v1.40.7"
  terraform_module_version  = "v0.51.0"
  gatekeeper_tag            = "v0.1.1@sha256:33f96e0ecc628078c00c68722a670fb72693860219219972503df0ee2c6a3ece"

}
