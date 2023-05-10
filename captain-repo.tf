module "captain_repository" {
  for_each       = local.environment_map
  source         = "./modules/github-captain-repository"
  repostory_name = "${each.value}.${aws_route53_zone.main.name}"
  files_to_create = {
    "argocd.yaml"                          = module.argocd_helm_values[each.value].helm_values
    "platform.yaml"                        = module.glueops_platform_helm_values[each.value].helm_values
    "terraform/kubernetes/.gitkeep"        = ""
    "terraform/vault/vault-init/main.tf"   = <<EOT
module "initialize_vault_cluster" {
  source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-initialization.git"
}

EOT
    "terraform/vault/vault-config/main.tf" = <<EOT
module "configure_vault_cluster" {
    source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-configuration.git"
    oidc_client_secret = "${random_password.dex_vault_client_secret[each.key].result}"
    captain_domain = "${each.value}.${aws_route53_zone.main.name}"
    org_team_policy_mappings = [
      ${join(",\n    ", [for mapping in each.value.vault_github_org_team_policy_mappings : "{ oidc_groups = ${jsonencode(mapping.oidc_groups)}, policy_name = \"${mapping.policy_name}\" }"])}
    ]
}

EOT
  }
}

