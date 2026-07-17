
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

variable "environment_names" {
  description = "The environment names of every cluster environment in this tenant. Used to derive the cluster zone names for the shared backup bucket lifecycle rules."
  type        = list(string)
  nullable    = false
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
