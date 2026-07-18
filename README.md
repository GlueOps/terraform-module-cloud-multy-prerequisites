<!-- BEGIN_TF_DOCS -->
# terraform-module-cloud-multy-prerequisites

This Terraform module creates various resources for managing multi-cloud prerequisites, such as Route53 zones, IAM credentials, and S3 buckets.
The module also deploys a `tenant` repository with the necessary configuration files and instructions for deploying the GlueOps Platform on Kubernetes.

## Module layout: tenant-base + captain-cluster

Tenant repos consume this repository as two modules so each cluster
environment pins its own release:

- `//modules/tenant-base` — shared per-tenant resources: parent Route53 zone +
  DNSSEC, shared backup S3 buckets, the autoglue Route53 identity.
- `//modules/captain-cluster` — everything scoped to one cluster environment,
  **including every platform version pin** (see
  `modules/captain-cluster/platform-versions.tf`). Instantiate it once per
  cluster; the `?ref=` on each block is that cluster's version knob.

The root of this repository is a backwards-compatible wrapper: tenants that
still consume the root (e.g. `?ref=main`) get identical behavior to the
pre-split module, with state migrated in place via `moved.tf`. To migrate a
tenant to per-cluster calls, follow [docs/migration/MIGRATION.md](docs/migration/MIGRATION.md).

## Prerequisite Prerequisites

Some dependencies for this module must be creates prior to its use, including:

