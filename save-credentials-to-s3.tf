locals {
  combined_outputs = {
    opsgenie_credentials    = module.opsgenie_teams.opsgenie_prometheus_api_keys
    certmanager_credentials = { for user, keys in aws_iam_access_key.certmanager : aws_route53_zone.clusters[user].name => keys }
    externaldns_credentials = { for user, keys in aws_iam_access_key.externaldns : aws_route53_zone.clusters[user].name => keys }
    loki_credentials        = { for user, keys in aws_iam_access_key.loki_s3 : aws_route53_zone.clusters[user].name => keys }
    vault_credentials       = { for user, keys in aws_iam_access_key.vault_s3 : aws_route53_zone.clusters[user].name => keys }
  }


  cluster_names = toset([for k in keys(local.combined_outputs.certmanager_credentials) : k])

}

resource "aws_s3_bucket_object" "combined_outputs" {
  for_each     = {
    for name in local.cluster_names :
    name => {
      certmanager_credentials = local.combined_outputs.certmanager_credentials[name]
      externaldns_credentials = local.combined_outputs.externaldns_credentials[name]
      loki_credentials        = local.combined_outputs.loki_credentials[name]
      opsgenie_credentials    = lookup(local.combined_outputs.opsgenie_credentials, split(".", name)[0], null)
      vault_credentials       = local.combined_outputs.vault_credentials[name]
    }
  }
  provider     = aws.primaryregion
  bucket       = module.common_s3.primary_s3_bucket_id
  key          = "${each.key}/configurations/credentials.json"
  content      = jsonencode(each.value)
  content_type = "application/json"
}