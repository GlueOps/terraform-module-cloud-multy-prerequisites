# State migration for the tenant-base / captain-cluster split.
#
# Every moved block below is a pure prefix rewrite (no instance keys): for_each
# keys ride along automatically. Do NOT add instance-keyed moved blocks here —
# lifting a for_each key from resource level to module level is not supported
# and silently plans a destroy/create.
#
# These blocks must stay in place permanently: any tenant that has not applied
# since before the split still needs them.

# --- shared resources -> modules/tenant-base ---

moved {
  from = aws_route53_zone.main
  to   = module.tenant_base.aws_route53_zone.main
}

moved {
  from = aws_route53_record.delegation_to_parent_tenant_zone
  to   = module.tenant_base.aws_route53_record.delegation_to_parent_tenant_zone
}

moved {
  from = module.dnssec_key
  to   = module.tenant_base.module.dnssec_key
}

moved {
  from = aws_route53_key_signing_key.parent_tenant_zone
  to   = module.tenant_base.aws_route53_key_signing_key.parent_tenant_zone
}

moved {
  from = aws_route53_hosted_zone_dnssec.parent_tenant_zone
  to   = module.tenant_base.aws_route53_hosted_zone_dnssec.parent_tenant_zone
}

moved {
  from = aws_route53_record.enable_dnssec_for_parent_tenant_zone
  to   = module.tenant_base.aws_route53_record.enable_dnssec_for_parent_tenant_zone
}

moved {
  from = module.common_s3
  to   = module.tenant_base.module.common_s3
}

moved {
  from = module.common_s3_v2
  to   = module.tenant_base.module.common_s3_v2
}

moved {
  from = aws_iam_policy.route53_autoglue
  to   = module.tenant_base.aws_iam_policy.route53_autoglue
}

moved {
  from = random_uuid.route53_autoglue_aws_iam_policy
  to   = module.tenant_base.random_uuid.route53_autoglue_aws_iam_policy
}

moved {
  from = aws_iam_user.autoglue
  to   = module.tenant_base.aws_iam_user.autoglue
}

moved {
  from = aws_iam_user_policy_attachment.autoglue
  to   = module.tenant_base.aws_iam_user_policy_attachment.autoglue
}

moved {
  from = aws_iam_access_key.autoglue
  to   = module.tenant_base.aws_iam_access_key.autoglue
}

moved {
  from = random_uuid.autoglue_aws_iam_user
  to   = module.tenant_base.random_uuid.autoglue_aws_iam_user
}

moved {
  from = autoglue_credential.route53
  to   = module.tenant_base.autoglue_credential.route53
}

# --- per-cluster resources -> modules/captain-cluster ---

# DNS

moved {
  from = aws_route53_zone.clusters
  to   = module.captain_cluster.aws_route53_zone.clusters
}

moved {
  from = aws_route53_key_signing_key.cluster_zones
  to   = module.captain_cluster.aws_route53_key_signing_key.cluster_zones
}

moved {
  from = aws_route53_hosted_zone_dnssec.cluster_zones
  to   = module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones
}

moved {
  from = aws_route53_record.cluster_zone_dnssec_records
  to   = module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records
}

moved {
  from = aws_route53_record.cluster_zone_ns_records
  to   = module.captain_cluster.aws_route53_record.cluster_zone_ns_records
}

moved {
  from = aws_route53_record.wildcard_for_apps
  to   = module.captain_cluster.aws_route53_record.wildcard_for_apps
}

# Module calls

moved {
  from = module.loki_s3
  to   = module.captain_cluster.module.loki_s3
}

moved {
  from = module.glueops_platform_helm_values
  to   = module.captain_cluster.module.glueops_platform_helm_values
}

moved {
  from = module.argocd_helm_values
  to   = module.captain_cluster.module.argocd_helm_values
}

moved {
  from = module.captain_repository
  to   = module.captain_cluster.module.captain_repository
}

moved {
  from = module.captain_repository_files
  to   = module.captain_cluster.module.captain_repository_files
}

moved {
  from = module.glueops_platform_versions
  to   = module.captain_cluster.module.glueops_platform_versions
}

moved {
  from = module.tenant_cluster_versions
  to   = module.captain_cluster.module.tenant_cluster_versions
}

moved {
  from = module.tenant_readmes
  to   = module.captain_cluster.module.tenant_readmes
}

moved {
  from = module.generate_gluekube_creds
  to   = module.captain_cluster.module.generate_gluekube_creds
}

# Dex / Grafana secrets

moved {
  from = random_password.dex_argocd_client_secret
  to   = module.captain_cluster.random_password.dex_argocd_client_secret
}

moved {
  from = random_password.dex_grafana_client_secret
  to   = module.captain_cluster.random_password.dex_grafana_client_secret
}

moved {
  from = random_password.dex_vault_client_secret
  to   = module.captain_cluster.random_password.dex_vault_client_secret
}

moved {
  from = random_password.dex_oauth2_client_secret
  to   = module.captain_cluster.random_password.dex_oauth2_client_secret
}

moved {
  from = random_password.dex_oauth2_cookie_secret
  to   = module.captain_cluster.random_password.dex_oauth2_cookie_secret
}

