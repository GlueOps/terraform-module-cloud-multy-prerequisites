
resource "aws_s3_object" "combined_outputs" {
  for_each = local.cluster_environments

  provider = aws.primaryregion
  bucket   = module.common_s3_v2.s3_multi_region_access_point_arn
  key      = "${each.value}.${aws_route53_zone.main.name}/configurations/credentials.json"
  content = jsonencode({
    certmanager_credentials = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.certmanager_v2[each.value] },
    externaldns_credentials = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.externaldns_v2[each.value] },
    loki_credentials        = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.loki_s3_v2[each.value] },
    opsgenie_credentials    = lookup(module.opsgenie_teams.opsgenie_prometheus_api_keys, split(".", each.value)[0], null),
    vault_credentials       = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.vault_s3_backup_v2[each.value] },
  })

  content_type           = "application/json"
  server_side_encryption = "AES256"
  acl                    = "private"
}
