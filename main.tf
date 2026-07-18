# Backwards-compatible wrapper.
#
# The resources that used to live at the root of this module have been split into
# two submodules so tenants can control versions per cluster:
#   - modules/tenant-base:     shared per-tenant resources (parent zone, DNSSEC KMS
#                              key, shared S3 buckets, autoglue route53 IAM)
#   - modules/captain-cluster: everything scoped to a cluster environment, including
#                              every version pin (helm values, VERSIONS files, etc.)
#
# Tenants that call this module at the root (e.g. ?ref=main) get identical behavior
# to before the split: one captain-cluster instantiation covering all environments,
# with state migrated in place via moved.tf. To control versions per cluster,
# instantiate //modules/tenant-base once and //modules/captain-cluster once per
# cluster environment, each pinned to its own release tag.

module "tenant_base" {
  source = "./modules/tenant-base"
  providers = {
    aws.clientaccount         = aws.clientaccount
    aws.management-tenant-dns = aws.management-tenant-dns
    aws.primaryregion         = aws.primaryregion
    aws.replicaregion         = aws.replicaregion
    aws.dnssec-us-east-1      = aws.dnssec-us-east-1
  }
  tenant_key                   = var.tenant_key
  tenant_account_id            = var.tenant_account_id
  management_tenant_dns_zoneid = var.management_tenant_dns_zoneid
  this_is_development          = var.this_is_development
  primary_region               = var.primary_region
  backup_region                = var.backup_region
  github_owner                 = var.github_owner
  autoglue_credentials         = var.autoglue_credentials
  environment_names            = [for e in var.cluster_environments : e.environment_name]
}

module "captain_cluster" {
  source = "./modules/captain-cluster"
  providers = {
    aws.clientaccount = aws.clientaccount
    aws.primaryregion = aws.primaryregion
    aws.replicaregion = aws.replicaregion
  }
  cluster_environments = var.cluster_environments
  tenant               = module.tenant_base.captain_cluster_inputs
  tenant_secrets       = module.tenant_base.captain_cluster_secrets
}
