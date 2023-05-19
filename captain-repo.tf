module "captain_repository" {
  for_each        = local.environment_map
  source          = "./modules/github-captain-repository/0.1.0"
  repository_name = "${each.value.environment_name}.${aws_route53_zone.main.name}"
  files_to_create = {
    "argocd.yaml"   = module.argocd_helm_values[each.value.environment_name].helm_values
    "platform.yaml" = module.glueops_platform_helm_values[each.value.environment_name].helm_values
    "README.md"     = module.tenant_readmes[each.value.environment_name].tenant_readme

    "${each.value.tenant_github_org_name}-glueops-${var.tenant_key}-${each.value.environment_name}-stack.pub" = tls_private_key.tenant_stack_repostory_key[each.value.environment_name].public_key_openssh
    "terraform/kubernetes/.gitkeep"                                                                           = ""
    ".gitignore"                                                                                              = <<EOT

.terraform
.terraform.lock.hcl

EOT
    "terraform/vault/initialization/main.tf"                                                                  = <<EOT
module "initialize_vault_cluster" {
  source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-initialization.git?ref=v0.3.0"
}

EOT
    "terraform/vault/configuration/main.tf"                                                                   = <<EOT
module "configure_vault_cluster" {
    source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-configuration.git?ref=v0.4.3"
    oidc_client_secret = "${random_password.dex_vault_client_secret[each.key].result}"
    captain_domain = "${each.value.environment_name}.${aws_route53_zone.main.name}"
    org_team_policy_mappings = [
      ${join(",\n    ", [for mapping in each.value.vault_github_org_team_policy_mappings : "{ oidc_groups = ${jsonencode(mapping.oidc_groups)}, policy_name = \"${mapping.policy_name}\" }"])}
    ]
}

EOT
  }
}
