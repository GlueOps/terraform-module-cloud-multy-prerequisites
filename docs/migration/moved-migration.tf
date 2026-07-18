# GENERATED FILE — do not edit by hand.
# Regenerate after any change to moved.tf, modules/captain-cluster, or the
# conventional environment list:
#   bash docs/generate-moved-blocks.sh --chained nonprod prod dev test qa staging uat sandbox > docs/migration/moved-migration.tf
#
# Copy this file VERBATIM into a tenant repo alongside the rewritten
# tenant.tf (see docs/migration/MIGRATION.md). Blocks for environments a
# tenant does not have are no-ops. Delete the file after the migration
# has applied.

moved {
  from = module.tenant.aws_route53_zone.main
  to   = module.tenant.module.tenant_base.aws_route53_zone.main
}

moved {
  from = module.tenant.aws_route53_record.delegation_to_parent_tenant_zone
  to   = module.tenant.module.tenant_base.aws_route53_record.delegation_to_parent_tenant_zone
}

moved {
  from = module.tenant.module.dnssec_key
  to   = module.tenant.module.tenant_base.module.dnssec_key
}

moved {
  from = module.tenant.aws_route53_key_signing_key.parent_tenant_zone
  to   = module.tenant.module.tenant_base.aws_route53_key_signing_key.parent_tenant_zone
}

moved {
  from = module.tenant.aws_route53_hosted_zone_dnssec.parent_tenant_zone
  to   = module.tenant.module.tenant_base.aws_route53_hosted_zone_dnssec.parent_tenant_zone
}

moved {
  from = module.tenant.aws_route53_record.enable_dnssec_for_parent_tenant_zone
  to   = module.tenant.module.tenant_base.aws_route53_record.enable_dnssec_for_parent_tenant_zone
}

moved {
  from = module.tenant.module.common_s3
  to   = module.tenant.module.tenant_base.module.common_s3
}

moved {
  from = module.tenant.module.common_s3_v2
  to   = module.tenant.module.tenant_base.module.common_s3_v2
}

moved {
  from = module.tenant.aws_iam_policy.route53_autoglue
  to   = module.tenant.module.tenant_base.aws_iam_policy.route53_autoglue
}

moved {
  from = module.tenant.random_uuid.route53_autoglue_aws_iam_policy
  to   = module.tenant.module.tenant_base.random_uuid.route53_autoglue_aws_iam_policy
}

moved {
  from = module.tenant.aws_iam_user.autoglue
  to   = module.tenant.module.tenant_base.aws_iam_user.autoglue
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.autoglue
  to   = module.tenant.module.tenant_base.aws_iam_user_policy_attachment.autoglue
}

moved {
  from = module.tenant.aws_iam_access_key.autoglue
  to   = module.tenant.module.tenant_base.aws_iam_access_key.autoglue
}

moved {
  from = module.tenant.random_uuid.autoglue_aws_iam_user
  to   = module.tenant.module.tenant_base.random_uuid.autoglue_aws_iam_user
}

moved {
  from = module.tenant.autoglue_credential.route53
  to   = module.tenant.module.tenant_base.autoglue_credential.route53
}

moved {
  from = module.tenant.aws_route53_zone.clusters
  to   = module.tenant.module.captain_cluster.aws_route53_zone.clusters
}

moved {
  from = module.tenant.aws_route53_key_signing_key.cluster_zones
  to   = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones
}

moved {
  from = module.tenant.aws_route53_hosted_zone_dnssec.cluster_zones
  to   = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones
}

moved {
  from = module.tenant.aws_route53_record.cluster_zone_dnssec_records
  to   = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records
}

moved {
  from = module.tenant.aws_route53_record.cluster_zone_ns_records
  to   = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records
}

moved {
  from = module.tenant.aws_route53_record.wildcard_for_apps
  to   = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps
}

moved {
  from = module.tenant.module.loki_s3
  to   = module.tenant.module.captain_cluster.module.loki_s3
}

moved {
  from = module.tenant.module.glueops_platform_helm_values
  to   = module.tenant.module.captain_cluster.module.glueops_platform_helm_values
}

moved {
  from = module.tenant.module.argocd_helm_values
  to   = module.tenant.module.captain_cluster.module.argocd_helm_values
}

moved {
  from = module.tenant.module.captain_repository
  to   = module.tenant.module.captain_cluster.module.captain_repository
}

moved {
  from = module.tenant.module.captain_repository_files
  to   = module.tenant.module.captain_cluster.module.captain_repository_files
}

moved {
  from = module.tenant.module.glueops_platform_versions
  to   = module.tenant.module.captain_cluster.module.glueops_platform_versions
}

moved {
  from = module.tenant.module.tenant_cluster_versions
  to   = module.tenant.module.captain_cluster.module.tenant_cluster_versions
}

moved {
  from = module.tenant.module.tenant_readmes
  to   = module.tenant.module.captain_cluster.module.tenant_readmes
}

moved {
  from = module.tenant.module.generate_gluekube_creds
  to   = module.tenant.module.captain_cluster.module.generate_gluekube_creds
}

moved {
  from = module.tenant.random_password.dex_argocd_client_secret
  to   = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret
}

moved {
  from = module.tenant.random_password.dex_grafana_client_secret
  to   = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret
}

moved {
  from = module.tenant.random_password.dex_vault_client_secret
  to   = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret
}

moved {
  from = module.tenant.random_password.dex_oauth2_client_secret
  to   = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret
}

moved {
  from = module.tenant.random_password.dex_oauth2_cookie_secret
  to   = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret
}

moved {
  from = module.tenant.random_password.grafana_admin_secret
  to   = module.tenant.module.captain_cluster.random_password.grafana_admin_secret
}

moved {
  from = module.tenant.aws_iam_policy.loki_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2
}