1. Tenant Account, generally created via Terraform in the same reposity where this module is deployed, at `/organization/tf/main.tf`.
2. [GitHub OAuth APP](https://github.com/GlueOps/docs-github-apps/blob/main/github_oauth_app.md)
3. [GitHub App](https://github.com/GlueOps/docs-github-apps/blob/main/github_app.md)

## Overview of what this module produces

1. **Parent Route53 Zone per Tenant**: Creates a parent Route53 zone for each tenant.
2. **Route53 Zones per Cluster**: Creates a Route53 zone for each cluster.
    - **IAM Credentials for Cert-Manager**: Generates IAM credentials that allow cert-manager to access a specific cluster's Route53 zone.
    - **IAM Credentials for External-DNS**: Generates IAM credentials that allow external-dns to access a specific cluster's Route53 zone.
3. **S3 Bucket for Backups**: Creates a single S3 bucket for storing backups.
    - **IAM Credentials for Vault Backups**: Generates IAM credentials that allow Vault to back up data to the S3 backup bucket.
4. **S3 Buckets for Loki Log Retention**: Creates one or more S3 buckets dedicated to Loki for log retention.
    - **IAM Credentials per Bucket for Loki**: Generates IAM credentials for each Loki S3 bucket.
5. **OpsGenie API Key**: Creates an OpsGenie API key.
    - **API Key per Cluster**: Generates an API key for each cluster.
6. **Tenant GitHub Repository**: Creates tenant repository for managing a GlueOps Platform Kubernetes Cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_autoglue"></a> [autoglue](#requirement\_autoglue) | 0.10.12 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_captain_cluster"></a> [captain\_cluster](#module\_captain\_cluster) | ./modules/captain-cluster | n/a |
| <a name="module_tenant_base"></a> [tenant\_base](#module\_tenant\_base) | ./modules/tenant-base | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoglue_credentials"></a> [autoglue\_credentials](#input\_autoglue\_credentials) | The autoglue credentials object | <pre>object({<br/>    autoglue_key        = string<br/>    autoglue_org_secret = string<br/>    base_url            = string<br/>  })</pre> | n/a | yes |
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | The secondary S3 region to create S3 bucket in used for backups. This should be different than the primary region and will have the data from the primary region replicated to it. | `string` | n/a | yes |
| <a name="input_cluster_environments"></a> [cluster\_environments](#input\_cluster\_environments) | The cluster environments and their respective github app ids | <pre>list(object({<br/>    environment_name                        = string<br/>    host_network_enabled                    = bool<br/>    traefik_enable_internal_lb              = optional(bool, false)<br/>    traefik_enable_public_lb                = optional(bool, true)<br/>    nginx_enable_public_lb                  = optional(bool, true)<br/>    prometheus_volume_claim_storage_request = optional(string, "50")<br/>    vault_data_storage                      = optional(string, "10")<br/>    nginx_controller_replica_count          = optional(string, "2")<br/>    traefik_internal_lb_deployment_replicas = optional(string, "2")<br/>    traefik_public_lb_deployment_replicas   = optional(string, "2")<br/>    github_oauth_app_client_id              = string<br/>    github_oauth_app_client_secret          = string<br/>    github_tenant_app_id                    = string<br/>    github_tenant_app_installation_id       = string<br/>    github_tenant_app_b64enc_private_key    = string<br/>    admin_github_org_name                   = string<br/>    tenant_github_org_name                  = string<br/>    kubeadm_cluster                         = optional(bool, false)<br/>    vault_github_org_team_policy_mappings = list(object({<br/>      oidc_groups = list(string)<br/>      policy_name = string<br/>    }))<br/>    argocd_rbac_policies = string<br/>    provider_credentials = optional(map(any), null)<br/>    waggle_credentials = optional(object({<br/>      waggle_endpoint      = string<br/>      waggle_api_key       = string<br/>      waggle_datacenter_id = string<br/>    }), null)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "admin_github_org_name": "GlueOps",<br/>    "argocd_rbac_policies": "      g, GlueOps:argocd_super_admins, role:admin\n      g, glueops-rocks:developers, role:developers\n      p, role:developers, clusters, get, *, allow\n      p, role:developers, *, get, development, allow\n      p, role:developers, repositories, *, development/*, allow\n      p, role:developers, applications, *, development/*, allow\n      p, role:developers, exec, *, development/*, allow\n",<br/>    "autoglue": null,<br/>    "environment_name": "test",<br/>    "github_oauth_app_client_id": "oauth-app-id",<br/>    "github_oauth_app_client_secret": "oauth-app-secret",<br/>    "github_tenant_app_b64enc_private_key": "tenant-github-app-b64enc-private-key",<br/>    "github_tenant_app_id": "tenant-github-app-id",<br/>    "github_tenant_app_installation_id": "tenant-github-app-installation-id",<br/>    "host_network_enabled": true,<br/>    "kubeadm_cluster": false,<br/>    "nginx_controller_replica_count": "2",<br/>    "nginx_enable_public_lb": true,<br/>    "prometheus_volume_claim_storage_request": "50",<br/>    "provider_credentials": null,<br/>    "tenant_github_org_name": "glueops-rocks",<br/>    "traefik_enable_internal_lb": false,<br/>    "traefik_enable_public_lb": true,<br/>    "traefik_internal_lb_deployment_replicas": "2",<br/>    "traefik_public_lb_deployment_replicas": "2",<br/>    "vault_data_storage": "10",<br/>    "vault_github_org_team_policy_mappings": [<br/>      {<br/>        "oidc_groups": [<br/>          "GlueOps:vault_super_admins"<br/>        ],<br/>        "policy_name": "editor"<br/>      },<br/>      {<br/>        "oidc_groups": [<br/>          "GlueOps:vault_super_admins",<br/>          "testing-okta:updaters"<br/>        ],<br/>        "policy_name": "updater"<br/>      },<br/>      {<br/>        "oidc_groups": [<br/>          "GlueOps:vault_super_admins",<br/>          "testing-okta:developers"<br/>        ],<br/>        "policy_name": "updater"<br/>      },<br/>      {<br/>        "oidc_groups": [<br/>          "GlueOps:vault_super_admins",<br/>          "testing-okta:developers"<br/>        ],<br/>        "policy_name": "reader"<br/>      }<br/>    ],<br/>    "waggle_credentials": null<br/>  }<br/>]</pre> | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | The GitHub Owner where the tenant repo will be deployed. | `string` | n/a | yes |
| <a name="input_management_tenant_dns_aws_account_id"></a> [management\_tenant\_dns\_aws\_account\_id](#input\_management\_tenant\_dns\_aws\_account\_id) | The company AWS account id for the management-tenant-dns account | `string` | n/a | yes |
| <a name="input_management_tenant_dns_zoneid"></a> [management\_tenant\_dns\_zoneid](#input\_management\_tenant\_dns\_zoneid) | The Route53 ZoneID that all the delegation is coming from. | `string` | n/a | yes |
| <a name="input_opsgenie_emails"></a> [opsgenie\_emails](#input\_opsgenie\_emails) | List of user email addresses | `list(string)` | `[]` | no |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The primary S3 region to create S3 bucket in used for backups. This should be the same region as the one where the cluster is being deployed. | `string` | n/a | yes |
| <a name="input_tenant_account_id"></a> [tenant\_account\_id](#input\_tenant\_account\_id) | The tenant AWS account id | `string` | n/a | yes |
| <a name="input_tenant_key"></a> [tenant\_key](#input\_tenant\_key) | The tenant key | `string` | n/a | yes |
| <a name="input_this_is_development"></a> [this\_is\_development](#input\_this\_is\_development) | The development cluster environment and data/resources can be destroyed! | `string` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
