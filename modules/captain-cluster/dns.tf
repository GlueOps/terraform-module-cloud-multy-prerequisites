resource "aws_route53_zone" "clusters" {
  provider      = aws.clientaccount
  for_each      = local.cluster_environments
  name          = "${each.value}.${var.tenant.tenant_key}.${var.tenant.management_tenant_dns_zone_name}"
  force_destroy = var.tenant.this_is_development ? true : false
}

resource "aws_route53_key_signing_key" "cluster_zones" {
  provider                   = aws.clientaccount
  for_each                   = aws_route53_zone.clusters
  hosted_zone_id             = aws_route53_zone.clusters[each.key].zone_id
  key_management_service_arn = var.tenant.dnssec_kms_key_arn
  name                       = "primary"
  status                     = "ACTIVE"
  depends_on = [
    aws_route53_zone.clusters
  ]
}

resource "aws_route53_hosted_zone_dnssec" "cluster_zones" {
  provider = aws.clientaccount

  for_each = aws_route53_zone.clusters

  depends_on = [
    aws_route53_key_signing_key.cluster_zones,
    aws_route53_zone.clusters
  ]
  hosted_zone_id = aws_route53_key_signing_key.cluster_zones[each.key].hosted_zone_id
}

resource "aws_route53_record" "cluster_zone_dnssec_records" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  zone_id  = var.tenant.parent_zone_id
  name     = each.value.name
  type     = "DS"
  ttl      = local.record_ttl
  records  = [aws_route53_key_signing_key.cluster_zones[each.key].ds_record]
  depends_on = [
    aws_route53_hosted_zone_dnssec.cluster_zones,
    aws_route53_zone.clusters
  ]
}

resource "aws_route53_record" "cluster_zone_ns_records" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  zone_id  = var.tenant.parent_zone_id
  name     = each.value.name
  type     = local.ns_record_type
  ttl      = local.record_ttl
  records  = aws_route53_zone.clusters[each.key].name_servers
  depends_on = [
    aws_route53_zone.clusters
  ]
}


resource "aws_route53_record" "wildcard_for_apps" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  zone_id  = each.value.zone_id
  name     = "*.apps.${each.value.name}"
  type     = "CNAME"
  ttl      = local.record_ttl
  records  = ["ingress.${each.value.name}"]
  depends_on = [
    aws_route53_zone.clusters
  ]
}
