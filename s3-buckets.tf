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

