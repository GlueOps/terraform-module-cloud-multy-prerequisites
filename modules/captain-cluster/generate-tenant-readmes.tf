module "tenant_readmes" {
  source   = "../tenant-readme/0.1.0"
  for_each = local.environment_map

  placeholder_github_owner  = var.tenant.github_owner
  repository_name           = "${each.value.environment_name}.${var.tenant.parent_zone_name}"
  tenant_key                = var.tenant.tenant_key
  cluster_environment       = each.value.environment_name
  tenant_github_org_name    = each.value.tenant_github_org_name
  argocd_app_version        = local.argocd_app_version
  argocd_helm_chart_version = local.argocd_helm_chart_version
  glueops_platform_version  = local.glueops_platform_version
  tools_version             = local.tools_version
  codespace_version         = local.codespace_version
}
