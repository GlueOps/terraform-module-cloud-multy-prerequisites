<!-- BEGIN_TF_DOCS -->
# tenant-base

Shared per-tenant resources: the parent Route53 zone with DNSSEC, the shared
backup S3 buckets, and the tenant's autoglue Route53 identity. Instantiate
once per tenant; its `captain_cluster_inputs` / `captain_cluster_secrets`
outputs feed every `captain-cluster` instantiation. See
[docs/migration/MIGRATION.md](../../docs/migration/MIGRATION.md).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_autoglue"></a> [autoglue](#requirement\_autoglue) | 0.10.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_autoglue"></a> [autoglue](#provider\_autoglue) | 0.10.12 |
| <a name="provider_aws.clientaccount"></a> [aws.clientaccount](#provider\_aws.clientaccount) | n/a |
| <a name="provider_aws.management-tenant-dns"></a> [aws.management-tenant-dns](#provider\_aws.management-tenant-dns) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_common_s3"></a> [common\_s3](#module\_common\_s3) | ../multy-s3-bucket/0.1.0 | n/a |
| <a name="module_common_s3_v2"></a> [common\_s3\_v2](#module\_common\_s3\_v2) | ../multy-s3-bucket/0.2.0 | n/a |
| <a name="module_dnssec_key"></a> [dnssec\_key](#module\_dnssec\_key) | git::https://github.com/GlueOps/terraform-module-cloud-aws-dnssec-kms-key.git | v0.4.0 |

## Resources

| Name | Type |
|------|------|
| autoglue_credential.route53 | resource |
| [aws_iam_access_key.autoglue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.route53_autoglue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.autoglue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.autoglue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_route53_hosted_zone_dnssec.parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_hosted_zone_dnssec) | resource |
| [aws_route53_key_signing_key.parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_key_signing_key) | resource |
| [aws_route53_record.delegation_to_parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.enable_dnssec_for_parent_tenant_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [random_uuid.autoglue_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.route53_autoglue_aws_iam_policy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_route53_zone.management_tenant_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoglue_credentials"></a> [autoglue\_credentials](#input\_autoglue\_credentials) | The autoglue credentials object | <pre>object({<br/>    autoglue_key        = string<br/>    autoglue_org_secret = string<br/>    base_url            = string<br/>  })</pre> | n/a | yes |
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | The secondary S3 region to create S3 bucket in used for backups. This should be different than the primary region and will have the data from the primary region replicated to it. | `string` | n/a | yes |
| <a name="input_environment_names"></a> [environment\_names](#input\_environment\_names) | The environment names of every cluster environment in this tenant. Used to derive the cluster zone names for the shared backup bucket lifecycle rules. | `list(string)` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | The GitHub Owner where the tenant repo will be deployed. | `string` | n/a | yes |
| <a name="input_management_tenant_dns_zoneid"></a> [management\_tenant\_dns\_zoneid](#input\_management\_tenant\_dns\_zoneid) | The Route53 ZoneID that all the delegation is coming from. | `string` | n/a | yes |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | The primary S3 region to create S3 bucket in used for backups. This should be the same region as the one where the cluster is being deployed. | `string` | n/a | yes |
| <a name="input_tenant_account_id"></a> [tenant\_account\_id](#input\_tenant\_account\_id) | The tenant AWS account id | `string` | n/a | yes |
| <a name="input_tenant_key"></a> [tenant\_key](#input\_tenant\_key) | The tenant key | `string` | n/a | yes |
| <a name="input_this_is_development"></a> [this\_is\_development](#input\_this\_is\_development) | The development cluster environment and data/resources can be destroyed! | `string` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_captain_cluster_inputs"></a> [captain\_cluster\_inputs](#output\_captain\_cluster\_inputs) | Non-secret shared tenant values consumed by each captain-cluster module instantiation. |
| <a name="output_captain_cluster_secrets"></a> [captain\_cluster\_secrets](#output\_captain\_cluster\_secrets) | Shared tenant secrets consumed by each captain-cluster module instantiation. Kept separate from captain\_cluster\_inputs so the non-secret bundle stays readable in plans. |
<!-- END_TF_DOCS -->
