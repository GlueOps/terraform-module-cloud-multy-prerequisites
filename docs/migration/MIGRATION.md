# Migrating a tenant to per-cluster module calls

One PR per tenant, **no scripts, no state access**. Works whether or not the
tenant has already picked up the backwards-compatible wrapper (the moved
blocks are chained and no-op wherever they don't apply).

## Conventions (required)

1. One `module "cluster_<environment_name>"` block per environment — the label
   must be exactly `cluster_` + the environment name.
2. Each cluster block passes `cluster_environments = [ <that one environment
   object> ]` (the same object it had inside the old wrapper call, verbatim).
3. The old wrapper call `module "tenant"` is deleted entirely in the same PR.

## Steps

1. Get the moved blocks, either way:

   **Any environment names** — after rewriting `tenant.tf` (step 3), generate
   from it; environment names are derived from your `cluster_<env>` labels:

   ```bash
   git clone --depth 1 --branch vX.Y.Z \
     https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites /tmp/multy
   bash /tmp/multy/docs/generate-moved-blocks.sh > moved-migration.tf   # run in the tenant repo
   ```

   **Conventional names only, zero commands** — copy
   `docs/migration/moved-migration.tf` (from the module ref you are pinning)
   into the tenant repo root, verbatim. It covers: `nonprod`, `prod`, `dev`,
   `test`, `qa`, `staging`, `uat`, `sandbox`, `another-nonprod-env`. Other names need the generated
   variant above (or a PR extending the list per the file's header).
2. Add `providers.tf` to the tenant repo — the same four aliased AWS providers
   and autoglue provider the module configured internally (see the template
   below).
3. Rewrite `tenant.tf`:

   ```hcl
   # All tenant-scoped values are stated ONCE, here. Cluster blocks only carry
   # providers, the two bundles, and their own environment.
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
     github_owner                 = local.github_owner
     autoglue_credentials         = local.autoglue_credentials
     environment_names            = ["nonprod", "prod"]
   }

   module "cluster_nonprod" {
     source = "git::https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites.git//modules/captain-cluster?ref=vX.Y.Z"
     providers = {
       aws.clientaccount = aws.clientaccount
       aws.primaryregion = aws.primaryregion
       aws.replicaregion = aws.replicaregion
     }
     tenant         = module.tenant_base.captain_cluster_inputs
     tenant_secrets = module.tenant_base.captain_cluster_secrets
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
    github   = { source = "integrations/github" }
  }
}
# token comes from the GITHUB_TOKEN env var in CI; set it here to go fully inline
provider "github" {
  owner = local.github_owner
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
