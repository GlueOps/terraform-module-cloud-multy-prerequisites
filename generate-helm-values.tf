
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


resource "random_password" "grafana_admin_secret" {
  for_each = local.cluster_environments
  length   = local.random_password_length
  special  = local.random_password_special_characters
}

resource "tls_private_key" "tenant_stack_repostory_key" {
  for_each  = local.cluster_environments
  algorithm = "ED25519"
}


module "glueops_platform_helm_values" {
  for_each                      = local.environment_map
  source                        = "git::https://github.com/GlueOps/platform-helm-chart-platform.git?ref=feat/adding-terraform-values-generation"
  dex_github_client_id          = each.value.github_app_client_id
  dex_github_client_secret      = each.value.github_app_client_secret
  dex_argocd_client_secret      = random_password.dex_argocd_client_secret[each.value.environment_name].result
  dex_grafana_client_secret     = random_password.dex_grafana_client_secret[each.value.environment_name].result
  dex_vault_client_secret       = random_password.dex_vault_client_secret[each.value.environment_name].result
  dex_pomerium_client_secret    = random_password.dex_pomerium_client_secret[each.value.environment_name].result
  vault_aws_access_key          = aws_iam_access_key.vault_s3[each.value.environment_name].id
  vault_aws_secret_key          = aws_iam_access_key.vault_s3[each.value.environment_name].secret
  loki_aws_access_key           = aws_iam_access_key.loki_s3[each.value.environment_name].id
  loki_aws_secret_key           = aws_iam_access_key.loki_s3[each.value.environment_name].secret
  loki_exporter_aws_access_key  = aws_iam_access_key.loki_log_exporter_s3[each.value.environment_name].id
  loki_exporter_aws_secret_key  = aws_iam_access_key.loki_log_exporter_s3[each.value.environment_name].secret
  certmanager_aws_access_key    = aws_iam_access_key.certmanager[each.value.environment_name].id
  certmanager_aws_secret_key    = aws_iam_access_key.certmanager[each.value.environment_name].secret
  externaldns_aws_access_key    = aws_iam_access_key.externaldns[each.value.environment_name].id
  externaldns_aws_secret_key    = aws_iam_access_key.externaldns[each.value.environment_name].secret
  glueops_root_domain           = data.aws_route53_zone.management_tenant_dns.name
  cluster_environment           = each.value.environment_name
  aws_region                    = var.primary_region
  tenant_key                    = var.company_key
  opsgenie_api_key              = lookup(module.opsgenie_teams.opsgenie_prometheus_api_keys, split(".", each.value.environment_name)[0], null)
  admin_github_org_name         = var.admin_github_org_name
  tenant_github_org_name        = var.tenant_github_org_name
  grafana_admin_password        = random_password.grafana_admin_secret[each.value.environment_name].result
  tenant_b64enc_ssh_private_key = base64encode(tls_private_key.tenant_stack_repostory_key[each.value.environment_name].private_key_pem)
  github_api_token              = var.github_api_token
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
  for_each             = local.environment_map
  source               = "git::https://github.com/GlueOps/docs-argocd.git?ref=feat/adding-terraform-values-generation"
  tenant_key           = var.company_key
  cluster_environment  = each.value.environment_name
  client_secret        = random_password.dex_argocd_client_secret[each.value.environment_name].result
  glueops_root_domain  = data.aws_route53_zone.management_tenant_dns.name
  argocd_rbac_policies = var.argocd_rbac_policies
}


resource "aws_s3_object" "argocd_helm_values" {
  for_each = local.environment_map

  provider = aws.primaryregion
  bucket   = module.common_s3.primary_s3_bucket_id
  key      = "${each.value.environment_name}.${aws_route53_zone.main.name}/configurations/argocd.yaml"
  content  = module.argocd_helm_values[each.value.environment_name].helm_values

  content_type           = "application/json"
  server_side_encryption = "AES256"
  acl                    = "private"
}


