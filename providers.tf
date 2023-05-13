terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  alias  = "clientaccount"
  region = var.primary_region
  assume_role {
    role_arn = "arn:aws:iam::${var.company_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "primaryregion"
  region = var.primary_region
  assume_role {
    role_arn = "arn:aws:iam::${var.company_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "replicaregion"
  region = var.backup_region
  assume_role {
    role_arn = "arn:aws:iam::${var.company_account_id}:role/OrganizationAccountAccessRole"
  }
}

