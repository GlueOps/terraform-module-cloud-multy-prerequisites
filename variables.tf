
variable "management_tenant_dns_zoneid" {
  description = "The Route53 ZoneID that all the delegation is coming from"
  type        = string
  nullable    = false
}


variable "this_is_development" {
  description = "The development cluster environment and data/resources can be destroyed!"
  type        = string
  nullable    = false
  default     = false
}

variable "company_key" {
  description = "The company key"
  type        = string
  nullable    = false
}

variable "company_account_id" {
  description = "The company AWS account id"
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
    environment_name         = string
    github_app_client_id     = string
    github_app_client_secret = string
    vault_github_org_team_policy_mappings = list(object({
      oidc_groups = list(string)
      policy_name = string
    }))
  }))
  default = [
    {
      environment_name         = "test"
      github_app_client_id     = "apidgoeshere"
      github_app_client_secret = "secretgoeshere"
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
    }
  ]
}


locals {
  cluster_environments = toset([for cluster_environment in var.cluster_environments : cluster_environment.environment_name])
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
  company_key                  = var.company_key
  record_ttl                   = "60"
  ns_record_type               = "NS"
  bucket_name                  = "glueops-tenant-${local.company_key}"
}

variable "opsgenie_emails" {
  description = "List of user email addresses"
  type        = list(string)
}

variable "vault_github_org_team_policy_mappings" {
  description = "The org team policy mappings"
  type = list(object({
    oidc_groups = list(string)
    policy_name = string
  }))
  default = [
    {
      oidc_groups = ["GlueOps:vault_super_admins"]
      policy_name = "editor"
    },
    {
      oidc_groups = ["GlueOps:vault_super_admins", "testing-okta:developers"]
      policy_name = "reader"
    }
  ]
  nullable = false
}

variable "argocd_rbac_policies" {
  type        = string
  description = "policy csv for tenants: https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/"
  default     = <<EOT
      g, GlueOps:argocd_super_admins, role:admin
      g, glueops-rocks:developers, role:developers
      p, role:developers, clusters, get, *, allow
      p, role:developers, *, get, development, allow
      p, role:developers, repositories, *, development/*, allow
      p, role:developers, applications, *, development/*, allow
      p, role:developers, exec, *, development/*, allow
EOT
}