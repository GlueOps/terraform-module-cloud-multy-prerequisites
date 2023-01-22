# terraform-module-cloud-aws-multiple-route53-zones
<!-- BEGIN_TF_DOCS -->
# terraform-module-cloud-aws-multiple-route53-zones

This terraform module creates a "parent" zone and multiple subdomain zones underneath the parent zone.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.39.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 3.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.clientaccount"></a> [aws.clientaccount](#provider\_aws.clientaccount) | 4.39.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 3.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.certmanager](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.externaldns](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.route53](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_policy) | resource |
| [aws_iam_user.certmanager](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_user) | resource |
| [aws_iam_user.externaldns](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.certmanager](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.externaldns](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_route53_record.cluster_subdomain_ns_records](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.clusters](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route53_zone) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/4.39.0/docs/resources/route53_zone) | resource |
| [cloudflare_record.delegation_ns_record_first](https://registry.terraform.io/providers/cloudflare/cloudflare/3.32.0/docs/resources/record) | resource |
| [cloudflare_record.delegation_ns_record_fourth](https://registry.terraform.io/providers/cloudflare/cloudflare/3.32.0/docs/resources/record) | resource |
| [cloudflare_record.delegation_ns_record_second](https://registry.terraform.io/providers/cloudflare/cloudflare/3.32.0/docs/resources/record) | resource |
| [cloudflare_record.delegation_ns_record_third](https://registry.terraform.io/providers/cloudflare/cloudflare/3.32.0/docs/resources/record) | resource |
| [cloudflare_zone.delegator](https://registry.terraform.io/providers/cloudflare/cloudflare/3.32.0/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_environments"></a> [cluster\_environments](#input\_cluster\_environments) | The cluster environments | `list(string)` | n/a | yes |
| <a name="input_company_account_id"></a> [company\_account\_id](#input\_company\_account\_id) | The company AWS account id | `string` | n/a | yes |
| <a name="input_company_key"></a> [company\_key](#input\_company\_key) | The company key | `string` | n/a | yes |
| <a name="input_domain_to_delegate_from"></a> [domain\_to\_delegate\_from](#input\_domain\_to\_delegate\_from) | The domain name of the domain that all delegation is coming from | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certmanager_iam_credentials"></a> [certmanager\_iam\_credentials](#output\_certmanager\_iam\_credentials) | n/a |
| <a name="output_externaldns_iam_credentials"></a> [externaldns\_iam\_credentials](#output\_externaldns\_iam\_credentials) | n/a |
<!-- END_TF_DOCS -->