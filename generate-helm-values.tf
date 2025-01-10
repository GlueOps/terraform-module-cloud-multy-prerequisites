
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

locals {
  vault_access_tokens_s3_key          = "hashicorp-vault-init/vault_access.json"
  tls_cert_backup_s3_key_prefix       = "tls-cert-backups"
  tls_cert_restore_exclude_namespaces = "kube-system"
}

module "glueops_platform_helm_values" {
  for_each                                   = local.environment_map
  source                                     = "git::https://github.com/GlueOps/platform-helm-chart-platform.git?ref=v0.54.0"
  captain_repo_b64encoded_private_deploy_key = base64encode(module.captain_repository[each.value.environment_name].private_deploy_key)
  captain_repo_ssh_clone_url                 = module.captain_repository[each.value.environment_name].ssh_clone_url
  this_is_development                        = var.this_is_development
  dex_github_client_id                       = each.value.github_oauth_app_client_id
  dex_github_client_secret                   = each.value.github_oauth_app_client_secret
  dex_argocd_client_secret                   = random_password.dex_argocd_client_secret[each.value.environment_name].result
  dex_grafana_client_secret                  = random_password.dex_grafana_client_secret[each.value.environment_name].result
  dex_vault_client_secret                    = random_password.dex_vault_client_secret[each.value.environment_name].result
  dex_pomerium_client_secret                 = random_password.dex_pomerium_client_secret[each.value.environment_name].result
  vault_aws_access_key                       = aws_iam_access_key.vault_s3[each.value.environment_name].id
  vault_aws_secret_key                       = aws_iam_access_key.vault_s3[each.value.environment_name].secret
  loki_aws_access_key                        = aws_iam_access_key.loki_s3[each.value.environment_name].id
  loki_aws_secret_key                        = aws_iam_access_key.loki_s3[each.value.environment_name].secret
  certmanager_aws_access_key                 = aws_iam_access_key.certmanager[each.value.environment_name].id
  certmanager_aws_secret_key                 = aws_iam_access_key.certmanager[each.value.environment_name].secret
  externaldns_aws_access_key                 = aws_iam_access_key.externaldns[each.value.environment_name].id
  externaldns_aws_secret_key                 = aws_iam_access_key.externaldns[each.value.environment_name].secret
  glueops_root_domain                        = data.aws_route53_zone.management_tenant_dns.name
  cluster_environment                        = each.value.environment_name
  aws_region                                 = var.primary_region
  tenant_key                                 = var.tenant_key
  opsgenie_api_key                           = lookup(module.opsgenie_teams.opsgenie_prometheus_api_keys, split(".", each.value.environment_name)[0], null)
  admin_github_org_name                      = each.value.admin_github_org_name
  tenant_github_org_name                     = each.value.tenant_github_org_name
  grafana_admin_password                     = random_password.grafana_admin_secret[each.value.environment_name].result
  github_tenant_app_id                       = each.value.github_tenant_app_id
  github_tenant_app_installation_id          = each.value.github_tenant_app_installation_id
  github_tenant_app_b64enc_private_key       = each.value.github_tenant_app_b64enc_private_key
  host_network_enabled                       = each.value.host_network_enabled
  vault_init_controller_s3_key               = "${aws_route53_zone.clusters[each.value.environment_name].name}/${local.vault_access_tokens_s3_key}"
  vault_init_controller_aws_access_key       = aws_iam_access_key.vault_init_s3[each.value.environment_name].id
  vault_init_controller_aws_access_secret    = aws_iam_access_key.vault_init_s3[each.value.environment_name].secret
  tls_cert_backup_aws_access_key             = aws_iam_access_key.tls_cert_backup_s3[each.value.environment_name].id
  tls_cert_backup_aws_secret_key             = aws_iam_access_key.tls_cert_backup_s3[each.value.environment_name].secret
  tls_cert_backup_s3_key_prefix              = local.tls_cert_backup_s3_key_prefix
  tls_cert_restore_exclude_namespaces        = local.tls_cert_restore_exclude_namespaces
  tls_cert_restore_aws_access_key            = aws_iam_access_key.tls_cert_restore_s3[each.value.environment_name].id
  tls_cert_restore_aws_secret_key            = aws_iam_access_key.tls_cert_restore_s3[each.value.environment_name].secret
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
  source               = "git::https://github.com/GlueOps/docs-argocd.git?ref=v0.15.0"
  tenant_key           = var.tenant_key
  cluster_environment  = each.value.environment_name
  client_secret        = random_password.dex_argocd_client_secret[each.value.environment_name].result
  glueops_root_domain  = data.aws_route53_zone.management_tenant_dns.name
  argocd_rbac_policies = each.value.argocd_rbac_policies
  argocd_app_version   = local.argocd_app_version
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
