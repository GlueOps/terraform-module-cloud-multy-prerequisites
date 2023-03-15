
variable "domain_to_delegate_from" {
  description = "The domain name of the domain that all delegation is coming from"
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

variable "cluster_environments" {
  description = "The cluster environments"
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
  domain_to_delegate_from = var.domain_to_delegate_from
  company_key             = var.company_key
  record_ttl              = "60"
  ns_record_type          = "NS"
  bucket_name             = "glueops-tenant-${local.company_key}"
}

variable "opsgenie_emails" {
  description = "List of user email addresses"
  type        = list(string)
}