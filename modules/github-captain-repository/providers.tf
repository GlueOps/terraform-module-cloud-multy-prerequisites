terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.25.0"
    }
  }
}

provider "github" {
  owner = var.organization
}
