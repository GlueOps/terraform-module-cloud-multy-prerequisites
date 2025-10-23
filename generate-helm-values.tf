
locals {
  random_password_length             = 45
  oauth2_cookie_token_length         = 32
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


resource "random_password" "dex_oauth2_client_secret" {
  for_each = local.cluster_environments
  length   = local.random_password_length
  special  = local.random_password_special_characters
}

resource "random_password" "dex_oauth2_cookie_secret" {
  for_each = local.cluster_environments
  length   = local.oauth2_cookie_token_length
  special  = local.random_password_special_characters
}

resource "random_password" "grafana_admin_secret" {
  for_each = local.cluster_environments
  length   = local.random_password_length
  special  = local.random_password_special_characters
}

locals {
  vault_access_tokens_s3_key          = "hashicorp-vault-init/vault_access.json"
  tls_cert_restore_exclude_namespaces = "kube-system"
}

module "glueops_platform_helm_values" {
  for_each                                   = local.environment_map
  source                                     = "git::https://github.com/GlueOps/platform-helm-chart-platform.git?ref=feat/migrate-to-openbao"
  captain_repo_b64encoded_private_deploy_key = base64encode(module.captain_repository[each.value.environment_name].private_deploy_key)
  captain_repo_ssh_clone_url                 = module.captain_repository[each.value.environment_name].ssh_clone_url
  this_is_development                        = var.this_is_development
  dex_github_client_id                       = each.value.github_oauth_app_client_id
  dex_github_client_secret                   = each.value.github_oauth_app_client_secret
  dex_argocd_client_secret                   = random_password.dex_argocd_client_secret[each.value.environment_name].result
  dex_grafana_client_secret                  = random_password.dex_grafana_client_secret[each.value.environment_name].result
  dex_vault_client_secret                    = random_password.dex_vault_client_secret[each.value.environment_name].result
  dex_oauth2_client_secret                   = random_password.dex_oauth2_client_secret[each.value.environment_name].result
  dex_oauth2_cookie_secret                   = random_password.dex_oauth2_cookie_secret[each.value.environment_name].result
  vault_aws_access_key                       = aws_iam_access_key.vault_s3_backup_v2[each.value.environment_name].id
  vault_aws_secret_key                       = aws_iam_access_key.vault_s3_backup_v2[each.value.environment_name].secret
  loki_aws_access_key                        = aws_iam_access_key.loki_s3_v2[each.value.environment_name].id
  loki_aws_secret_key                        = aws_iam_access_key.loki_s3_v2[each.value.environment_name].secret
  certmanager_aws_access_key                 = aws_iam_access_key.certmanager_v2[each.value.environment_name].id
  certmanager_aws_secret_key                 = aws_iam_access_key.certmanager_v2[each.value.environment_name].secret
  externaldns_aws_access_key                 = aws_iam_access_key.externaldns_v2[each.value.environment_name].id
  externaldns_aws_secret_key                 = aws_iam_access_key.externaldns_v2[each.value.environment_name].secret
  glueops_root_domain                        = data.aws_route53_zone.management_tenant_dns.name
  cluster_environment                        = each.value.environment_name
  aws_region                                 = var.primary_region
  tenant_key                                 = var.tenant_key
  admin_github_org_name                      = each.value.admin_github_org_name
  tenant_github_org_name                     = each.value.tenant_github_org_name
  grafana_admin_password                     = random_password.grafana_admin_secret[each.value.environment_name].result
  github_tenant_app_id                       = each.value.github_tenant_app_id
  github_tenant_app_installation_id          = each.value.github_tenant_app_installation_id
  github_tenant_app_b64enc_private_key       = each.value.github_tenant_app_b64enc_private_key
  host_network_enabled                       = each.value.host_network_enabled
  kubeadm_cluster                            = each.value.kubeadm_cluster
  vault_init_controller_s3_key               = "${aws_route53_zone.clusters[each.value.environment_name].name}/${local.vault_access_tokens_s3_key}"
  vault_init_controller_aws_access_key       = aws_iam_access_key.vault_init_s3_v2[each.value.environment_name].id
  vault_init_controller_aws_access_secret    = aws_iam_access_key.vault_init_s3_v2[each.value.environment_name].secret
  tls_cert_backup_aws_access_key             = aws_iam_access_key.tls_cert_backup_s3_v2[each.value.environment_name].id
  tls_cert_backup_aws_secret_key             = aws_iam_access_key.tls_cert_backup_s3_v2[each.value.environment_name].secret
  tls_cert_backup_s3_key_prefix              = module.common_s3_v2.tls_cert_backup_s3_key_prefix
  vault_backup_s3_key_prefix                 = module.common_s3_v2.vault_backup_s3_key_prefix
  tls_cert_restore_exclude_namespaces        = local.tls_cert_restore_exclude_namespaces
  tls_cert_restore_aws_access_key            = aws_iam_access_key.tls_cert_restore_s3_v2[each.value.environment_name].id
  tls_cert_restore_aws_secret_key            = aws_iam_access_key.tls_cert_restore_s3_v2[each.value.environment_name].secret
  tenant_s3_multi_region_access_point        = module.common_s3_v2.s3_multi_region_access_point_arn
}

module "argocd_helm_values" {
  for_each             = local.environment_map
  source               = "git::https://github.com/GlueOps/docs-argocd.git?ref=v0.16.0"
  tenant_key           = var.tenant_key
  cluster_environment  = each.value.environment_name
  client_secret        = random_password.dex_argocd_client_secret[each.value.environment_name].result
  glueops_root_domain  = data.aws_route53_zone.management_tenant_dns.name
  argocd_rbac_policies = each.value.argocd_rbac_policies
  argocd_app_version   = local.argocd_app_version
}
