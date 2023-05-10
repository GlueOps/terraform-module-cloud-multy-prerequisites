module "captain_repository" {
  for_each       = local.cluster_environments
  source         = "./modules/github-captain-repository"
  repostory_name = "${each.value}.${aws_route53_zone.main.name}"
  files_to_create = {
    "argocd.yaml"   = module.argocd_helm_values[each.value].helm_values
    "platform.yaml" = module.platform_helm_values[each.value].helm_values

  }
}