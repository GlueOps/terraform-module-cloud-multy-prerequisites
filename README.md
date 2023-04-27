# terraform-module-cloud-aws-multiple-route53-zones
<!-- BEGIN_TF_DOCS -->

This Terraform module creates various resources for managing multi-cloud prerequisites, such as Route53 zones, IAM credentials, and S3 buckets.

## Overview of what this module produces:

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.64.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 4.4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.clientaccount"></a> [aws.clientaccount](#provider\_aws.clientaccount) | 4.64.0 |
| <a name="provider_aws.management-tenant-dns"></a> [aws.management-tenant-dns](#provider\_aws.management-tenant-dns) | 4.64.0 |
| <a name="provider_aws.primaryregion"></a> [aws.primaryregion](#provider\_aws.primaryregion) | 4.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_s3"></a> [common\_s3](#module\_common\_s3) | ./modules/multy-s3-bucket/0.1.0 | n/a |
| <a name="module_dnssec_key"></a> [dnssec\_key](#module\_dnssec\_key) | git::https://github.com/GlueOps/terraform-module-cloud-aws-dnssec-kms-key.git | v0.1.0 |
| <a name="module_loki_s3"></a> [loki\_s3](#module\_loki\_s3) | ./modules/multy-s3-bucket/0.1.0 | n/a |
| <a name="module_opsgenie_teams"></a> [opsgenie\_teams](#module\_opsgenie\_teams) | ./modules/opsgenie/0.1.0 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.certmanager](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.externaldns](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.loki_log_exporter_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.vault_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.loki_logs_exporter_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.route53](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vault_s3_backup](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_policy) | resource |
| [aws_iam_user.certmanager](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user) | resource |
| [aws_iam_user.externaldns](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user) | resource |
| [aws_iam_user.loki_log_exporter_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user) | resource |
| [aws_iam_user.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user) | resource |
| [aws_iam_user.vault_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.certmanager](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.externaldns](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.loki_log_exporter_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.loki_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.vault_s3](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_route53_hosted_zone_dnssec.cluster_zones](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_hosted_zone_dnssec) | resource |
| [aws_route53_hosted_zone_dnssec.parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_hosted_zone_dnssec) | resource |
| [aws_route53_key_signing_key.cluster_zones](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_key_signing_key) | resource |
| [aws_route53_key_signing_key.parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_key_signing_key) | resource |
| [aws_route53_record.cluster_zone_dnssec_records](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_record) | resource |
| [aws_route53_record.cluster_zone_ns_records](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_record) | resource |
| [aws_route53_record.delegation_to_parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_record) | resource |
| [aws_route53_record.enable_dnssec_for_parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_record) | resource |
| [aws_route53_record.wildcard_for_apps](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.clusters](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/route53_zone) | resource |
| [aws_s3_object.combined_outputs](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/resources/s3_object) | resource |
| [aws_route53_zone.management_tenant_dns](https://registry.terraform.io/providers/hashicorp/aws/4.64.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | The secondary S3 region to create S3 bucket in used for backups. This should be different than the primary region and will have the data from the primary region replicated to it. | `string` | n/a | yes |
| <a name="input_cluster_environments"></a> [cluster\_environments](#input\_cluster\_environments) | The cluster environments | `list(string)` | n/a | yes |
| <a name="input_company_account_id"></a> [company\_account\_id](#input\_company\_account\_id) | The company AWS account id | `string` | n/a | yes |
| <a name="input_company_key"></a> [company\_key](#input\_company\_key) | The company key | `string` | n/a | yes |
| <a name="input_loki_log_export_retention_in_days"></a> [loki\_log\_export\_retention\_in\_days](#input\_loki\_log\_export\_retention\_in\_days) | The number of days to keep the log exports in the S3 bucket | `number` | `90` | no |
| <a name="input_management_tenant_dns_aws_account_id"></a> [management\_tenant\_dns\_aws\_account\_id](#input\_management\_tenant\_dns\_aws\_account\_id) | The company AWS account id for the management-tenant-dns account | `string` | n/a | yes |
| <a name="input_management_tenant_dns_zoneid"></a> [management\_tenant\_dns\_zoneid](#input\_management\_tenant\_dns\_zoneid) | The Route53 ZoneID that all the delegation is coming from | `string` | n/a | yes |
| <a name="input_opsgenie_emails"></a> [opsgenie\_emails](#input\_opsgenie\_emails) | List of user email addresses | `list(string)` | n/a | yes |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The primary S3 region to create S3 bucket in used for backups. This should be the same region as the one where the cluster is being deployed. | `string` | n/a | yes |
| <a name="input_this_is_development"></a> [this\_is\_development](#input\_this\_is\_development) | The development cluster environment and data/resources can be destroyed! | `string` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->