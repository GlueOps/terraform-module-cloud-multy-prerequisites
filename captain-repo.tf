locals {

  provider_versions_tf_file = <<EOT
module "provider_versions" {
  source = "git::https://github.com/GlueOps/terraform-module-provider-versions.git?ref=v0.3.1"
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
    "argocd.yaml"                                        = module.argocd_helm_values[each.value.environment_name].helm_values
    "platform.yaml"                                      = module.glueops_platform_helm_values[each.value.environment_name].helm_values
    "README.md"                                          = module.tenant_readmes[each.value.environment_name].tenant_readme
    "terraform/kubernetes/provider_versions.tf"          = local.provider_versions_tf_file
    "terraform/vault/configuration/provider_versions.tf" = local.provider_versions_tf_file
    "terraform/gluekube/.tfvars"                         = module.generate_gluekube_creds[each.value.environment_name].gluekube_tfvars
    "VERSIONS/aws.yaml"                                  = module.tenant_cluster_versions[each.value.environment_name].tenant_cluster_versions
    "VERSIONS/glueops.yaml"                              = module.glueops_platform_versions[each.value.environment_name].platform_versions
    ".gitignore"                                         = <<EOT

.terraform
.terraform.lock.hcl
*.log

EOT

    "terraform/vault/configuration/main.tf" = <<EOT
module "configure_vault_cluster" {
    source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-configuration.git?ref=v0.11.0"
    oidc_client_secret = "${random_password.dex_vault_client_secret[each.key].result}"
    captain_domain = "${each.value.environment_name}.${aws_route53_zone.main.name}"
    org_team_policy_mappings = [
      ${join(",\n    ", [for mapping in each.value.vault_github_org_team_policy_mappings : "{ oidc_groups = ${jsonencode(mapping.oidc_groups)}, policy_name = \"${mapping.policy_name}\" }"])}
    ]

    aws_region     = "${var.primary_region}"
    aws_s3_bucket_name  = "${module.common_s3_v2.s3_multi_region_access_point_arn}"
    aws_s3_key_vault_secret_file     = "${aws_route53_zone.clusters[each.key].name}/${local.vault_access_tokens_s3_key}"
    aws_access_key = "${aws_iam_access_key.vault_init_s3_v2[each.value.environment_name].id}"
    aws_secret_key =   "${aws_iam_access_key.vault_init_s3_v2[each.value.environment_name].secret}"
}

EOT

    "manifests/README.md" = <<EOT
# Tenant Customizations go here

## Examples
- ArgoCD App Projects
- Tenant Application Repo Stacks
- RBAC

EOT
  }
}
