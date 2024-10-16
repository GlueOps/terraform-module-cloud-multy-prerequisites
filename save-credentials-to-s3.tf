resource "aws_s3_object" "combined_outputs" {
  for_each = local.cluster_environments

  provider = aws.primaryregion
  bucket   = module.common_s3.primary_s3_bucket_id
  key      = "${each.value}.${aws_route53_zone.main.name}/configurations/credentials.json"
  content = jsonencode({
    certmanager_credentials = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.certmanager[each.value] },
    externaldns_credentials = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.externaldns[each.value] },
    loki_credentials        = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.loki_s3["loki.${each.value}.${var.tenant_key}.${data.aws_route53_zone.management_tenant_dns.name}"] },
    tempo_credentials       = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.loki_s3["tempo.${each.value}.${var.tenant_key}.${data.aws_route53_zone.management_tenant_dns.name}"] },
    thanos_credentials      = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.loki_s3["thanos.${each.value}.${var.tenant_key}.${data.aws_route53_zone.management_tenant_dns.name}"] },
    opsgenie_credentials    = lookup(module.opsgenie_teams.opsgenie_prometheus_api_keys, split(".", each.value)[0], null),
    vault_credentials       = { (aws_route53_zone.clusters[each.value].name) = aws_iam_access_key.vault_s3[each.value] },
  })

  content_type           = "application/json"
  server_side_encryption = "AES256"
  acl                    = "private"
}
