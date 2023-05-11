module "tenant_readmes" {
  source   = "./modules/tenant-readme"
  for_each = local.environment_map

  placeholder_github_owner = var.GITHUB_OWNER
  repository_name          = "${each.value.environment_name}.${aws_route53_zone.main.name}"
  company_key              = var.company_key
  cluster_environment      = each.value.environment_name
}
