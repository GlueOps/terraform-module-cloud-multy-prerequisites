resource "aws_s3_bucket_object" "combined_outputs" {
  for_each     = {
    for name in var.cluster_environments :
    name => {
      certmanager_credentials = { for user, keys in aws_iam_access_key.certmanager : aws_route53_zone.clusters[user].name => keys }
      externaldns_credentials = { for user, keys in aws_iam_access_key.externaldns : aws_route53_zone.clusters[user].name => keys }
      loki_credentials        = { for user, keys in aws_iam_access_key.loki_s3 : aws_route53_zone.clusters[user].name => keys }
      opsgenie_credentials    = lookup(module.opsgenie_teams.opsgenie_prometheus_api_keys, split(".", name)[0], null)
      vault_credentials       = { for user, keys in aws_iam_access_key.vault_s3 : aws_route53_zone.clusters[user].name => keys }
    }
  }
  provider     = aws.primaryregion
  bucket       = module.common_s3.primary_s3_bucket_id
  key          = "${each.key}/configurations/credentials.json"
  content      = jsonencode(each.value)
  content_type = "application/json"
}