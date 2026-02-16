terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
    autoglue = {
      source  = "registry.terraform.io/GlueOps/autoglue"
      version = "0.10.5"
    }
  }
}

provider "aws" {
  alias  = "clientaccount"
  region = var.primary_region
  assume_role {
    role_arn = "arn:aws:iam::${var.tenant_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "management-tenant-dns"
  region = var.primary_region
  assume_role {
    role_arn = "arn:aws:iam::${var.management_tenant_dns_aws_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "primaryregion"
  region = var.primary_region
  assume_role {
    role_arn = "arn:aws:iam::${var.tenant_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "replicaregion"
  region = var.backup_region
  assume_role {
    role_arn = "arn:aws:iam::${var.tenant_account_id}:role/OrganizationAccountAccessRole"
  }
}


provider "autoglue" {
  base_url   = var.autoglue_credentials.base_url
  org_key    = var.autoglue_credentials.autoglue_key
  org_secret = var.autoglue_credentials.autoglue_org_secret
}