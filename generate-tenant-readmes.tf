module "tenant_readmes" {
  source   = "./modules/tenant-readme/0.1.0"
  for_each = local.environment_map

  placeholder_github_owner = var.github_owner
  repository_name          = "${each.value.environment_name}.${aws_route53_zone.main.name}"
  tenant_key               = var.tenant_key
  cluster_environment      = each.value.environment_name
}
