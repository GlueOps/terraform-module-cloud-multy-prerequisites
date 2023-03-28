data "aws_route53_zone" "management_tenant_dns" {
  zone_id = local.management_tenant_dns_zoneid
}


resource "aws_route53_record" "delegation_to_parent_tenant_zone" {
  provider = aws.management-tenant-dns
  zone_id  = aws_route53_zone.main.zone_id
  name     = aws_route53_zone.main.name
  type     = local.ns_record_type
  ttl      = local.record_ttl
  records  = aws_route53_zone.main.name_servers
}
