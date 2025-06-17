module "glueops_platform_versions" {
  source   = "./modules/platform-chart-version/0.1.0"
  for_each = local.environment_map

  argocd_helm_chart_version = local.argocd_helm_chart_version
  glueops_platform_version  = local.glueops_platform_version
}
