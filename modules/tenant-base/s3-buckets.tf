module "common_s3" {
  source = "../multy-s3-bucket/0.1.0"
  providers = {
    aws.primaryregion = aws.primaryregion
    aws.replicaregion = aws.replicaregion
  }
  bucket_name         = local.bucket_name
  this_is_development = true
  tenant_account_id   = var.tenant_account_id
  primary_region      = var.primary_region
  backup_region       = var.backup_region
}

module "common_s3_v2" {
  source = "../multy-s3-bucket/0.2.0"
  providers = {
    aws.primaryregion = aws.primaryregion
    aws.replicaregion = aws.replicaregion
  }

  tenant_key          = var.tenant_key
  this_is_development = var.this_is_development
  tenant_account_id   = var.tenant_account_id
  primary_region      = var.primary_region
  backup_region       = var.backup_region
  cluster_zone_names  = { for env in var.environment_names : env => "${env}.${aws_route53_zone.main.name}" }
}
