module "tenant_readmes" {
  source   = "./modules/tenant-readme"
  for_each = local.environment_map

  placeholder_github_repo_path        = module.captain_repository.full_name
  repository_name     = "${each.value.environment_name}.${aws_route53_zone.main.name}"
  company_key         = var.company_key
  cluster_environment = each.value.environment_name
}