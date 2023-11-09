module "opsgenie_teams" {
  source               = "./modules/opsgenie/0.1.0"
  users                = var.opsgenie_emails
  tenant_key           = var.tenant_key
  cluster_environments = local.cluster_environments
  domain               = aws_route53_zone.main.name
}
