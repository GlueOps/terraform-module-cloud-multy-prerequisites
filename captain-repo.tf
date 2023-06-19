locals {

  provider_versions_tf_file = <<EOT
module "provider_versions" {
  source = "git::https://github.com/GlueOps/terraform-module-provider-versions.git"
}

EOT



}

module "captain_repository" {
  for_each        = local.environment_map
  source          = "./modules/github-captain-repository/0.1.0"
  repository_name = "${each.value.environment_name}.${aws_route53_zone.main.name}"

}

module "captain_repository_files" {
  for_each        = local.environment_map
  source          = "./modules/github-captain-repository-files/0.1.0"
  repository_name = module.captain_repository[each.key].repository_name
  files_to_create = {
    "argocd.yaml"                                         = module.argocd_helm_values[each.value.environment_name].helm_values
    "platform.yaml"                                       = module.glueops_platform_helm_values[each.value.environment_name].helm_values
    "README.md"                                           = module.tenant_readmes[each.value.environment_name].tenant_readme
    "terraform/kubernetes/provider_versions.tf"           = local.provider_versions_tf_file
    "terraform/vault/initialization/provider_versions.tf" = local.provider_versions_tf_file
    "terraform/vault/configuration/provider_versions.tf"  = local.provider_versions_tf_file

    ".gitignore"                             = <<EOT

.terraform
.terraform.lock.hcl

EOT
    "terraform/vault/initialization/main.tf" = <<EOT
module "initialize_vault_cluster" {
  source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-initialization.git?ref=v0.4.0"
}

EOT
    "terraform/vault/configuration/main.tf"  = <<EOT
module "configure_vault_cluster" {
    source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-configuration.git?ref=v0.5.1"
    oidc_client_secret = "${random_password.dex_vault_client_secret[each.key].result}"
    captain_domain = "${each.value.environment_name}.${aws_route53_zone.main.name}"
    org_team_policy_mappings = [
      ${join(",\n    ", [for mapping in each.value.vault_github_org_team_policy_mappings : "{ oidc_groups = ${jsonencode(mapping.oidc_groups)}, policy_name = \"${mapping.policy_name}\" }"])}
    ]
}

EOT
  }
}
