module "glueops_platform_versions" {
  source   = "./modules/platform-chart-version/0.1.0"
  for_each = local.environment_map

  argocd_helm_chart_version = local.argocd_helm_chart_version
  argocd_app_version        = local.argocd_app_version
  glueops_platform_version  = local.glueops_platform_version
  codespace_version         = local.codespace_version
  calico_helm_chart_version = local.calico_helm_chart_version
  tigera_operator_version   = local.tigera_operator_version
  calico_ctl_version        = local.calico_ctl_version
  terraform_module_version  = local.terraform_module_version
}
