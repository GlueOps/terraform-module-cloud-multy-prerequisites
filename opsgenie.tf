module "opsgenie_teams" {
  source               = "./modules/opsgenie/0.1.0"
  users                = var.opsgenie_emails
  company_key          = var.company_key
  cluster_environments = var.cluster_environments
}

output "opsgenie_prometheus_api_keys" {
  value = {
    for env_key, env_value in local.cluster_environments_set : env_key => opsgenie_teams.opsgenie_prometheus_api_keys[env_key]
  }
  description = "A map of the Opsgenie API keys for the Prometheus integrations."
}
