
variable "management_tenant_dns_zoneid" {
  description = "The Route53 ZoneID that all the delegation is coming from."
  type        = string
  nullable    = false
}


variable "this_is_development" {
  description = "The development cluster environment and data/resources can be destroyed!"
  type        = string
  nullable    = false
  default     = false
}

variable "tenant_key" {
  description = "The tenant key"
  type        = string
  nullable    = false
}

variable "tenant_account_id" {
  description = "The tenant AWS account id"
  type        = string
  nullable    = false
}

variable "github_owner" {
  description = "The GitHub Owner where the tenant repo will be deployed."
  type        = string
  nullable    = false
}

variable "management_tenant_dns_aws_account_id" {
  description = "The company AWS account id for the management-tenant-dns account"
  type        = string
  nullable    = false
}

variable "cluster_environments" {
  description = "The cluster environments and their respective github app ids"
  type = list(object({
    environment_name                     = string
    host_network_enabled                 = bool
    github_oauth_app_client_id           = string
    github_oauth_app_client_secret       = string
    github_tenant_app_id                 = string
    github_tenant_app_installation_id    = string
    github_tenant_app_b64enc_private_key = string
    admin_github_org_name                = string
    tenant_github_org_name               = string
    vault_github_org_team_policy_mappings = list(object({
      oidc_groups = list(string)
      policy_name = string
    }))
    argocd_rbac_policies = string
  }))
  default = [
    {
      environment_name                     = "test"
      host_network_enabled                 = true
      github_oauth_app_client_id           = "oauth-app-id"
      github_oauth_app_client_secret       = "oauth-app-secret"
      github_tenant_app_id                 = "tenant-github-app-id"
      github_tenant_app_installation_id    = "tenant-github-app-installation-id"
      github_tenant_app_b64enc_private_key = "tenant-github-app-b64enc-private-key"
      admin_github_org_name                = "GlueOps"
      tenant_github_org_name               = "glueops-rocks"
      vault_github_org_team_policy_mappings = [
        {
          oidc_groups = ["GlueOps:vault_super_admins"]
          policy_name = "editor"
        },
        {
          oidc_groups = ["GlueOps:vault_super_admins", "testing-okta:developers"]
          policy_name = "reader"
        }
      ]
      argocd_rbac_policies = <<EOT
      g, GlueOps:argocd_super_admins, role:admin
      g, glueops-rocks:developers, role:developers
      p, role:developers, clusters, get, *, allow
      p, role:developers, *, get, development, allow
      p, role:developers, repositories, *, development/*, allow
      p, role:developers, applications, *, development/*, allow
      p, role:developers, exec, *, development/*, allow
EOT
    },

  ]

}

locals {
  environment_map = { for env in var.cluster_environments : env.environment_name => env }
}

locals {
  cluster_environments = toset(keys(local.environment_map))
}

variable "primary_region" {
  description = "The primary S3 region to create S3 bucket in used for backups. This should be the same region as the one where the cluster is being deployed."
  type        = string
  nullable    = false
}

variable "backup_region" {
  description = "The secondary S3 region to create S3 bucket in used for backups. This should be different than the primary region and will have the data from the primary region replicated to it."
  type        = string
  nullable    = false
}

locals {
  management_tenant_dns_zoneid = var.management_tenant_dns_zoneid
  record_ttl                   = "60"
  ns_record_type               = "NS"
  bucket_name                  = "glueops-tenant-${var.tenant_key}"
}

variable "opsgenie_emails" {
  description = "List of user email addresses"
  type        = list(string)
}
