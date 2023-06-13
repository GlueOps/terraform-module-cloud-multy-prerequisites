terraform {
  required_providers {
    cloudflare = {
      source  = "terraform-registry-proxy.gpkg.io/cloudflare/cloudflare"
    }
    aws = {
      source  = "terraform-registry-proxy.gpkg.io/hashicorp/aws"
    }
    random = {
      source  = "terraform-registry-proxy.gpkg.io/hashicorp/random"
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
