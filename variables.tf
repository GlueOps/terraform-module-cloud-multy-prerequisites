
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

variable "autoglue_credentials" {
  type = object({
    autoglue_key        = string
    autoglue_org_secret = string
    base_url            = string
  })
  description = "The autoglue credentials object"
  nullable    = true
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
    kubeadm_cluster                      = optional(bool, false)
    vault_github_org_team_policy_mappings = list(object({
      oidc_groups = list(string)
      policy_name = string
    }))
    argocd_rbac_policies = string
    provider_credentials = optional(map(any), null)
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
      kubeadm_cluster                      = false
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
      provider_credentials = null
      autoglue             = null
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

locals {
  argocd_app_version        = "v3.0.20"
  codespace_version         = "v0.115.0"
  argocd_helm_chart_version = "8.2.7"
  glueops_platform_version  = "v0.66.0" # this also needs to be updated in the module.glueops_platform_helm_values // generate-helm-values.tf
  tools_version             = "v0.33.0"
  calico_helm_chart_version = "v3.30.4"
  calico_ctl_version        = "v3.30.4"
  tigera_operator_version   = "v1.38.7"
  terraform_module_version  = "v0.43.0"
}

variable "opsgenie_emails" {
  description = "List of user email addresses"
  type        = list(string)
  default     = [] # this for backward compatability
}
