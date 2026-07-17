terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.clientaccount, aws.management-tenant-dns, aws.primaryregion, aws.replicaregion]
    }
    random = {
      source = "hashicorp/random"
    }
    autoglue = {
      source = "registry.terraform.io/GlueOps/autoglue"
    }
  }
}
