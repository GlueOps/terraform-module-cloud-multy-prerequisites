# GlueOps platform component version pins (NOT terraform/provider requirements —
# those live in providers.tf). These are the values a cluster upgrades to when
# its ?ref= pin moves to the release carrying this file.
locals {
  argocd_app_version        = "v3.2.22"
  codespace_version         = "v0.155.22"
  argocd_helm_chart_version = "9.3.22"
  glueops_platform_version  = "v0.76.0" # this also needs to be updated in the module.glueops_platform_helm_values // generate-helm-values.tf
  tools_version             = "v0.36.22"
  calico_helm_chart_version = "v3.31.22"
  calico_ctl_version        = "v3.31.22"
  tigera_operator_version   = "v1.40.22"
  terraform_module_version  = "v0.51.22"
  gatekeeper_tag            = "v0.1.22@sha256:33f96e0ecc628078c00c68722a670fb72693860219219972503df0ee2c6a3ece"

}
