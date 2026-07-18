module "generate_gluekube_creds" {
  for_each = {
    for k, v in local.environment_map : k => v
    if try(v.provider_credentials != null, false)
  }
  source                     = "../gluekube/0.1.0"
  aws_access_key_id          = var.tenant_secrets.autoglue_iam.access_key_id
  aws_secret_access_key      = var.tenant_secrets.autoglue_iam.secret_access_key
  domain_name                = "${each.value.environment_name}.${var.tenant.parent_zone_name}"
  route53_zone_id            = aws_route53_zone.clusters[each.value.environment_name].zone_id
  route53_region             = var.tenant.primary_region
  autoglue_key               = var.tenant_secrets.autoglue_credentials.autoglue_key
  autoglue_org_secret        = var.tenant_secrets.autoglue_credentials.autoglue_org_secret
  autoglue_base_url          = var.tenant_secrets.autoglue_credentials.base_url
  include_waggle_credentials = each.value.waggle_credentials != null
  waggle_endpoint            = try(each.value.waggle_credentials.waggle_endpoint, "")
  waggle_api_key             = try(each.value.waggle_credentials.waggle_api_key, "")
  waggle_datacenter_id       = try(each.value.waggle_credentials.waggle_datacenter_id, "")
  autoglue_cluster_name      = "${each.value.environment_name}.${var.tenant.parent_zone_name}"
  autoglue_credentials_id    = var.tenant.autoglue_credential_route53_id
  provider_credentials       = each.value.provider_credentials
}
