locals {
  combined_outputs = {
    opsgenie_credentials     = module.opsgenie_teams.opsgenie_prometheus_api_keys
    certmanager_credentials  = { for user, keys in aws_iam_access_key.certmanager : aws_route53_zone.clusters[user].name => keys }
    externaldns_credentials  = { for user, keys in aws_iam_access_key.externaldns : aws_route53_zone.clusters[user].name => keys }
    loki_credentials         = { for user, keys in aws_iam_access_key.loki_s3 : aws_route53_zone.clusters[user].name => keys }
    vault_credentials        = { for user, keys in aws_iam_access_key.vault_s3 : aws_route53_zone.clusters[user].name => keys }
  }


  cluster_names = toset([for k in keys(local.combined_outputs.certmanager_credentials) : k])

  updated_combined_outputs = {
    for name in local.cluster_names :
    name => {
      certmanager_credentials = local.combined_outputs.certmanager_credentials[name]
      externaldns_credentials = local.combined_outputs.externaldns_credentials[name]
      loki_credentials        = local.combined_outputs.loki_credentials[name]
      opsgenie_credentials    = local.combined_outputs.opsgenie_credentials[name]
      vault_credentials       = local.combined_outputs.vault_credentials[name]
    }
  }
}

resource "aws_s3_bucket_object" "combined_outputs" {
  provider     = aws.primaryregion
  bucket       =  module.common_s3.primary_s3_bucket_id
  key          = "combined_outputs.json"
  content      = jsonencode(local.updated_combined_outputs)
  content_type = "application/json"
}