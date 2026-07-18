# Migrating a tenant to per-cluster module calls

One PR per tenant, **no scripts, no state access**. Works whether or not the
tenant has already picked up the backwards-compatible wrapper (the moved
blocks are chained and no-op wherever they don't apply).

## Conventions (required)

1. Environment names must come from the conventional list baked into
   `moved-migration.tf`: `nonprod`, `prod`, `dev`, `test`, `qa`, `staging`,
   `uat`, `sandbox`. Using another name? Add it to the list in this repo first
   (regenerate the file per its header) — the plan gate below will catch any
   environment the file doesn't cover.
2. One `module "cluster_<environment_name>"` block per environment — the label
   must be exactly `cluster_` + the environment name.
3. Each cluster block passes `cluster_environments = [ <that one environment
   object> ]` (the same object it had inside the old wrapper call, verbatim).
4. The old wrapper call `module "tenant"` is deleted entirely in the same PR.

## Steps

1. Copy `docs/migration/moved-migration.tf` (from the module ref you are
   pinning) into the tenant repo root, verbatim.
2. Add `providers.tf` to the tenant repo — the same four aliased AWS providers
   and autoglue provider the module configured internally (see the template
   below).
3. Rewrite `tenant.tf`:

   ```hcl
   module "tenant_base" {
     source = "git::https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites.git//modules/tenant-base?ref=vX.Y.Z"
     providers = {
       aws.clientaccount         = aws.clientaccount
       aws.management-tenant-dns = aws.management-tenant-dns
       aws.primaryregion         = aws.primaryregion
       aws.replicaregion         = aws.replicaregion
     }
     tenant_key                   = "<tenant_key>"
     tenant_account_id            = "<aws account id>"
     management_tenant_dns_zoneid = local.management_tenant_dns_hosted_zone_id
     this_is_development          = false
     primary_region               = "<region>"
     backup_region                = "<region>"
     environment_names            = ["nonprod", "prod"]
   }

   module "cluster_nonprod" {
     source = "git::https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites.git//modules/captain-cluster?ref=vX.Y.Z"
     providers = {
       aws.clientaccount = aws.clientaccount
       aws.primaryregion = aws.primaryregion
       aws.replicaregion = aws.replicaregion
     }
     tenant               = module.tenant_base.captain_cluster_inputs
     tenant_autoglue_iam  = module.tenant_base.autoglue_iam_credentials
     tenant_key           = "<tenant_key>"
     tenant_account_id    = "<aws account id>"
     this_is_development  = false
     primary_region       = "<region>"
     backup_region        = "<region>"
     github_owner         = local.github_owner
     autoglue_credentials = local.autoglue_credentials
     cluster_environments = [
       { environment_name = "nonprod", /* … carried over verbatim … */ }
     ]
   }

   # repeat module "cluster_prod" etc. — each block's ?ref= is that cluster's
   # independent version knob from now on
   ```

4. **Gate:** the PR's CI plan must show ONLY "has moved" lines and
   `Plan: 0 to add, 0 to change, 0 to destroy.` Anything else means a
   convention was violated (unlisted environment name, mislabeled cluster
   block, wrapper call not deleted) — fix before merging.
5. Merge (auto-applies). Confirm the captain repos received no new commits.
6. Follow-up PR: delete `moved-migration.tf`.

## providers.tf template

```hcl
terraform {
  required_providers {
    aws      = { source = "hashicorp/aws" }
    random   = { source = "hashicorp/random" }
    autoglue = { source = "registry.terraform.io/GlueOps/autoglue", version = "0.10.12" }
  }
}
provider "aws" {
  alias  = "clientaccount"
  region = "<primary_region>"
  assume_role { role_arn = "arn:aws:iam::<tenant_account_id>:role/OrganizationAccountAccessRole" }
}
provider "aws" {
  alias  = "management-tenant-dns"
  region = "<primary_region>"
  assume_role { role_arn = "arn:aws:iam::<management_tenant_dns_aws_account_id>:role/OrganizationAccountAccessRole" }
}
provider "aws" {
  alias  = "primaryregion"
  region = "<primary_region>"
  assume_role { role_arn = "arn:aws:iam::<tenant_account_id>:role/OrganizationAccountAccessRole" }
}
provider "aws" {
  alias  = "replicaregion"
  region = "<backup_region>"
  assume_role { role_arn = "arn:aws:iam::<tenant_account_id>:role/OrganizationAccountAccessRole" }
}
provider "autoglue" {
  base_url   = local.autoglue_credentials.base_url
  org_key    = local.autoglue_credentials.autoglue_key
  org_secret = local.autoglue_credentials.autoglue_org_secret
}
```

## Rolling back

- A bad release on one cluster: revert that cluster block's `?ref=` pin. No
  state movement.
- Abandoning the structure: `docs/generate-rollback-moved-blocks.sh`
  (`split` / `wrapper` modes).
