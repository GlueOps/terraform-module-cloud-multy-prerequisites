<!-- BEGIN_TF_DOCS -->
# terraform-module-cloud-multy-prerequisites

This Terraform module creates various resources for managing multi-cloud prerequisites, such as Route53 zones, IAM credentials, and S3 buckets.
The module also deploys a `tenant` repository with the necessary configuration files and instructions for deploying the GlueOps Platform on Kubernetes.

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

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.clientaccount"></a> [aws.clientaccount](#provider\_aws.clientaccount) | n/a |
| <a name="provider_aws.management-tenant-dns"></a> [aws.management-tenant-dns](#provider\_aws.management-tenant-dns) | n/a |
| <a name="provider_aws.primaryregion"></a> [aws.primaryregion](#provider\_aws.primaryregion) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_argocd_helm_values"></a> [argocd\_helm\_values](#module\_argocd\_helm\_values) | git::https://github.com/GlueOps/docs-argocd.git | v0.15.0 |
| <a name="module_captain_repository"></a> [captain\_repository](#module\_captain\_repository) | ./modules/github-captain-repository/0.1.0 | n/a |
| <a name="module_captain_repository_files"></a> [captain\_repository\_files](#module\_captain\_repository\_files) | ./modules/github-captain-repository-files/0.1.0 | n/a |
| <a name="module_common_s3"></a> [common\_s3](#module\_common\_s3) | ./modules/multy-s3-bucket/0.1.0 | n/a |
| <a name="module_dnssec_key"></a> [dnssec\_key](#module\_dnssec\_key) | git::https://github.com/GlueOps/terraform-module-cloud-aws-dnssec-kms-key.git | v0.3.0 |
| <a name="module_glueops_platform_helm_values"></a> [glueops\_platform\_helm\_values](#module\_glueops\_platform\_helm\_values) | git::https://github.com/GlueOps/platform-helm-chart-platform.git | 0.54.1 |
| <a name="module_loki_s3"></a> [loki\_s3](#module\_loki\_s3) | ./modules/multy-s3-bucket/0.1.0 | n/a |
| <a name="module_opsgenie_teams"></a> [opsgenie\_teams](#module\_opsgenie\_teams) | ./modules/opsgenie/0.1.0 | n/a |
| <a name="module_tenant_readmes"></a> [tenant\_readmes](#module\_tenant\_readmes) | ./modules/tenant-readme/0.1.0 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.certmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.externaldns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.tls_cert_backup_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.tls_cert_restore_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.vault_init_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.vault_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.route53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tls_cert_backup_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tls_cert_restore_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vault_init_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vault_s3_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.certmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.externaldns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.tls_cert_backup_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.tls_cert_restore_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.vault_init_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.vault_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.certmanager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.externaldns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.tls_cert_backup_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.tls_cert_restore_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.vault_init_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.vault_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_route53_hosted_zone_dnssec.cluster_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_hosted_zone_dnssec) | resource |
| [aws_route53_hosted_zone_dnssec.parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_hosted_zone_dnssec) | resource |
| [aws_route53_key_signing_key.cluster_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_key_signing_key) | resource |
| [aws_route53_key_signing_key.parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_key_signing_key) | resource |
| [aws_route53_record.cluster_zone_dnssec_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.cluster_zone_ns_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.delegation_to_parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.enable_dnssec_for_parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.wildcard_for_apps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.clusters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_s3_object.argocd_helm_values](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.combined_outputs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.platform_helm_values](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_password.dex_argocd_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.dex_grafana_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.dex_pomerium_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.dex_vault_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_route53_zone.management_tenant_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | The secondary S3 region to create S3 bucket in used for backups. This should be different than the primary region and will have the data from the primary region replicated to it. | `string` | n/a | yes |
| <a name="input_cluster_environments"></a> [cluster\_environments](#input\_cluster\_environments) | The cluster environments and their respective github app ids | <pre>list(object({<br/>    environment_name                     = string<br/>    host_network_enabled                 = bool<br/>    github_oauth_app_client_id           = string<br/>    github_oauth_app_client_secret       = string<br/>    github_tenant_app_id                 = string<br/>    github_tenant_app_installation_id    = string<br/>    github_tenant_app_b64enc_private_key = string<br/>    admin_github_org_name                = string<br/>    tenant_github_org_name               = string<br/>    vault_github_org_team_policy_mappings = list(object({<br/>      oidc_groups = list(string)<br/>      policy_name = string<br/>    }))<br/>    argocd_rbac_policies = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "admin_github_org_name": "GlueOps",<br/>    "argocd_rbac_policies": "      g, GlueOps:argocd_super_admins, role:admin\n      g, glueops-rocks:developers, role:developers\n      p, role:developers, clusters, get, *, allow\n      p, role:developers, *, get, development, allow\n      p, role:developers, repositories, *, development/*, allow\n      p, role:developers, applications, *, development/*, allow\n      p, role:developers, exec, *, development/*, allow\n",<br/>    "environment_name": "test",<br/>    "github_oauth_app_client_id": "oauth-app-id",<br/>    "github_oauth_app_client_secret": "oauth-app-secret",<br/>    "github_tenant_app_b64enc_private_key": "tenant-github-app-b64enc-private-key",<br/>    "github_tenant_app_id": "tenant-github-app-id",<br/>    "github_tenant_app_installation_id": "tenant-github-app-installation-id",<br/>    "host_network_enabled": true,<br/>    "tenant_github_org_name": "glueops-rocks",<br/>    "vault_github_org_team_policy_mappings": [<br/>      {<br/>        "oidc_groups": [<br/>          "GlueOps:vault_super_admins"<br/>        ],<br/>        "policy_name": "editor"<br/>      },<br/>      {<br/>        "oidc_groups": [<br/>          "GlueOps:vault_super_admins",<br/>          "testing-okta:developers"<br/>        ],<br/>        "policy_name": "reader"<br/>      }<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | The GitHub Owner where the tenant repo will be deployed. | `string` | n/a | yes |
| <a name="input_management_tenant_dns_aws_account_id"></a> [management\_tenant\_dns\_aws\_account\_id](#input\_management\_tenant\_dns\_aws\_account\_id) | The company AWS account id for the management-tenant-dns account | `string` | n/a | yes |
| <a name="input_management_tenant_dns_zoneid"></a> [management\_tenant\_dns\_zoneid](#input\_management\_tenant\_dns\_zoneid) | The Route53 ZoneID that all the delegation is coming from. | `string` | n/a | yes |
| <a name="input_opsgenie_emails"></a> [opsgenie\_emails](#input\_opsgenie\_emails) | List of user email addresses | `list(string)` | n/a | yes |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The primary S3 region to create S3 bucket in used for backups. This should be the same region as the one where the cluster is being deployed. | `string` | n/a | yes |
| <a name="input_tenant_account_id"></a> [tenant\_account\_id](#input\_tenant\_account\_id) | The tenant AWS account id | `string` | n/a | yes |
| <a name="input_tenant_key"></a> [tenant\_key](#input\_tenant\_key) | The tenant key | `string` | n/a | yes |
| <a name="input_this_is_development"></a> [this\_is\_development](#input\_this\_is\_development) | The development cluster environment and data/resources can be destroyed! | `string` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
