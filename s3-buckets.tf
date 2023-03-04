module "common_s3" {
  source = "./modules/multy-s3-bucket/0.1.0"

  bucket_name         = local.bucket_name
  this_is_development = var.this_is_development
  company_account_id  = var.company_account_id
  primary_region      = var.primary_region
  backup_region       = var.backup_region
}

module "loki_s3" {
  source   = "./modules/multy-s3-bucket/0.1.0"
  for_each = aws_route53_zone.clusters

  bucket_name         = "${local.bucket_name}-${aws_route53_zone.clusters[each.key].name}-loki"
  this_is_development = var.this_is_development
  company_account_id  = var.company_account_id
  primary_region      = var.primary_region
  backup_region       = var.backup_region
}