moved {
  from = module.tenant.random_uuid.loki_v2_aws_iam_policy
  to   = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy
}

moved {
  from = module.tenant.aws_iam_policy.route53_v2
  to   = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2
}

moved {
  from = module.tenant.random_uuid.route53_v2_aws_iam_policy
  to   = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy
}

moved {
  from = module.tenant.aws_iam_policy.tls_cert_backup_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2
}

moved {
  from = module.tenant.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy
  to   = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy
}

moved {
  from = module.tenant.aws_iam_policy.tls_cert_restore_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2
}

moved {
  from = module.tenant.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy
  to   = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy
}

moved {
  from = module.tenant.aws_iam_policy.vault_s3_backup_v2
  to   = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2
}

moved {
  from = module.tenant.random_uuid.vault_s3_backup_v2_aws_iam_policy
  to   = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy
}

moved {
  from = module.tenant.aws_iam_policy.vault_init_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2
}

moved {
  from = module.tenant.random_uuid.vault_init_s3_v2_aws_iam_policy
  to   = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy
}

moved {
  from = module.tenant.aws_iam_user.loki_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.loki_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2
}

moved {
  from = module.tenant.aws_iam_access_key.loki_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2
}

moved {
  from = module.tenant.random_uuid.loki_v2_aws_iam_user
  to   = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user
}

moved {
  from = module.tenant.aws_iam_user.certmanager_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.certmanager_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2
}

moved {
  from = module.tenant.aws_iam_access_key.certmanager_v2
  to   = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2
}

moved {
  from = module.tenant.random_uuid.certmanager_v2_aws_iam_user
  to   = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user
}

moved {
  from = module.tenant.aws_iam_user.externaldns_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.externaldns_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2
}

moved {
  from = module.tenant.aws_iam_access_key.externaldns_v2
  to   = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2
}

moved {
  from = module.tenant.random_uuid.externaldns_v2_aws_iam_user
  to   = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user
}

moved {
  from = module.tenant.aws_iam_user.tls_cert_backup_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2
}

moved {
  from = module.tenant.aws_iam_access_key.tls_cert_backup_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2
}

moved {
  from = module.tenant.random_uuid.tls_cert_backup_s3_v2_aws_iam_user
  to   = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user
}

moved {
  from = module.tenant.aws_iam_user.tls_cert_restore_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2
}

moved {
  from = module.tenant.aws_iam_access_key.tls_cert_restore_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2
}

moved {
  from = module.tenant.random_uuid.tls_cert_restore_s3_v2_aws_iam_user
  to   = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user
}

moved {
  from = module.tenant.aws_iam_user.vault_s3_backup_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.vault_s3_backup_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2
}

moved {
  from = module.tenant.aws_iam_access_key.vault_s3_backup_v2
  to   = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2
}

moved {
  from = module.tenant.random_uuid.vault_s3_backup_v2_aws_iam_user
  to   = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user
}

moved {
  from = module.tenant.aws_iam_user.vault_init_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2
}

moved {
  from = module.tenant.aws_iam_user_policy_attachment.vault_init_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2
}

moved {
  from = module.tenant.aws_iam_access_key.vault_init_s3_v2
  to   = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2
}

moved {
  from = module.tenant.random_uuid.vault_init_s3_v2_aws_iam_user
  to   = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user
}

