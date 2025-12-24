
variable "provider_credentials" {
  description = "Provider credentials"
  type        = map(any)
}

variable "autoglue_cluster_name" {
  description = "Name of the autoglue cluster"
  type        = string
}

variable "autoglue_org_id" {
  description = "Autoglue organization ID"
  type        = string
  sensitive   = true
}

variable "autoglue_key" {
  description = "Autoglue API key"
  type        = string
  sensitive   = true
}

variable "autoglue_org_secret" {
  description = "Autoglue organization secret"
  type        = string
  sensitive   = true
}

variable "autoglue_base_url" {
  description = "Autoglue API base URL"
  type        = string
  default     = "https://autoglue.glueopshosted.com/api/v1"
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

variable "aws_region" {
  description = "AWS region for Route53"
  type        = string
  default     = "us-west-2"
}

variable "domain_name" {
  description = "Domain name for Route53"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}


output "gluekube_tfvars" {
  value = templatefile("${path.module}/tfvars.tpl", {
    provider_credentials = var.provider_credentials
    autoglue_cluster_name = var.autoglue_cluster_name
    autoglue_org_id       = var.autoglue_org_id
    autoglue_key          = var.autoglue_key
    autoglue_org_secret   = var.autoglue_org_secret
    autoglue_base_url     = var.autoglue_base_url
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
    aws_region            = var.aws_region
    domain_name           = var.domain_name
    route53_zone_id       = var.route53_zone_id
  })
}
