terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.clientaccount, aws.management-tenant-dns, aws.primaryregion, aws.replicaregion, aws.dnssec-us-east-1]
    }
    random = {
      source = "hashicorp/random"
    }
    autoglue = {
      source  = "registry.terraform.io/GlueOps/autoglue"
      version = "0.10.12"
    }
  }
}