moved {
  from = module.tenant.module.tenant_base
  to   = module.tenant_base
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_access_key.certmanager_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["prod"]
  to   = module.cluster_prod.aws_iam_access_key.certmanager_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["dev"]
  to   = module.cluster_dev.aws_iam_access_key.certmanager_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["test"]
  to   = module.cluster_test.aws_iam_access_key.certmanager_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["qa"]
  to   = module.cluster_qa.aws_iam_access_key.certmanager_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["staging"]
  to   = module.cluster_staging.aws_iam_access_key.certmanager_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["uat"]
  to   = module.cluster_uat.aws_iam_access_key.certmanager_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.certmanager_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_access_key.certmanager_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_access_key.externaldns_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["prod"]
  to   = module.cluster_prod.aws_iam_access_key.externaldns_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["dev"]
  to   = module.cluster_dev.aws_iam_access_key.externaldns_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["test"]
  to   = module.cluster_test.aws_iam_access_key.externaldns_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["qa"]
  to   = module.cluster_qa.aws_iam_access_key.externaldns_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["staging"]
  to   = module.cluster_staging.aws_iam_access_key.externaldns_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["uat"]
  to   = module.cluster_uat.aws_iam_access_key.externaldns_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.externaldns_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_access_key.externaldns_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_access_key.loki_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_access_key.loki_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_access_key.loki_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["test"]
  to   = module.cluster_test.aws_iam_access_key.loki_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_access_key.loki_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_access_key.loki_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_access_key.loki_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.loki_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_access_key.loki_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_access_key.tls_cert_backup_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_access_key.tls_cert_backup_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_access_key.tls_cert_backup_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["test"]
  to   = module.cluster_test.aws_iam_access_key.tls_cert_backup_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_access_key.tls_cert_backup_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_access_key.tls_cert_backup_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_access_key.tls_cert_backup_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_backup_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_access_key.tls_cert_backup_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_access_key.tls_cert_restore_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_access_key.tls_cert_restore_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_access_key.tls_cert_restore_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["test"]
  to   = module.cluster_test.aws_iam_access_key.tls_cert_restore_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_access_key.tls_cert_restore_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_access_key.tls_cert_restore_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_access_key.tls_cert_restore_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.tls_cert_restore_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_access_key.tls_cert_restore_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_access_key.vault_init_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_access_key.vault_init_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_access_key.vault_init_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["test"]
  to   = module.cluster_test.aws_iam_access_key.vault_init_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_access_key.vault_init_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_access_key.vault_init_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_access_key.vault_init_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_init_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_access_key.vault_init_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_access_key.vault_s3_backup_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["prod"]
  to   = module.cluster_prod.aws_iam_access_key.vault_s3_backup_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["dev"]
  to   = module.cluster_dev.aws_iam_access_key.vault_s3_backup_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["test"]
  to   = module.cluster_test.aws_iam_access_key.vault_s3_backup_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["qa"]
  to   = module.cluster_qa.aws_iam_access_key.vault_s3_backup_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["staging"]
  to   = module.cluster_staging.aws_iam_access_key.vault_s3_backup_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["uat"]
  to   = module.cluster_uat.aws_iam_access_key.vault_s3_backup_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_access_key.vault_s3_backup_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_access_key.vault_s3_backup_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_policy.loki_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_policy.loki_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_policy.loki_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["test"]
  to   = module.cluster_test.aws_iam_policy.loki_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_policy.loki_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_policy.loki_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_policy.loki_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.loki_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_policy.loki_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_policy.route53_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["prod"]
  to   = module.cluster_prod.aws_iam_policy.route53_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["dev"]
  to   = module.cluster_dev.aws_iam_policy.route53_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["test"]
  to   = module.cluster_test.aws_iam_policy.route53_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["qa"]
  to   = module.cluster_qa.aws_iam_policy.route53_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["staging"]
  to   = module.cluster_staging.aws_iam_policy.route53_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["uat"]
  to   = module.cluster_uat.aws_iam_policy.route53_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.route53_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_policy.route53_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_policy.tls_cert_backup_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_policy.tls_cert_backup_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_policy.tls_cert_backup_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["test"]
  to   = module.cluster_test.aws_iam_policy.tls_cert_backup_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_policy.tls_cert_backup_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_policy.tls_cert_backup_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_policy.tls_cert_backup_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_backup_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_policy.tls_cert_backup_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_policy.tls_cert_restore_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_policy.tls_cert_restore_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_policy.tls_cert_restore_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["test"]
  to   = module.cluster_test.aws_iam_policy.tls_cert_restore_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_policy.tls_cert_restore_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_policy.tls_cert_restore_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_policy.tls_cert_restore_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.tls_cert_restore_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_policy.tls_cert_restore_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_policy.vault_init_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_policy.vault_init_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_policy.vault_init_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["test"]
  to   = module.cluster_test.aws_iam_policy.vault_init_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_policy.vault_init_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_policy.vault_init_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_policy.vault_init_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_init_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_policy.vault_init_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_policy.vault_s3_backup_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["prod"]
  to   = module.cluster_prod.aws_iam_policy.vault_s3_backup_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["dev"]
  to   = module.cluster_dev.aws_iam_policy.vault_s3_backup_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["test"]
  to   = module.cluster_test.aws_iam_policy.vault_s3_backup_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["qa"]
  to   = module.cluster_qa.aws_iam_policy.vault_s3_backup_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["staging"]
  to   = module.cluster_staging.aws_iam_policy.vault_s3_backup_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["uat"]
  to   = module.cluster_uat.aws_iam_policy.vault_s3_backup_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_policy.vault_s3_backup_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_policy.vault_s3_backup_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user.certmanager_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["prod"]
  to   = module.cluster_prod.aws_iam_user.certmanager_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["dev"]
  to   = module.cluster_dev.aws_iam_user.certmanager_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["test"]
  to   = module.cluster_test.aws_iam_user.certmanager_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["qa"]
  to   = module.cluster_qa.aws_iam_user.certmanager_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["staging"]
  to   = module.cluster_staging.aws_iam_user.certmanager_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["uat"]
  to   = module.cluster_uat.aws_iam_user.certmanager_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.certmanager_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user.certmanager_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user.externaldns_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["prod"]
  to   = module.cluster_prod.aws_iam_user.externaldns_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["dev"]
  to   = module.cluster_dev.aws_iam_user.externaldns_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["test"]
  to   = module.cluster_test.aws_iam_user.externaldns_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["qa"]
  to   = module.cluster_qa.aws_iam_user.externaldns_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["staging"]
  to   = module.cluster_staging.aws_iam_user.externaldns_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["uat"]
  to   = module.cluster_uat.aws_iam_user.externaldns_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.externaldns_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user.externaldns_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user.loki_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user.loki_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user.loki_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user.loki_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user.loki_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user.loki_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user.loki_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.loki_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user.loki_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user_policy_attachment.certmanager_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["prod"]
  to   = module.cluster_prod.aws_iam_user_policy_attachment.certmanager_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["dev"]
  to   = module.cluster_dev.aws_iam_user_policy_attachment.certmanager_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["test"]
  to   = module.cluster_test.aws_iam_user_policy_attachment.certmanager_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["qa"]
  to   = module.cluster_qa.aws_iam_user_policy_attachment.certmanager_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["staging"]
  to   = module.cluster_staging.aws_iam_user_policy_attachment.certmanager_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["uat"]
  to   = module.cluster_uat.aws_iam_user_policy_attachment.certmanager_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.certmanager_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user_policy_attachment.certmanager_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user_policy_attachment.externaldns_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["prod"]
  to   = module.cluster_prod.aws_iam_user_policy_attachment.externaldns_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["dev"]
  to   = module.cluster_dev.aws_iam_user_policy_attachment.externaldns_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["test"]
  to   = module.cluster_test.aws_iam_user_policy_attachment.externaldns_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["qa"]
  to   = module.cluster_qa.aws_iam_user_policy_attachment.externaldns_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["staging"]
  to   = module.cluster_staging.aws_iam_user_policy_attachment.externaldns_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["uat"]
  to   = module.cluster_uat.aws_iam_user_policy_attachment.externaldns_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.externaldns_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user_policy_attachment.externaldns_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user_policy_attachment.loki_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user_policy_attachment.loki_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user_policy_attachment.loki_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user_policy_attachment.loki_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user_policy_attachment.loki_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user_policy_attachment.loki_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user_policy_attachment.loki_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.loki_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user_policy_attachment.loki_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user_policy_attachment.tls_cert_backup_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user_policy_attachment.tls_cert_restore_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user_policy_attachment.vault_init_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user_policy_attachment.vault_init_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user_policy_attachment.vault_init_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user_policy_attachment.vault_init_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user_policy_attachment.vault_init_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user_policy_attachment.vault_init_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user_policy_attachment.vault_init_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_init_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user_policy_attachment.vault_init_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user_policy_attachment.vault_s3_backup_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["prod"]
  to   = module.cluster_prod.aws_iam_user_policy_attachment.vault_s3_backup_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["dev"]
  to   = module.cluster_dev.aws_iam_user_policy_attachment.vault_s3_backup_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["test"]
  to   = module.cluster_test.aws_iam_user_policy_attachment.vault_s3_backup_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["qa"]
  to   = module.cluster_qa.aws_iam_user_policy_attachment.vault_s3_backup_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["staging"]
  to   = module.cluster_staging.aws_iam_user_policy_attachment.vault_s3_backup_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["uat"]
  to   = module.cluster_uat.aws_iam_user_policy_attachment.vault_s3_backup_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user_policy_attachment.vault_s3_backup_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user_policy_attachment.vault_s3_backup_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user.tls_cert_backup_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user.tls_cert_backup_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user.tls_cert_backup_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user.tls_cert_backup_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user.tls_cert_backup_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user.tls_cert_backup_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user.tls_cert_backup_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_backup_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user.tls_cert_backup_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user.tls_cert_restore_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user.tls_cert_restore_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user.tls_cert_restore_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user.tls_cert_restore_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user.tls_cert_restore_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user.tls_cert_restore_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user.tls_cert_restore_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.tls_cert_restore_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user.tls_cert_restore_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user.vault_init_s3_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["prod"]
  to   = module.cluster_prod.aws_iam_user.vault_init_s3_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["dev"]
  to   = module.cluster_dev.aws_iam_user.vault_init_s3_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["test"]
  to   = module.cluster_test.aws_iam_user.vault_init_s3_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["qa"]
  to   = module.cluster_qa.aws_iam_user.vault_init_s3_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["staging"]
  to   = module.cluster_staging.aws_iam_user.vault_init_s3_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["uat"]
  to   = module.cluster_uat.aws_iam_user.vault_init_s3_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_init_s3_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user.vault_init_s3_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["nonprod"]
  to   = module.cluster_nonprod.aws_iam_user.vault_s3_backup_v2["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["prod"]
  to   = module.cluster_prod.aws_iam_user.vault_s3_backup_v2["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["dev"]
  to   = module.cluster_dev.aws_iam_user.vault_s3_backup_v2["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["test"]
  to   = module.cluster_test.aws_iam_user.vault_s3_backup_v2["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["qa"]
  to   = module.cluster_qa.aws_iam_user.vault_s3_backup_v2["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["staging"]
  to   = module.cluster_staging.aws_iam_user.vault_s3_backup_v2["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["uat"]
  to   = module.cluster_uat.aws_iam_user.vault_s3_backup_v2["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_iam_user.vault_s3_backup_v2["sandbox"]
  to   = module.cluster_sandbox.aws_iam_user.vault_s3_backup_v2["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["nonprod"]
  to   = module.cluster_nonprod.aws_route53_hosted_zone_dnssec.cluster_zones["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["prod"]
  to   = module.cluster_prod.aws_route53_hosted_zone_dnssec.cluster_zones["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["dev"]
  to   = module.cluster_dev.aws_route53_hosted_zone_dnssec.cluster_zones["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["test"]
  to   = module.cluster_test.aws_route53_hosted_zone_dnssec.cluster_zones["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["qa"]
  to   = module.cluster_qa.aws_route53_hosted_zone_dnssec.cluster_zones["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["staging"]
  to   = module.cluster_staging.aws_route53_hosted_zone_dnssec.cluster_zones["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["uat"]
  to   = module.cluster_uat.aws_route53_hosted_zone_dnssec.cluster_zones["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_hosted_zone_dnssec.cluster_zones["sandbox"]
  to   = module.cluster_sandbox.aws_route53_hosted_zone_dnssec.cluster_zones["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["nonprod"]
  to   = module.cluster_nonprod.aws_route53_key_signing_key.cluster_zones["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["prod"]
  to   = module.cluster_prod.aws_route53_key_signing_key.cluster_zones["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["dev"]
  to   = module.cluster_dev.aws_route53_key_signing_key.cluster_zones["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["test"]
  to   = module.cluster_test.aws_route53_key_signing_key.cluster_zones["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["qa"]
  to   = module.cluster_qa.aws_route53_key_signing_key.cluster_zones["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["staging"]
  to   = module.cluster_staging.aws_route53_key_signing_key.cluster_zones["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["uat"]
  to   = module.cluster_uat.aws_route53_key_signing_key.cluster_zones["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_key_signing_key.cluster_zones["sandbox"]
  to   = module.cluster_sandbox.aws_route53_key_signing_key.cluster_zones["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["nonprod"]
  to   = module.cluster_nonprod.aws_route53_record.cluster_zone_dnssec_records["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["prod"]
  to   = module.cluster_prod.aws_route53_record.cluster_zone_dnssec_records["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["dev"]
  to   = module.cluster_dev.aws_route53_record.cluster_zone_dnssec_records["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["test"]
  to   = module.cluster_test.aws_route53_record.cluster_zone_dnssec_records["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["qa"]
  to   = module.cluster_qa.aws_route53_record.cluster_zone_dnssec_records["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["staging"]
  to   = module.cluster_staging.aws_route53_record.cluster_zone_dnssec_records["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["uat"]
  to   = module.cluster_uat.aws_route53_record.cluster_zone_dnssec_records["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_dnssec_records["sandbox"]
  to   = module.cluster_sandbox.aws_route53_record.cluster_zone_dnssec_records["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["nonprod"]
  to   = module.cluster_nonprod.aws_route53_record.cluster_zone_ns_records["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["prod"]
  to   = module.cluster_prod.aws_route53_record.cluster_zone_ns_records["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["dev"]
  to   = module.cluster_dev.aws_route53_record.cluster_zone_ns_records["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["test"]
  to   = module.cluster_test.aws_route53_record.cluster_zone_ns_records["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["qa"]
  to   = module.cluster_qa.aws_route53_record.cluster_zone_ns_records["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["staging"]
  to   = module.cluster_staging.aws_route53_record.cluster_zone_ns_records["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["uat"]
  to   = module.cluster_uat.aws_route53_record.cluster_zone_ns_records["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.cluster_zone_ns_records["sandbox"]
  to   = module.cluster_sandbox.aws_route53_record.cluster_zone_ns_records["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["nonprod"]
  to   = module.cluster_nonprod.aws_route53_record.wildcard_for_apps["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["prod"]
  to   = module.cluster_prod.aws_route53_record.wildcard_for_apps["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["dev"]
  to   = module.cluster_dev.aws_route53_record.wildcard_for_apps["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["test"]
  to   = module.cluster_test.aws_route53_record.wildcard_for_apps["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["qa"]
  to   = module.cluster_qa.aws_route53_record.wildcard_for_apps["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["staging"]
  to   = module.cluster_staging.aws_route53_record.wildcard_for_apps["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["uat"]
  to   = module.cluster_uat.aws_route53_record.wildcard_for_apps["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_record.wildcard_for_apps["sandbox"]
  to   = module.cluster_sandbox.aws_route53_record.wildcard_for_apps["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["nonprod"]
  to   = module.cluster_nonprod.aws_route53_zone.clusters["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["prod"]
  to   = module.cluster_prod.aws_route53_zone.clusters["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["dev"]
  to   = module.cluster_dev.aws_route53_zone.clusters["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["test"]
  to   = module.cluster_test.aws_route53_zone.clusters["test"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["qa"]
  to   = module.cluster_qa.aws_route53_zone.clusters["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["staging"]
  to   = module.cluster_staging.aws_route53_zone.clusters["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["uat"]
  to   = module.cluster_uat.aws_route53_zone.clusters["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.aws_route53_zone.clusters["sandbox"]
  to   = module.cluster_sandbox.aws_route53_zone.clusters["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["nonprod"]
  to   = module.cluster_nonprod.module.argocd_helm_values["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["prod"]
  to   = module.cluster_prod.module.argocd_helm_values["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["dev"]
  to   = module.cluster_dev.module.argocd_helm_values["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["test"]
  to   = module.cluster_test.module.argocd_helm_values["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["qa"]
  to   = module.cluster_qa.module.argocd_helm_values["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["staging"]
  to   = module.cluster_staging.module.argocd_helm_values["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["uat"]
  to   = module.cluster_uat.module.argocd_helm_values["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.argocd_helm_values["sandbox"]
  to   = module.cluster_sandbox.module.argocd_helm_values["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["nonprod"]
  to   = module.cluster_nonprod.module.captain_repository["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["prod"]
  to   = module.cluster_prod.module.captain_repository["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["dev"]
  to   = module.cluster_dev.module.captain_repository["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["test"]
  to   = module.cluster_test.module.captain_repository["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["qa"]
  to   = module.cluster_qa.module.captain_repository["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["staging"]
  to   = module.cluster_staging.module.captain_repository["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["uat"]
  to   = module.cluster_uat.module.captain_repository["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository["sandbox"]
  to   = module.cluster_sandbox.module.captain_repository["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["nonprod"]
  to   = module.cluster_nonprod.module.captain_repository_files["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["prod"]
  to   = module.cluster_prod.module.captain_repository_files["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["dev"]
  to   = module.cluster_dev.module.captain_repository_files["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["test"]
  to   = module.cluster_test.module.captain_repository_files["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["qa"]
  to   = module.cluster_qa.module.captain_repository_files["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["staging"]
  to   = module.cluster_staging.module.captain_repository_files["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["uat"]
  to   = module.cluster_uat.module.captain_repository_files["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.captain_repository_files["sandbox"]
  to   = module.cluster_sandbox.module.captain_repository_files["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["nonprod"]
  to   = module.cluster_nonprod.module.generate_gluekube_creds["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["prod"]
  to   = module.cluster_prod.module.generate_gluekube_creds["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["dev"]
  to   = module.cluster_dev.module.generate_gluekube_creds["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["test"]
  to   = module.cluster_test.module.generate_gluekube_creds["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["qa"]
  to   = module.cluster_qa.module.generate_gluekube_creds["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["staging"]
  to   = module.cluster_staging.module.generate_gluekube_creds["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["uat"]
  to   = module.cluster_uat.module.generate_gluekube_creds["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.generate_gluekube_creds["sandbox"]
  to   = module.cluster_sandbox.module.generate_gluekube_creds["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["nonprod"]
  to   = module.cluster_nonprod.module.glueops_platform_helm_values["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["prod"]
  to   = module.cluster_prod.module.glueops_platform_helm_values["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["dev"]
  to   = module.cluster_dev.module.glueops_platform_helm_values["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["test"]
  to   = module.cluster_test.module.glueops_platform_helm_values["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["qa"]
  to   = module.cluster_qa.module.glueops_platform_helm_values["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["staging"]
  to   = module.cluster_staging.module.glueops_platform_helm_values["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["uat"]
  to   = module.cluster_uat.module.glueops_platform_helm_values["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_helm_values["sandbox"]
  to   = module.cluster_sandbox.module.glueops_platform_helm_values["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["nonprod"]
  to   = module.cluster_nonprod.module.glueops_platform_versions["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["prod"]
  to   = module.cluster_prod.module.glueops_platform_versions["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["dev"]
  to   = module.cluster_dev.module.glueops_platform_versions["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["test"]
  to   = module.cluster_test.module.glueops_platform_versions["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["qa"]
  to   = module.cluster_qa.module.glueops_platform_versions["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["staging"]
  to   = module.cluster_staging.module.glueops_platform_versions["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["uat"]
  to   = module.cluster_uat.module.glueops_platform_versions["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.glueops_platform_versions["sandbox"]
  to   = module.cluster_sandbox.module.glueops_platform_versions["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["nonprod"]
  to   = module.cluster_nonprod.module.loki_s3["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["prod"]
  to   = module.cluster_prod.module.loki_s3["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["dev"]
  to   = module.cluster_dev.module.loki_s3["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["test"]
  to   = module.cluster_test.module.loki_s3["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["qa"]
  to   = module.cluster_qa.module.loki_s3["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["staging"]
  to   = module.cluster_staging.module.loki_s3["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["uat"]
  to   = module.cluster_uat.module.loki_s3["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.loki_s3["sandbox"]
  to   = module.cluster_sandbox.module.loki_s3["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["nonprod"]
  to   = module.cluster_nonprod.module.tenant_cluster_versions["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["prod"]
  to   = module.cluster_prod.module.tenant_cluster_versions["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["dev"]
  to   = module.cluster_dev.module.tenant_cluster_versions["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["test"]
  to   = module.cluster_test.module.tenant_cluster_versions["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["qa"]
  to   = module.cluster_qa.module.tenant_cluster_versions["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["staging"]
  to   = module.cluster_staging.module.tenant_cluster_versions["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["uat"]
  to   = module.cluster_uat.module.tenant_cluster_versions["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_cluster_versions["sandbox"]
  to   = module.cluster_sandbox.module.tenant_cluster_versions["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["nonprod"]
  to   = module.cluster_nonprod.module.tenant_readmes["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["prod"]
  to   = module.cluster_prod.module.tenant_readmes["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["dev"]
  to   = module.cluster_dev.module.tenant_readmes["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["test"]
  to   = module.cluster_test.module.tenant_readmes["test"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["qa"]
  to   = module.cluster_qa.module.tenant_readmes["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["staging"]
  to   = module.cluster_staging.module.tenant_readmes["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["uat"]
  to   = module.cluster_uat.module.tenant_readmes["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.module.tenant_readmes["sandbox"]
  to   = module.cluster_sandbox.module.tenant_readmes["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["nonprod"]
  to   = module.cluster_nonprod.random_password.dex_argocd_client_secret["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["prod"]
  to   = module.cluster_prod.random_password.dex_argocd_client_secret["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["dev"]
  to   = module.cluster_dev.random_password.dex_argocd_client_secret["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["test"]
  to   = module.cluster_test.random_password.dex_argocd_client_secret["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["qa"]
  to   = module.cluster_qa.random_password.dex_argocd_client_secret["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["staging"]
  to   = module.cluster_staging.random_password.dex_argocd_client_secret["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["uat"]
  to   = module.cluster_uat.random_password.dex_argocd_client_secret["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_argocd_client_secret["sandbox"]
  to   = module.cluster_sandbox.random_password.dex_argocd_client_secret["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["nonprod"]
  to   = module.cluster_nonprod.random_password.dex_grafana_client_secret["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["prod"]
  to   = module.cluster_prod.random_password.dex_grafana_client_secret["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["dev"]
  to   = module.cluster_dev.random_password.dex_grafana_client_secret["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["test"]
  to   = module.cluster_test.random_password.dex_grafana_client_secret["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["qa"]
  to   = module.cluster_qa.random_password.dex_grafana_client_secret["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["staging"]
  to   = module.cluster_staging.random_password.dex_grafana_client_secret["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["uat"]
  to   = module.cluster_uat.random_password.dex_grafana_client_secret["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_grafana_client_secret["sandbox"]
  to   = module.cluster_sandbox.random_password.dex_grafana_client_secret["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["nonprod"]
  to   = module.cluster_nonprod.random_password.dex_oauth2_client_secret["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["prod"]
  to   = module.cluster_prod.random_password.dex_oauth2_client_secret["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["dev"]
  to   = module.cluster_dev.random_password.dex_oauth2_client_secret["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["test"]
  to   = module.cluster_test.random_password.dex_oauth2_client_secret["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["qa"]
  to   = module.cluster_qa.random_password.dex_oauth2_client_secret["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["staging"]
  to   = module.cluster_staging.random_password.dex_oauth2_client_secret["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["uat"]
  to   = module.cluster_uat.random_password.dex_oauth2_client_secret["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_client_secret["sandbox"]
  to   = module.cluster_sandbox.random_password.dex_oauth2_client_secret["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["nonprod"]
  to   = module.cluster_nonprod.random_password.dex_oauth2_cookie_secret["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["prod"]
  to   = module.cluster_prod.random_password.dex_oauth2_cookie_secret["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["dev"]
  to   = module.cluster_dev.random_password.dex_oauth2_cookie_secret["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["test"]
  to   = module.cluster_test.random_password.dex_oauth2_cookie_secret["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["qa"]
  to   = module.cluster_qa.random_password.dex_oauth2_cookie_secret["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["staging"]
  to   = module.cluster_staging.random_password.dex_oauth2_cookie_secret["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["uat"]
  to   = module.cluster_uat.random_password.dex_oauth2_cookie_secret["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_oauth2_cookie_secret["sandbox"]
  to   = module.cluster_sandbox.random_password.dex_oauth2_cookie_secret["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["nonprod"]
  to   = module.cluster_nonprod.random_password.dex_vault_client_secret["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["prod"]
  to   = module.cluster_prod.random_password.dex_vault_client_secret["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["dev"]
  to   = module.cluster_dev.random_password.dex_vault_client_secret["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["test"]
  to   = module.cluster_test.random_password.dex_vault_client_secret["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["qa"]
  to   = module.cluster_qa.random_password.dex_vault_client_secret["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["staging"]
  to   = module.cluster_staging.random_password.dex_vault_client_secret["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["uat"]
  to   = module.cluster_uat.random_password.dex_vault_client_secret["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.dex_vault_client_secret["sandbox"]
  to   = module.cluster_sandbox.random_password.dex_vault_client_secret["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["nonprod"]
  to   = module.cluster_nonprod.random_password.grafana_admin_secret["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["prod"]
  to   = module.cluster_prod.random_password.grafana_admin_secret["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["dev"]
  to   = module.cluster_dev.random_password.grafana_admin_secret["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["test"]
  to   = module.cluster_test.random_password.grafana_admin_secret["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["qa"]
  to   = module.cluster_qa.random_password.grafana_admin_secret["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["staging"]
  to   = module.cluster_staging.random_password.grafana_admin_secret["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["uat"]
  to   = module.cluster_uat.random_password.grafana_admin_secret["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_password.grafana_admin_secret["sandbox"]
  to   = module.cluster_sandbox.random_password.grafana_admin_secret["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["nonprod"]
  to   = module.cluster_nonprod.random_uuid.certmanager_v2_aws_iam_user["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["prod"]
  to   = module.cluster_prod.random_uuid.certmanager_v2_aws_iam_user["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["dev"]
  to   = module.cluster_dev.random_uuid.certmanager_v2_aws_iam_user["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["test"]
  to   = module.cluster_test.random_uuid.certmanager_v2_aws_iam_user["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["qa"]
  to   = module.cluster_qa.random_uuid.certmanager_v2_aws_iam_user["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["staging"]
  to   = module.cluster_staging.random_uuid.certmanager_v2_aws_iam_user["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["uat"]
  to   = module.cluster_uat.random_uuid.certmanager_v2_aws_iam_user["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.certmanager_v2_aws_iam_user["sandbox"]
  to   = module.cluster_sandbox.random_uuid.certmanager_v2_aws_iam_user["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["nonprod"]
  to   = module.cluster_nonprod.random_uuid.externaldns_v2_aws_iam_user["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["prod"]
  to   = module.cluster_prod.random_uuid.externaldns_v2_aws_iam_user["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["dev"]
  to   = module.cluster_dev.random_uuid.externaldns_v2_aws_iam_user["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["test"]
  to   = module.cluster_test.random_uuid.externaldns_v2_aws_iam_user["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["qa"]
  to   = module.cluster_qa.random_uuid.externaldns_v2_aws_iam_user["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["staging"]
  to   = module.cluster_staging.random_uuid.externaldns_v2_aws_iam_user["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["uat"]
  to   = module.cluster_uat.random_uuid.externaldns_v2_aws_iam_user["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.externaldns_v2_aws_iam_user["sandbox"]
  to   = module.cluster_sandbox.random_uuid.externaldns_v2_aws_iam_user["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["nonprod"]
  to   = module.cluster_nonprod.random_uuid.loki_v2_aws_iam_policy["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["prod"]
  to   = module.cluster_prod.random_uuid.loki_v2_aws_iam_policy["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["dev"]
  to   = module.cluster_dev.random_uuid.loki_v2_aws_iam_policy["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["test"]
  to   = module.cluster_test.random_uuid.loki_v2_aws_iam_policy["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["qa"]
  to   = module.cluster_qa.random_uuid.loki_v2_aws_iam_policy["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["staging"]
  to   = module.cluster_staging.random_uuid.loki_v2_aws_iam_policy["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["uat"]
  to   = module.cluster_uat.random_uuid.loki_v2_aws_iam_policy["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_policy["sandbox"]
  to   = module.cluster_sandbox.random_uuid.loki_v2_aws_iam_policy["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["nonprod"]
  to   = module.cluster_nonprod.random_uuid.loki_v2_aws_iam_user["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["prod"]
  to   = module.cluster_prod.random_uuid.loki_v2_aws_iam_user["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["dev"]
  to   = module.cluster_dev.random_uuid.loki_v2_aws_iam_user["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["test"]
  to   = module.cluster_test.random_uuid.loki_v2_aws_iam_user["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["qa"]
  to   = module.cluster_qa.random_uuid.loki_v2_aws_iam_user["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["staging"]
  to   = module.cluster_staging.random_uuid.loki_v2_aws_iam_user["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["uat"]
  to   = module.cluster_uat.random_uuid.loki_v2_aws_iam_user["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.loki_v2_aws_iam_user["sandbox"]
  to   = module.cluster_sandbox.random_uuid.loki_v2_aws_iam_user["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["nonprod"]
  to   = module.cluster_nonprod.random_uuid.route53_v2_aws_iam_policy["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["prod"]
  to   = module.cluster_prod.random_uuid.route53_v2_aws_iam_policy["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["dev"]
  to   = module.cluster_dev.random_uuid.route53_v2_aws_iam_policy["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["test"]
  to   = module.cluster_test.random_uuid.route53_v2_aws_iam_policy["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["qa"]
  to   = module.cluster_qa.random_uuid.route53_v2_aws_iam_policy["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["staging"]
  to   = module.cluster_staging.random_uuid.route53_v2_aws_iam_policy["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["uat"]
  to   = module.cluster_uat.random_uuid.route53_v2_aws_iam_policy["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.route53_v2_aws_iam_policy["sandbox"]
  to   = module.cluster_sandbox.random_uuid.route53_v2_aws_iam_policy["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["nonprod"]
  to   = module.cluster_nonprod.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["prod"]
  to   = module.cluster_prod.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["dev"]
  to   = module.cluster_dev.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["test"]
  to   = module.cluster_test.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["qa"]
  to   = module.cluster_qa.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["staging"]
  to   = module.cluster_staging.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["uat"]
  to   = module.cluster_uat.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["sandbox"]
  to   = module.cluster_sandbox.random_uuid.tls_cert_backup_s3_v2_aws_iam_policy["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["nonprod"]
  to   = module.cluster_nonprod.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["prod"]
  to   = module.cluster_prod.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["dev"]
  to   = module.cluster_dev.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["test"]
  to   = module.cluster_test.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["qa"]
  to   = module.cluster_qa.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["staging"]
  to   = module.cluster_staging.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["uat"]
  to   = module.cluster_uat.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["sandbox"]
  to   = module.cluster_sandbox.random_uuid.tls_cert_backup_s3_v2_aws_iam_user["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["nonprod"]
  to   = module.cluster_nonprod.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["prod"]
  to   = module.cluster_prod.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["dev"]
  to   = module.cluster_dev.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["test"]
  to   = module.cluster_test.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["qa"]
  to   = module.cluster_qa.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["staging"]
  to   = module.cluster_staging.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["uat"]
  to   = module.cluster_uat.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["sandbox"]
  to   = module.cluster_sandbox.random_uuid.tls_cert_restore_s3_v2_aws_iam_policy["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["nonprod"]
  to   = module.cluster_nonprod.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["prod"]
  to   = module.cluster_prod.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["dev"]
  to   = module.cluster_dev.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["test"]
  to   = module.cluster_test.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["qa"]
  to   = module.cluster_qa.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["staging"]
  to   = module.cluster_staging.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["uat"]
  to   = module.cluster_uat.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["sandbox"]
  to   = module.cluster_sandbox.random_uuid.tls_cert_restore_s3_v2_aws_iam_user["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["nonprod"]
  to   = module.cluster_nonprod.random_uuid.vault_init_s3_v2_aws_iam_policy["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["prod"]
  to   = module.cluster_prod.random_uuid.vault_init_s3_v2_aws_iam_policy["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["dev"]
  to   = module.cluster_dev.random_uuid.vault_init_s3_v2_aws_iam_policy["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["test"]
  to   = module.cluster_test.random_uuid.vault_init_s3_v2_aws_iam_policy["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["qa"]
  to   = module.cluster_qa.random_uuid.vault_init_s3_v2_aws_iam_policy["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["staging"]
  to   = module.cluster_staging.random_uuid.vault_init_s3_v2_aws_iam_policy["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["uat"]
  to   = module.cluster_uat.random_uuid.vault_init_s3_v2_aws_iam_policy["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_policy["sandbox"]
  to   = module.cluster_sandbox.random_uuid.vault_init_s3_v2_aws_iam_policy["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["nonprod"]
  to   = module.cluster_nonprod.random_uuid.vault_init_s3_v2_aws_iam_user["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["prod"]
  to   = module.cluster_prod.random_uuid.vault_init_s3_v2_aws_iam_user["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["dev"]
  to   = module.cluster_dev.random_uuid.vault_init_s3_v2_aws_iam_user["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["test"]
  to   = module.cluster_test.random_uuid.vault_init_s3_v2_aws_iam_user["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["qa"]
  to   = module.cluster_qa.random_uuid.vault_init_s3_v2_aws_iam_user["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["staging"]
  to   = module.cluster_staging.random_uuid.vault_init_s3_v2_aws_iam_user["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["uat"]
  to   = module.cluster_uat.random_uuid.vault_init_s3_v2_aws_iam_user["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_init_s3_v2_aws_iam_user["sandbox"]
  to   = module.cluster_sandbox.random_uuid.vault_init_s3_v2_aws_iam_user["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["nonprod"]
  to   = module.cluster_nonprod.random_uuid.vault_s3_backup_v2_aws_iam_policy["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["prod"]
  to   = module.cluster_prod.random_uuid.vault_s3_backup_v2_aws_iam_policy["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["dev"]
  to   = module.cluster_dev.random_uuid.vault_s3_backup_v2_aws_iam_policy["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["test"]
  to   = module.cluster_test.random_uuid.vault_s3_backup_v2_aws_iam_policy["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["qa"]
  to   = module.cluster_qa.random_uuid.vault_s3_backup_v2_aws_iam_policy["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["staging"]
  to   = module.cluster_staging.random_uuid.vault_s3_backup_v2_aws_iam_policy["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["uat"]
  to   = module.cluster_uat.random_uuid.vault_s3_backup_v2_aws_iam_policy["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_policy["sandbox"]
  to   = module.cluster_sandbox.random_uuid.vault_s3_backup_v2_aws_iam_policy["sandbox"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["nonprod"]
  to   = module.cluster_nonprod.random_uuid.vault_s3_backup_v2_aws_iam_user["nonprod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["prod"]
  to   = module.cluster_prod.random_uuid.vault_s3_backup_v2_aws_iam_user["prod"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["dev"]
  to   = module.cluster_dev.random_uuid.vault_s3_backup_v2_aws_iam_user["dev"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["test"]
  to   = module.cluster_test.random_uuid.vault_s3_backup_v2_aws_iam_user["test"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["qa"]
  to   = module.cluster_qa.random_uuid.vault_s3_backup_v2_aws_iam_user["qa"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["staging"]
  to   = module.cluster_staging.random_uuid.vault_s3_backup_v2_aws_iam_user["staging"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["uat"]
  to   = module.cluster_uat.random_uuid.vault_s3_backup_v2_aws_iam_user["uat"]
}

moved {
  from = module.tenant.module.captain_cluster.random_uuid.vault_s3_backup_v2_aws_iam_user["sandbox"]
  to   = module.cluster_sandbox.random_uuid.vault_s3_backup_v2_aws_iam_user["sandbox"]
}
