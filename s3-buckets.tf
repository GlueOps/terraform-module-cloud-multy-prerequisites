module "common_s3" {
  source = "./modules/multy-s3-bucket/0.1.0"
  providers = {
    aws.primaryregion = aws.primaryregion
    aws.replicaregion = aws.replicaregion
  }

  bucket_name         = local.bucket_name
  this_is_development = var.this_is_development
  tenant_account_id   = var.tenant_account_id
  primary_region      = var.primary_region
  backup_region       = var.backup_region
}

module "loki_s3" {
  source = "./modules/multy-s3-bucket/0.1.0"
  providers = {
    aws.primaryregion = aws.primaryregion
    aws.replicaregion = aws.replicaregion
  }
  for_each = local.cluster_environments

  bucket_name                       = "${local.bucket_name}-${each.value}-loki"
  this_is_development               = var.this_is_development
  tenant_account_id                 = var.tenant_account_id
  primary_region                    = var.primary_region
  backup_region                     = var.backup_region
  enable_replication_and_versioning = false
}
