module "captain_repository" {
  for_each       = local.cluster_environments
  source         = "./modules/github-captain-repository"
  repostory_name = "${each.value}.${aws_route53_zone.main.name}"
  files_to_create = {
    "argocd.yaml"                          = module.argocd_helm_values[each.value].helm_values
    "platform.yaml"                        = module.glueops_platform_helm_values[each.value].helm_values
    "terraform/kubernetes/main.tf"         = "//tf goes here"
    "terraform/vault/vault-init/main.tf"   = <<EOT
module "initialize_vault_cluster" {
  source = "git::https://github.com/GlueOps/terraform-module-kubernetes-hashicorp-vault-initialization.git"
}
EOT
    "terraform/vault/vault-config/main.tf" = "//tf goes here"
  }
}