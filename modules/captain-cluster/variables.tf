
variable "tenant" {
  description = "Shared tenant values produced by the tenant-base module (its captain_cluster_inputs output)."
  type = object({
    tenant_key                                                 = string
    tenant_account_id                                          = string
    this_is_development                                        = string
    primary_region                                             = string
    backup_region                                              = string
    github_owner                                               = string
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

variable "tenant_secrets" {
  description = "Shared tenant secrets produced by the tenant-base module (its captain_cluster_secrets output)."
  type = object({
    autoglue_iam = object({
      access_key_id     = string
      secret_access_key = string
    })
    autoglue_credentials = optional(object({
      autoglue_key        = string
      autoglue_org_secret = string
      base_url            = string
    }))
  })
  sensitive = true
  nullable  = false
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

locals {
  record_ttl     = "60"
  ns_record_type = "NS"
  bucket_name    = "glueops-tenant-${var.tenant.tenant_key}"
}
