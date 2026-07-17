
variable "tenant" {
  description = "Shared tenant values produced by the tenant-base module (its captain_cluster_inputs output)."
  type = object({
    parent_zone_id                                             = string
    parent_zone_name                                           = string
    management_tenant_dns_zone_name                            = string
    dnssec_kms_key_arn                                         = string
    s3_multi_region_access_point_arn                           = string
    s3_multi_region_access_point_arn_for_object_level_policies = string
    s3_primary_arn                                             = string
    s3_replica_arn                                             = string
    tls_cert_backup_s3_key_prefix                              = string
    vault_backup_s3_key_prefix                                 = string
    autoglue_credential_route53_id                             = string
  })
  nullable = false
}

variable "tenant_autoglue_iam" {
  description = "IAM access key of the shared route53 autoglue user (tenant-base autoglue_iam_credentials output)."
  type = object({
    access_key_id     = string
    secret_access_key = string
  })
  sensitive = true
  nullable  = false
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
    environment_name                        = string
    host_network_enabled                    = bool
    traefik_enable_internal_lb              = optional(bool, false)
    traefik_enable_public_lb                = optional(bool, true)
    nginx_enable_public_lb                  = optional(bool, true)
    prometheus_volume_claim_storage_request = optional(string, "50")
    vault_data_storage                      = optional(string, "10")
    nginx_controller_replica_count          = optional(string, "2")
    traefik_internal_lb_deployment_replicas = optional(string, "2")
    traefik_public_lb_deployment_replicas   = optional(string, "2")
    github_oauth_app_client_id              = string
    github_oauth_app_client_secret          = string
    github_tenant_app_id                    = string
    github_tenant_app_installation_id       = string
    github_tenant_app_b64enc_private_key    = string
    admin_github_org_name                   = string
    tenant_github_org_name                  = string
    kubeadm_cluster                         = optional(bool, false)
    vault_github_org_team_policy_mappings = list(object({
      oidc_groups = list(string)
      policy_name = string
    }))
    argocd_rbac_policies = string
    provider_credentials = optional(map(any), null)
    waggle_credentials = optional(object({
      waggle_endpoint      = string
      waggle_api_key       = string
      waggle_datacenter_id = string
    }), null)
  }))
  nullable = false
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
  record_ttl     = "60"
  ns_record_type = "NS"
  bucket_name    = "glueops-tenant-${var.tenant_key}"
}
