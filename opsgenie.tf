module "opsgenie_teams" {
  source               = "./modules/opsgenie/0.1.0"
  users                = var.opsgenie_emails
  company_key          = var.company_key
  cluster_environments = var.cluster_environments
}

# output "opsgenie_credentials" {
#   value       = module.opsgenie_teams.opsgenie_prometheus_api_keys
#   description = "A map of OpsGenie API Keys. One per Cluster Environment"
# }

// combine all the outputs in this terraform to a single json file