moved {
  from = random_password.grafana_admin_secret
  to   = module.captain_cluster.random_password.grafana_admin_secret
}

# IAM policies + name uuids

moved {
  from = aws_iam_policy.loki_s3_v2
  to   = module.captain_cluster.aws_iam_policy.loki_s3_v2
}

moved {
  from = random_uuid.loki_v2_aws_iam_policy
  to   = module.captain_cluster.random_uuid.loki_v2_aws_iam_policy
}

moved {
  from = aws_iam_policy.route53_v2
  to   = module.captain_cluster.aws_iam_policy.route53_v2
}

moved {
  from = random_uuid.route53_v2_aws_iam_policy
  to   = module.captain_cluster.random_uuid.route53_v2_aws_iam_policy
}

moved {
  from = aws_iam_policy.tls_cert_backup_s3_v2
  to   = module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2
}

moved {
  from = random_uuid.tls_cert_backup_s3_v2_aws_iam_policy
  to   = module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy
}

moved {
  from = aws_iam_policy.tls_cert_restore_s3_v2
  to   = module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2
}

moved {
  from = random_uuid.tls_cert_restore_s3_v2_aws_iam_policy
  to   = module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy
}

moved {
  from = aws_iam_policy.vault_s3_backup_v2
  to   = module.captain_cluster.aws_iam_policy.vault_s3_backup_v2
}

moved {
  from = random_uuid.vault_s3_backup_v2_aws_iam_policy
  to   = module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy
}

moved {
  from = aws_iam_policy.vault_init_s3_v2
  to   = module.captain_cluster.aws_iam_policy.vault_init_s3_v2
}

moved {
  from = random_uuid.vault_init_s3_v2_aws_iam_policy
  to   = module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy
}

# IAM users + attachments + access keys + name uuids

moved {
  from = aws_iam_user.loki_s3_v2
  to   = module.captain_cluster.aws_iam_user.loki_s3_v2
}

moved {
  from = aws_iam_user_policy_attachment.loki_s3_v2
  to   = module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2
}

moved {
  from = aws_iam_access_key.loki_s3_v2
  to   = module.captain_cluster.aws_iam_access_key.loki_s3_v2
}

moved {
  from = random_uuid.loki_v2_aws_iam_user
  to   = module.captain_cluster.random_uuid.loki_v2_aws_iam_user
}

moved {
  from = aws_iam_user.certmanager_v2
  to   = module.captain_cluster.aws_iam_user.certmanager_v2
}

moved {
  from = aws_iam_user_policy_attachment.certmanager_v2
  to   = module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2
}

moved {
  from = aws_iam_access_key.certmanager_v2
  to   = module.captain_cluster.aws_iam_access_key.certmanager_v2
}

moved {
  from = random_uuid.certmanager_v2_aws_iam_user
  to   = module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user
}

moved {
  from = aws_iam_user.externaldns_v2
  to   = module.captain_cluster.aws_iam_user.externaldns_v2
}

moved {
  from = aws_iam_user_policy_attachment.externaldns_v2
  to   = module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2
}

moved {
  from = aws_iam_access_key.externaldns_v2
  to   = module.captain_cluster.aws_iam_access_key.externaldns_v2
}

moved {
  from = random_uuid.externaldns_v2_aws_iam_user
  to   = module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user
}

moved {
  from = aws_iam_user.tls_cert_backup_s3_v2
  to   = module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2
}

moved {
  from = aws_iam_user_policy_attachment.tls_cert_backup_s3_v2
  to   = module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2
}

moved {
  from = aws_iam_access_key.tls_cert_backup_s3_v2
  to   = module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2
}

moved {
  from = random_uuid.tls_cert_backup_s3_v2_aws_iam_user
  to   = module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user
}

moved {
  from = aws_iam_user.tls_cert_restore_s3_v2
  to   = module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2
}

moved {
  from = aws_iam_user_policy_attachment.tls_cert_restore_s3_v2
  to   = module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2
}

moved {
  from = aws_iam_access_key.tls_cert_restore_s3_v2
  to   = module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2
}

moved {
  from = random_uuid.tls_cert_restore_s3_v2_aws_iam_user
  to   = module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user
}

moved {
  from = aws_iam_user.vault_s3_backup_v2
  to   = module.captain_cluster.aws_iam_user.vault_s3_backup_v2
}

moved {
  from = aws_iam_user_policy_attachment.vault_s3_backup_v2
  to   = module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2
}

moved {
  from = aws_iam_access_key.vault_s3_backup_v2
  to   = module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2
}

moved {
  from = random_uuid.vault_s3_backup_v2_aws_iam_user
  to   = module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user
}

moved {
  from = aws_iam_user.vault_init_s3_v2
  to   = module.captain_cluster.aws_iam_user.vault_init_s3_v2
}

moved {
  from = aws_iam_user_policy_attachment.vault_init_s3_v2
  to   = module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2
}

moved {
  from = aws_iam_access_key.vault_init_s3_v2
  to   = module.captain_cluster.aws_iam_access_key.vault_init_s3_v2
}

moved {
  from = random_uuid.vault_init_s3_v2_aws_iam_user
  to   = module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user
}
