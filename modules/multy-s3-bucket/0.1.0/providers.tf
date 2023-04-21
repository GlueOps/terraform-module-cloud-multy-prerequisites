terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"

      configuration_aliases = [
        aws.primaryregion,
        aws.replicaregion
      ]
    }
  }
}
