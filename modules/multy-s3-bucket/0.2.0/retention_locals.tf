locals {
  # Consolidate all backup paths
  backup_prefixes = flatten([
    for zone in var.cluster_zone_names : [
      "${zone}/hashicorp-vault-backups/",
      "${zone}/tls-cert-backups/",
      "${zone}/${local.vault_backup_s3_key_prefix}/",
      "${zone}/${local.tls_cert_backup_s3_key_prefix}/"
    ]
  ])

  # If Dev, expire after IA minimum (31). If Prod, expire after Glacier minimum (151).
  expire_days = var.this_is_development ? 31 : 151

  # Non-current logic
  noncurrent_transition_days = 30
  noncurrent_expire_days     = var.this_is_development ? 30 : 121 
}