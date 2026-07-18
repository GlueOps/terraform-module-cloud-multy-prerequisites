output "captain_cluster_inputs" {
  description = "Non-secret shared tenant values consumed by each captain-cluster module instantiation."
  value = {
    tenant_key                                                 = var.tenant_key
    tenant_account_id                                          = var.tenant_account_id
    this_is_development                                        = var.this_is_development
    primary_region                                             = var.primary_region
    backup_region                                              = var.backup_region
    github_owner                                               = var.github_owner
    parent_zone_id                                             = aws_route53_zone.main.zone_id
    parent_zone_name                                           = aws_route53_zone.main.name
    management_tenant_dns_zone_name                            = data.aws_route53_zone.management_tenant_dns.name
    dnssec_kms_key_arn                                         = module.dnssec_key.kms_key_arn
    s3_multi_region_access_point_arn                           = module.common_s3_v2.s3_multi_region_access_point_arn
    s3_multi_region_access_point_arn_for_object_level_policies = module.common_s3_v2.s3_multi_region_access_point_arn_for_object_level_policies
    s3_primary_arn                                             = module.common_s3_v2.s3_primary_arn
    s3_replica_arn                                             = module.common_s3_v2.s3_replica_arn
    tls_cert_backup_s3_key_prefix                              = module.common_s3_v2.tls_cert_backup_s3_key_prefix
    vault_backup_s3_key_prefix                                 = module.common_s3_v2.vault_backup_s3_key_prefix
    autoglue_credential_route53_id                             = autoglue_credential.route53.id
  }
}

output "captain_cluster_secrets" {
  description = "Shared tenant secrets consumed by each captain-cluster module instantiation. Kept separate from captain_cluster_inputs so the non-secret bundle stays readable in plans."
  sensitive   = true
  value = {
    autoglue_iam = {
      access_key_id     = aws_iam_access_key.autoglue.id
      secret_access_key = aws_iam_access_key.autoglue.secret
    }
    autoglue_credentials = var.autoglue_credentials
  }
}
