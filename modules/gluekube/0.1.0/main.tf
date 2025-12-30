
variable "provider_credentials" {
  description = <<-EOT
  Provider-specific credentials for gluekube configuration, represented as a map from 
  provider identifiers (for example, \"aws\") to their credential objects. Each provider entry must be an \
  object whose string fields match the credential attributes required by that provider (for example, for \
  AWS Route53: { access_key_id = string, secret_access_key = string, region = string }). This map is passed \
  through to a downstream module and JSON-encoded into the generated tfvars file."
  # Expected structure (example):
  # {
  #     access_key_id     = "AKIA..."
  #     secret_access_key = "..."
  #     region            = "us-east-1"
  #   },
  #   another_provider = {
  #     client_id     = "..."
  #     client_secret = "..."
  #   }
  # }
  EOT
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

variable "route53_region" {
  description = "AWS region for Route53"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Route53"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "autoglue_credentials_id" {
  type        = string
  description = "autoglue credentials_id"
}

output "gluekube_tfvars" {
  value = templatefile("${path.module}/tfvars.tpl", {
    provider_credentials    = var.provider_credentials
    autoglue_cluster_name   = var.autoglue_cluster_name
    autoglue_org_id         = var.autoglue_org_id
    autoglue_key            = var.autoglue_key
    autoglue_org_secret     = var.autoglue_org_secret
    autoglue_base_url       = var.autoglue_base_url
    aws_access_key_id       = var.aws_access_key_id
    aws_secret_access_key   = var.aws_secret_access_key
    domain_name             = var.domain_name
    route53_zone_id         = var.route53_zone_id
    route53_region          = var.route53_region
    autoglue_credentials_id = var.autoglue_credentials_id

  })
  sensitive = true
}

output "gluekube_variables_tf" {
  value = templatefile("${path.module}/variables.tf.tpl", {})
}
