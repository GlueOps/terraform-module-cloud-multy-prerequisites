terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.clientaccount, aws.primaryregion, aws.replicaregion]
    }
    random = {
      source = "hashicorp/random"
    }
    # inherited default provider (no alias): nested modules create the captain
    # repository with it, and the CALLER configures provider "github" at the
    # root. Declared source-only so the module's provider surface is
    # machine-readable; version pinning is a fleet-level decision.
    github = {
      source = "integrations/github"
    }
  }
}
