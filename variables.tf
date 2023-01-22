
variable "domain_to_delegate_from" {
  description = "The domain name of the domain that all delegation is coming from"
  type        = string
  nullable    = false
}

variable "allow_force_destroy_of_cluster_zones" {
  description = "Allow cluster related zones that have records in them to be destroyed"
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

locals {
  domain_to_delegate_from = var.domain_to_delegate_from
  company_key             = var.company_key
  ns_record_ttl           = "60"
  ns_record_type          = "NS"
  aws_region              = "us-west-2"
}
