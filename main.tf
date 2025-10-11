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


## ADD THIS RESOURCE (Sleep for the Main Zone) ##
# This creates a delay after the DS record below is deleted.
resource "time_sleep" "wait_for_main_zone_ds_propagation" {
  destroy_duration = "360s"

  # This dependency forces the correct destroy order.
  depends_on = [aws_route53_hosted_zone_dnssec.parent_tenant_zone]
}

## MODIFY THIS RESOURCE (Add depends_on for the Main Zone DS Record) ##
resource "aws_route53_record" "enable_dnssec_for_parent_tenant_zone" {
  provider = aws.management-tenant-dns
  zone_id  = data.aws_route53_zone.management_tenant_dns.zone_id
  name     = aws_route53_zone.main.name
  type     = "DS"
  ttl      = local.record_ttl
  records  = [aws_route53_key_signing_key.parent_tenant_zone.ds_record]
  
  # This new dependency ensures this DS record is deleted BEFORE the sleep starts.
  depends_on = [time_sleep.wait_for_main_zone_ds_propagation]
}

resource "aws_route53_zone" "clusters" {
  provider = aws.clientaccount
  for_each = local.cluster_environments
  name     = "${each.value}.${var.tenant_key}.${data.aws_route53_zone.management_tenant_dns.name}"
  depends_on = [
    aws_route53_zone.main
  ]
  force_destroy = var.this_is_development ? true : false
}

resource "aws_route53_key_signing_key" "cluster_zones" {
  provider                   = aws.clientaccount
  for_each                   = aws_route53_zone.clusters
  hosted_zone_id             = aws_route53_zone.clusters[each.key].zone_id
  key_management_service_arn = module.dnssec_key.kms_key_arn
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

## ADD THIS RESOURCE (Sleep for the Cluster Zones) ##
# This creates a delay for each cluster after its corresponding DS record is deleted.
resource "time_sleep" "wait_for_cluster_zone_ds_propagation" {
  for_each = aws_route53_zone.clusters

  destroy_duration = "360s"

  # This dependency ensures the correct destroy order for each cluster.
  depends_on = [aws_route53_hosted_zone_dnssec.cluster_zones]
}

## MODIFY THIS RESOURCE (Add depends_on for the Cluster DS Records) ##
resource "aws_route53_record" "cluster_zone_dnssec_records" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  zone_id  = aws_route53_zone.main.zone_id
  name     = each.value.name
  type     = "DS"
  ttl      = local.record_ttl
  records  = [aws_route53_key_signing_key.cluster_zones[each.key].ds_record]

  # This new dependency ensures each cluster DS record is deleted BEFORE its sleep starts.
  depends_on = [
    time_sleep.wait_for_cluster_zone_ds_propagation,
    aws_route53_hosted_zone_dnssec.cluster_zones,
    aws_route53_zone.main,
    aws_route53_zone.clusters
  ]
}

resource "aws_route53_record" "cluster_zone_ns_records" {
  provider = aws.clientaccount
  for_each = aws_route53_zone.clusters
  zone_id  = aws_route53_zone.main.zone_id
  name     = each.value.name
  type     = local.ns_record_type
  ttl      = local.record_ttl
  records  = aws_route53_zone.clusters[each.key].name_servers
  depends_on = [
    aws_route53_zone.main,
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
