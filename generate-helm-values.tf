
locals {
  random_password_length             = 45
  random_password_special_characters = false
}
resource "random_password" "dex_argocd_client_secret" {
  for_each = local.cluster_environments
  length   = local.random_password_length
  special  = local.random_password_special_characters
}

resource "random_password" "dex_grafana_client_secret" {
  for_each = local.cluster_environments
  length   = local.random_password_length
  special  = local.random_password_special_characters
}

resource "random_password" "dex_vault_client_secret" {
  for_each = local.cluster_environments
  length   = local.random_password_length
  special  = local.random_password_special_characters
}

resource "random_password" "dex_pomerium_client_secret" {
  for_each = local.cluster_environments
  length   = local.random_password_length
  special  = local.random_password_special_characters
}


module "glueops_platform_helm_values" {
  for_each                     = local.cluster_environments
  source                       = "git::https://github.com/GlueOps/platform-helm-chart-platform.git?ref=feat/adding-terraform-values-generation"
  dex_github_client_id         = "435asdsadsad0"
  dex_github_client_secret     = "9f583cssssss8214bb0asdca7c"
  dex_argocd_client_secret     = random_password.dex_argocd_client_secret[each.key].result
  dex_grafana_client_secret    = random_password.dex_grafana_client_secret[each.key].result
  dex_vault_client_secret      = random_password.dex_vault_client_secret[each.key].result
  dex_pomerium_client_secret   = random_password.dex_pomerium_client_secret[each.key].result
  vault_aws_access_key         = aws_iam_access_key.vault_s3[each.value].id
  vault_aws_secret_key         = aws_iam_access_key.vault_s3[each.value].secret
  loki_aws_access_key          = aws_iam_access_key.loki_s3[each.value].id
  loki_aws_secret_key          = aws_iam_access_key.loki_s3[each.value].secret
  loki_exporter_aws_access_key = aws_iam_access_key.loki_log_exporter_s3[each.value].id
  loki_exporter_aws_secret_key = aws_iam_access_key.loki_log_exporter_s3[each.value].secret
  certmanager_aws_access_key   = aws_iam_access_key.certmanager[each.value].id
  certmanager_aws_secret_key   = aws_iam_access_key.certmanager[each.value].secret
  externaldns_aws_access_key   = aws_iam_access_key.externaldns[each.value].id
  externaldns_aws_secret_key   = aws_iam_access_key.externaldns[each.value].secret
  glueops_root_domain          = data.aws_route53_zone.management_tenant_dns.name
  cluster_environment          = each.value
  aws_region                   = var.primary_region
  tenant_key                   = var.company_key
  opsgenie_api_key             = lookup(module.opsgenie_teams.opsgenie_prometheus_api_keys, split(".", each.value)[0], null)
}


resource "aws_s3_object" "platform_helm_values" {
  for_each = local.cluster_environments

  provider = aws.primaryregion
  bucket   = module.common_s3.primary_s3_bucket_id
  key      = "${each.value}.${aws_route53_zone.main.name}/configurations/platform.yaml"
  content  = module.glueops_platform_helm_values[each.value].helm_values

  content_type           = "application/json"
  server_side_encryption = "AES256"
  acl                    = "private"
}

module "argocd_helm_values" {
  for_each                    = local.cluster_environments
  source                      = "git::https://github.com/GlueOps/docs-argocd.git?ref=feat/adding-terraform-values-generation"
  tenant_key                  = var.company_key
  cluster_environment         = each.value
  client_secret               = random_password.dex_argocd_client_secret[each.key].result
  glueops_root_domain         = data.aws_route53_zone.management_tenant_dns.name
  argocd_tenant_rbac_policies = var.argocd_tenant_rbac_policies
}


resource "aws_s3_object" "argocd_helm_values" {
  for_each = local.cluster_environments

  provider = aws.primaryregion
  bucket   = module.common_s3.primary_s3_bucket_id
  key      = "${each.value}.${aws_route53_zone.main.name}/configurations/argocd.yaml"
  content  = module.argocd_helm_values[each.value].helm_values

  content_type           = "application/json"
  server_side_encryption = "AES256"
  acl                    = "private"
}


