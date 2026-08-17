# Migrating a tenant to per-cluster module calls

One PR per tenant, **no state access**: the generated moved blocks are
chained and no-op wherever they don't apply, so the same moved blocks
resolve clean regardless of which module version the tenant last applied.
That version-independence covers state **addresses** only — generated-file
*content* is version-dependent, which is why the prerequisite below exists.

## Prerequisite: be on the latest pre-split release first

The gate demands a moves-only plan. The migration PR can only produce one
if the tenant's last **applied** release is the latest pre-split tag
(**v0.87.0** at time of writing). A tenant behind that will see in-place
updates on generated captain-repo files (version-pin drift absorbed into
the migration plan) — a correctly formed migration, blocked at the gate.

If the tenant is behind: first bump the OLD `module "tenant"` call's
`?ref=` to the latest pre-split tag, merge/apply that as a normal release
PR, then start the migration.

## Conventions (required)

1. One `module "cluster_<environment_name>"` block per environment — the label
   must be exactly `cluster_` + the environment name.
2. Each cluster block passes `cluster_environments = [ <that one environment
   object> ]` (the same object it had inside the old module "tenant" call, verbatim).
3. The old `module "tenant"` call is deleted entirely in the same PR.

## Tenants with no clusters

A tenant whose legacy call passed `cluster_environments = []` migrates to a
`tenant_base` block alone: no `cluster_<env>` blocks, `environment_names = []`,
and moved blocks covering only the shared resources. Both generators handle
this and say so on stderr.

Read that message: if a tenant that *does* have clusters ever reports "no
clusters", stop — the converter failed to understand its
`cluster_environments` layout, and committing the result would plan as a
destroy of every cluster resource. (The converter refuses outright on every
unparseable layout it knows of; this is the backstop for one it does not.)

## Steps

**One-command path:** clone the tenant repo, create a fresh branch, then with
this repo checked out at the ref to pin:

```bash
git clone --depth 1 --branch vX.Y.Z \
  https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites /tmp/multy
bash /tmp/multy/docs/generate-migration.sh vX.Y.Z   # no arg: prompts for the ref, defaults to main
```

This rewrites `tenant.tf` (tenant facts once on `tenant_base`, one
`cluster_<env>` block per environment carried over verbatim), writes
`providers.tf`, writes `moved-migration.tf`, and prunes locals the migration
leaves unreferenced (e.g. `opsgenie_emails`). It fails loudly on anything it
does not recognize. Review the diff, then go to the gate (step 4).

The manual steps below are equivalent:

1. Generate the moved blocks — after rewriting `tenant.tf` (step 3), from a
   checkout of this repo at the ref the new module blocks pin. Environment
   names are derived from your `cluster_<env>` labels; any names work:

   ```bash
   git clone --depth 1 --branch vX.Y.Z \
     https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites /tmp/multy
   bash /tmp/multy/docs/generate-moved-blocks.sh > moved-migration.tf   # run in the tenant repo
   ```

   The output is chained: the same file's moves resolve clean regardless of
   which module version this tenant last applied (addresses are
   version-independent; generated-file content is not — see Prerequisite).

   If the legacy call is not named `module "tenant"`, run the script with
   `OLD_MODULE_LABEL=<that label>` — otherwise every generated `from` address
   no-ops and the plan shows a full destroy/create instead of moves.
   (`generate-migration.sh` detects the label automatically.)
2. Add `providers.tf` to the tenant repo — the five aliased AWS providers,
   autoglue, and github providers per the template below (everything the
   module stack previously configured internally or read from CI env).
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
       aws.dnssec-us-east-1      = aws.dnssec-us-east-1
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

4. Commit everything and open the PR.
5. **Gate:** the PR's CI plan must show ONLY "has moved" lines plus exactly
   `Plan: 0 to add, 0 to change, 0 to destroy.` — note this is NOT a literal
   "No changes" plan; the moved lines ARE the migration. Anything else
   (creates, destroys, changes, provider errors) means something is wrong
   (mislabeled cluster block, stale moved file, old module "tenant" call not
   deleted) — fix before merging. In-place **changes on generated
   captain-repo files** specifically mean the tenant's last apply predates
   the latest pre-split release: close this PR's plan cycle, apply that
   release with the OLD tenant.tf first (see Prerequisite), then re-plan.
   An in-place **change on the DNSSEC KMS key policy** means the
   `dnssec-us-east-1` provider is not assuming `OrganizationAccountAccessRole`
   in the tenant account (the pre-split module hardcoded that role) — fix the
   provider block per the template below; do not apply the diff.
   A **"Resource precondition failed" error naming an environment** means that
   cluster block's `environment_name` is not in `environment_names` on the
   tenant_base block — the error text names the remedy for each case (real
   cluster: add it to the list; typo: fix the name, don't add the typo;
   decommission: delete the cluster's module block before shrinking the list).
6. Merge (auto-applies the state moves). **Post-apply check:** the tenant's
   captain repos received zero new commits (generated files byte-identical).
7. **Follow-up PR:** delete `moved-migration.tf`. Its plan is the true no-op
   (`No changes.`) — merge it and the tenant carries no migration residue.

## providers.tf template

```hcl
terraform {
  required_providers {
    aws      = { source = "hashicorp/aws" }
    random   = { source = "hashicorp/random" }
    # no version constraint on autoglue on purpose: tenant-base pins the exact
    # version, and a duplicate exact pin here would force a fleet-wide lockstep
    # providers.tf edit on every future autoglue bump
    autoglue = { source = "registry.terraform.io/GlueOps/autoglue" }
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
provider "aws" {
  alias  = "dnssec-us-east-1"
  region = "us-east-1" # Route53 DNSSEC requires its KMS key in us-east-1
  assume_role { role_arn = "arn:aws:iam::<tenant_account_id>:role/OrganizationAccountAccessRole" }
}
provider "autoglue" {
  base_url   = local.autoglue_credentials.base_url
  org_key    = local.autoglue_credentials.autoglue_key
  org_secret = local.autoglue_credentials.autoglue_org_secret
}
```

## Rolling back a release

A bad release on one cluster: revert that cluster block's `?ref=` pin. No
state movement. (The migration itself is forward-only.)
