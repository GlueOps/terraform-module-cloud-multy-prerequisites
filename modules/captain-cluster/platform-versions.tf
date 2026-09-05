# GlueOps platform component version pins (NOT terraform/provider requirements —
# those live in providers.tf). These are the values a cluster upgrades to when
# its ?ref= pin moves to the release carrying this file.
locals {
  argocd_app_version        = "v3.2.12"
  codespace_version         = "v0.161.1"
  argocd_helm_chart_version = "9.3.7"
  glueops_platform_version  = "v0.79.0" # keep in sync with the ?ref= of module.glueops_platform_helm_values in generate-helm-values.tf
  platform_crds_version     = "v0.1.4"  # pin of GlueOps/platform-crds (the layer-0 CRD bundle), applied by captain_utils `crds` before argocd and before the platform chart.
  # >= v0.1.3 ships CRDs for conditionally-deployed components in profile subcharts, selected from the cluster's
  # platform.yaml — it needs a codespace_version whose captain_utils renders with `helm template --include-crds`.
  calico_helm_chart_version = "v3.32.1"
  calico_ctl_version        = "v3.32.1"
  tigera_operator_version   = "v1.40.7"
  terraform_module_version  = "v0.51.0"
  gatekeeper_tag            = "v0.1.1@sha256:33f96e0ecc628078c00c68722a670fb72693860219219972503df0ee2c6a3ece"

}
