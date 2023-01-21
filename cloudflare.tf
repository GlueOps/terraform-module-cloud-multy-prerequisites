
data "cloudflare_zone" "delegator" {
  name = local.domain_to_delegate_from
}

resource "cloudflare_record" "delegation_ns_record_first" {
  zone_id  = data.cloudflare_zone.delegator.id
  name     = aws_route53_zone.main.name
  value    = aws_route53_zone.main.name_servers[0]
  type     = local.ns_record_type
  ttl      = local.ns_record_ttl
  proxied  = false
  priority = null
}


resource "cloudflare_record" "delegation_ns_record_second" {
  zone_id  = data.cloudflare_zone.delegator.id
  name     = aws_route53_zone.main.name
  value    = aws_route53_zone.main.name_servers[1]
  type     = local.ns_record_type
  ttl      = local.ns_record_ttl
  proxied  = false
  priority = null
}

resource "cloudflare_record" "delegation_ns_record_third" {
  zone_id  = data.cloudflare_zone.delegator.id
  name     = aws_route53_zone.main.name
  value    = aws_route53_zone.main.name_servers[2]
  type     = local.ns_record_type
  ttl      = local.ns_record_ttl
  proxied  = false
  priority = null
}

resource "cloudflare_record" "delegation_ns_record_fourth" {
  zone_id  = data.cloudflare_zone.delegator.id
  name     = aws_route53_zone.main.name
  value    = aws_route53_zone.main.name_servers[3]
  type     = local.ns_record_type
  ttl      = local.ns_record_ttl
  proxied  = false
  priority = null
}