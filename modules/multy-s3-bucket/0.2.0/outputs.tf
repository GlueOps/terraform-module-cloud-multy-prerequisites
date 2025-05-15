
output "s3_multi_region_access_point_arn" {
  value = aws_s3control_multi_region_access_point.s3_multi_region_access_point.arn
}

output "s3_multi_region_access_point_arn_for_object_level_policies" {
  value = "${aws_s3control_multi_region_access_point.s3_multi_region_access_point.arn}/object"
}

output "s3_primary_arn" {
  value = aws_s3_bucket.primary.arn

}

output "s3_replica_arn" {
  value = aws_s3_bucket.replica.arn

}

output "tls_cert_backup_s3_key_prefix" {
  value = local.tls_cert_backup_s3_key_prefix
}

output "vault_backup_s3_key_prefix" {
  value = local.vault_backup_s3_key_prefix
}