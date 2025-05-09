variable "tenant_key" {
  description = "The root name of the s3 bucket to be created, will be suffixed with '-primary' and '-replica'"
  type        = string
  nullable    = false
  default     = false
}

variable "this_is_development" {
  description = "The development cluster environment and data/resources can be destroyed!"
  type        = string
  nullable    = false
  default     = false
}

variable "tenant_account_id" {
  description = "The tenant AWS account id"
  type        = string
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

variable "cluster_zone_names" {
  description = "A map of cluster environment keys to their Route 53 Zone names."
  type        = map(string)
  # default     = {}
}