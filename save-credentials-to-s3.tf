locals {
  combined_outputs = {
    opsgenie_credentials     = module.opsgenie_teams.opsgenie_prometheus_api_keys
    certmanager_credentials  = { for user, keys in aws_iam_access_key.certmanager : aws_route53_zone.clusters[user].name => keys }
    externaldns_credentials  = { for user, keys in aws_iam_access_key.externaldns : aws_route53_zone.clusters[user].name => keys }
    loki_credentials         = { for user, keys in aws_iam_access_key.loki_s3 : aws_route53_zone.clusters[user].name => keys }
    vault_credentials        = { for user, keys in aws_iam_access_key.vault_s3 : aws_route53_zone.clusters[user].name => keys }
  }
}

resource "aws_s3_bucket_object" "combined_outputs" {
  bucket       =  module.common_s3.id
  key          = "combined_outputs.json"
  content      = jsonencode(local.combined_outputs)
  content_type = "application/json"
}