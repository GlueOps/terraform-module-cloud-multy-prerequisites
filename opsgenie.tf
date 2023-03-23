module "opsgenie_teams" {
  source               = "./modules/opsgenie/0.1.0"
  users                = var.opsgenie_emails
  company_key          = var.company_key
  cluster_environments = var.cluster_environments
}
