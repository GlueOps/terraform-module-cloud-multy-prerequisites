resource "aws_route53_zone" "main" {
  provider = aws.clientaccount
  name     = "${local.company_key}.${local.domain_to_delegate_from}"
}

resource "aws_route53_zone" "clusters" {
  provider = aws.clientaccount
  for_each = toset(var.cluster_environments)
  name     = "${each.value}.${local.company_key}.${local.domain_to_delegate_from}"
  depends_on = [
    aws_route53_zone.main
  ]
  force_destroy = var.this_is_development ? true : false
}

resource "aws_route53_record" "cluster_subdomain_ns_records" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  zone_id  = aws_route53_zone.main.zone_id
  name     = each.value.name
  type     = local.ns_record_type
  ttl      = local.ns_record_ttl
  records  = aws_route53_zone.clusters[each.key].name_servers
}


