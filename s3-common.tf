module "common_s3" {
  source = "./modules/multy-s3-bucket/0.1.0"

  bucket_name         = local.bucket_name
  this_is_development = var.this_is_development
  company_account_id  = var.company_account_id
  primary_region      = var.primary_region
  backup_region       = var.backup_region
}


moved {
  from = module.tenent_antonio.aws_iam_policy.replication
  to   = module.tenent_antonio.module.common_s3.aws_iam_policy.replication
}
moved {
  from = module.tenent_antonio.aws_iam_role_policy_attachment.replication
  to   = module.tenent_antonio.module.common_s3.aws_iam_role_policy_attachment.replication
}
moved {
  from = module.tenent_antonio.aws_iam_role.replication
  to   = module.tenent_antonio.module.common_s3.aws_iam_role.replication
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_acl.primary
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_acl.primary
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_acl.replica
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_acl.replica
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_lifecycle_configuration.primary
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_lifecycle_configuration.primary
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_lifecycle_configuration.replica
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_lifecycle_configuration.replica
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_public_access_block.primary
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_public_access_block.primary
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_public_access_block.replica
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_public_access_block.replica
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_replication_configuration.replication
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_replication_configuration.replication
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_server_side_encryption_configuration.primary
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_server_side_encryption_configuration.primary
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_server_side_encryption_configuration.replica
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_server_side_encryption_configuration.replica
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_versioning.primary
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_versioning.primary
}
moved {
  from = module.tenent_antonio.aws_s3_bucket_versioning.replica
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket_versioning.replica
}
moved {
  from = module.tenent_antonio.aws_s3_bucket.primary
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket.primary
}
moved {
  from = module.tenent_antonio.aws_s3_bucket.replica
  to   = module.tenent_antonio.module.common_s3.aws_s3_bucket.replica
}