module "generate_gluekube_creds" {
  for_each = {
    for k, v in local.environment_map : k => v
    if try(v.provider_credentials != null, false)
  }
  source                  = "./modules/gluekube/0.1.0"
  aws_access_key_id       = aws_iam_access_key.autoglue.id
  aws_secret_access_key   = aws_iam_access_key.autoglue.secret
  domain_name             = "${each.value.environment_name}.${aws_route53_zone.main.name}"
  route53_zone_id         = aws_route53_zone.clusters[each.value.environment_name].zone_id
  route53_region          = var.primary_region
  autoglue_key            = var.autoglue_credentials.autoglue_key
  autoglue_org_secret     = var.autoglue_credentials.autoglue_org_secret
  autoglue_base_url       = var.autoglue_credentials.base_url
  autoglue_cluster_name   = "${each.value.environment_name}.${aws_route53_zone.main.name}"
  autoglue_credentials_id = autoglue_credential.route53.id
  provider_credentials    = each.value.provider_credentials
}

resource "autoglue_credential" "route53" {
  name                = "${var.tenant_key}-route53-autoglue-credentials"
  account_id          = "1234567890"
  credential_provider = "aws"
  kind                = "aws_access_key"

  schema_version = "1"


  # Whatever your provider expects for the AWS/Route53 scope:
  scope = {
    service = "route53"
  }

  scope_version = 1
  scope_kind    = "service"

  secret = {
    access_key_id     = aws_iam_access_key.autoglue.id
    secret_access_key = aws_iam_access_key.autoglue.secret
  }

  region = var.primary_region
}