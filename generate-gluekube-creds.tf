module "generate_gluekube_creds" {
  for_each = {
    for k, v in local.environment_map : k => v
    if try(v.autoglue.autoglue_cluster_name != null, false) && try(v.provider_credentials != null, false)
  }
  source                = "./modules/gluekube/0.1.0"
  aws_access_key_id     = aws_iam_access_key.autoglue[each.value.environment_name].id
  aws_secret_access_key = aws_iam_access_key.autoglue[each.value.environment_name].secret
  domain_name           = "${each.value.environment_name}.${aws_route53_zone.main.name}"
  route53_zone_id       = aws_route53_zone.clusters[each.value.environment_name].zone_id
  route53_region        = var.primary_region
  autoglue_org_id       = each.value.autoglue.credentials.autoglue_org_id
  autoglue_key          = each.value.autoglue.credentials.autoglue_key
  autoglue_org_secret   = each.value.autoglue.credentials.autoglue_org_secret
  autoglue_base_url     = each.value.autoglue.credentials.base_url
  autoglue_cluster_name = each.value.autoglue.autoglue_cluster_name
  provider_credentials  = each.value.provider_credentials
}
