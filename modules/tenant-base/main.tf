data "aws_route53_zone" "management_tenant_dns" {
  provider = aws.management-tenant-dns
  zone_id  = local.management_tenant_dns_zoneid
}

resource "aws_route53_zone" "main" {
  provider = aws.clientaccount
  name     = "${var.tenant_key}.${data.aws_route53_zone.management_tenant_dns.name}"
}

resource "aws_route53_record" "delegation_to_parent_tenant_zone" {
  provider   = aws.management-tenant-dns
  zone_id    = data.aws_route53_zone.management_tenant_dns.zone_id
  name       = aws_route53_zone.main.name
  type       = local.ns_record_type
  ttl        = local.record_ttl
  records    = aws_route53_zone.main.name_servers
  depends_on = [aws_route53_zone.main]
}



module "dnssec_key" {
  source         = "git::https://github.com/GlueOps/terraform-module-cloud-aws-dnssec-kms-key.git?ref=v0.3.0"
  aws_account_id = var.tenant_account_id
}

resource "aws_route53_key_signing_key" "parent_tenant_zone" {
  provider                   = aws.clientaccount
  hosted_zone_id             = aws_route53_zone.main.zone_id
  key_management_service_arn = module.dnssec_key.kms_key_arn
  name                       = "primary"
  status                     = "ACTIVE"
  depends_on                 = [aws_route53_zone.main]

}

resource "aws_route53_hosted_zone_dnssec" "parent_tenant_zone" {
  provider = aws.clientaccount
  depends_on = [
    aws_route53_key_signing_key.parent_tenant_zone,
    aws_route53_zone.main
  ]
  hosted_zone_id = aws_route53_key_signing_key.parent_tenant_zone.hosted_zone_id
}

resource "aws_route53_record" "enable_dnssec_for_parent_tenant_zone" {
  provider = aws.management-tenant-dns
  zone_id  = data.aws_route53_zone.management_tenant_dns.zone_id
  name     = aws_route53_zone.main.name
  type     = "DS"
  ttl      = local.record_ttl
  records  = [aws_route53_key_signing_key.parent_tenant_zone.ds_record]
}
