
resource "aws_s3_object" "combined_outputs_v2" {
  for_each = local.cluster_environments

  provider = aws.primaryregion
  bucket   = module.common_s3_v2.s3_multi_region_access_point_arn
  key      = "${each.value}.${aws_route53_zone.main.name}/configurations/credentials.json"
  content = jsonencode({
    vault_credentials       = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.vault_s3_backup_v2[each.value] },
  })

  content_type           = "application/json"
  server_side_encryption = "AES256"
  acl                    = "private"
}
