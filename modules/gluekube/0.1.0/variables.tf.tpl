variable "provider_credentials" {
  description = "Provider credentials for a cloud provider"
  type = map(string)
}

variable "autoglue_cluster_name" {
  description = "Name of the AutoGlue cluster"
  type        = string
}

variable "autoglue_org_id" {
  description = "AutoGlue organization ID"
  type        = string
}

variable "autoglue_key" {
  description = "AutoGlue API key"
  type        = string
  sensitive   = true
}

variable "autoglue_org_secret" {
  description = "AutoGlue organization secret"
  type        = string
  sensitive   = true
}

variable "autoglue_base_url" {
  description = "AutoGlue API base URL"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS access key ID for Route53"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key for Route53"
  type        = string
  sensitive   = true
}

variable "route53_region" {
  description = "AWS region for Route53"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the cluster"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}
