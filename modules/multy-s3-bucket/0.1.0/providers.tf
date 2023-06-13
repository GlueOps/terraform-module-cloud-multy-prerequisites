terraform {
  required_providers {
    aws = {
      source = "terraform-registry-proxy.gpkg.io/hashicorp/aws"

      configuration_aliases = [
        aws.primaryregion,
        aws.replicaregion
      ]
    }
  }
}
