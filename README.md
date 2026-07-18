# terraform-module-cloud-multy-prerequisites

Provisions everything a GlueOps tenant needs before deploying the platform:
Route53 zones with DNSSEC, per-cluster IAM, backup S3 buckets, and each
cluster's captain repository with its generated configuration — with **each
cluster environment pinned to its own release of this module**.

## Modules

Tenant repos consume this repository as two modules:

- [`//modules/tenant-base`](modules/tenant-base/README.md) — shared per-tenant
  resources: parent Route53 zone + DNSSEC, shared backup S3 buckets, the
  autoglue Route53 identity. Instantiated once per tenant.
- [`//modules/captain-cluster`](modules/captain-cluster/README.md) —
  everything scoped to one cluster environment, **including every platform
  version pin** (`platform-versions.tf`). Instantiated once per cluster
  environment; the `?ref=` on each block is that cluster's independent
  version knob.

```hcl
module "tenant_base"     { source = "git::…//modules/tenant-base?ref=vX.Y.Z" … }
module "cluster_nonprod" { source = "git::…//modules/captain-cluster?ref=vX.Y.Z" … }
module "cluster_prod"    { source = "git::…//modules/captain-cluster?ref=vX.Y.Z" … }
```

Version rollouts are per cluster: renovate bumps each block's `?ref=`
independently — upgrade nonprod, observe, then upgrade prod.

## Migrating from the pre-split module

Tenants still calling this repository's (former) root module: follow
[docs/migration/MIGRATION.md](docs/migration/MIGRATION.md). One PR per
tenant, moved blocks generated from your own tenant.tf, gated on a
moves-only `0 to add, 0 to change, 0 to destroy` plan. Pre-split releases
remain available as git tags.

## Prerequisites

1. Tenant AWS account (generally created via Terraform alongside this module).
2. [GitHub OAuth App](https://github.com/GlueOps/docs-github-apps/blob/main/github_oauth_app.md)
3. [GitHub App](https://github.com/GlueOps/docs-github-apps/blob/main/github_app.md)
