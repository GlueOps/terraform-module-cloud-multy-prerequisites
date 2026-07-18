<!-- BEGIN_TF_DOCS -->
# captain-cluster

Everything scoped to one cluster environment: the cluster Route53 zone with
DNSSEC, per-cluster IAM, the captain repository and its generated files, and
**every platform version pin** (`platform-versions.tf`). Instantiate once per
cluster environment; the `?ref=` on each block is that cluster's independent
version knob. See [docs/migration/MIGRATION.md](../../docs/migration/MIGRATION.md).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.clientaccount"></a> [aws.clientaccount](#provider\_aws.clientaccount) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_argocd_helm_values"></a> [argocd\_helm\_values](#module\_argocd\_helm\_values) | git::https://github.com/GlueOps/docs-argocd.git | v0.19.1 |
| <a name="module_captain_repository"></a> [captain\_repository](#module\_captain\_repository) | ../github-captain-repository/0.1.0 | n/a |
| <a name="module_captain_repository_files"></a> [captain\_repository\_files](#module\_captain\_repository\_files) | ../github-captain-repository-files/0.1.0 | n/a |
| <a name="module_generate_gluekube_creds"></a> [generate\_gluekube\_creds](#module\_generate\_gluekube\_creds) | ../gluekube/0.1.0 | n/a |
| <a name="module_glueops_platform_helm_values"></a> [glueops\_platform\_helm\_values](#module\_glueops\_platform\_helm\_values) | git::https://github.com/GlueOps/platform-helm-chart-platform.git | v0.75.2 |
| <a name="module_glueops_platform_versions"></a> [glueops\_platform\_versions](#module\_glueops\_platform\_versions) | ../platform-chart-version/0.1.0 | n/a |
| <a name="module_loki_s3"></a> [loki\_s3](#module\_loki\_s3) | ../multy-s3-bucket/0.1.0 | n/a |
| <a name="module_tenant_cluster_versions"></a> [tenant\_cluster\_versions](#module\_tenant\_cluster\_versions) | ../kubernetes-versions/0.1.0 | n/a |
| <a name="module_tenant_readmes"></a> [tenant\_readmes](#module\_tenant\_readmes) | ../tenant-readme/0.1.0 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.certmanager_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.externaldns_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.loki_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.tls_cert_backup_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.tls_cert_restore_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.vault_init_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.vault_s3_backup_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.loki_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.route53_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tls_cert_backup_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tls_cert_restore_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vault_init_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.vault_s3_backup_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.certmanager_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.externaldns_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.loki_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.tls_cert_backup_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.tls_cert_restore_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.vault_init_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.vault_s3_backup_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.certmanager_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.externaldns_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.loki_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.tls_cert_backup_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.tls_cert_restore_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.vault_init_s3_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.vault_s3_backup_v2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_route53_hosted_zone_dnssec.cluster_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_hosted_zone_dnssec) | resource |
| [aws_route53_key_signing_key.cluster_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_key_signing_key) | resource |
| [aws_route53_record.cluster_zone_dnssec_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.cluster_zone_ns_records](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.wildcard_for_apps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.clusters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [random_password.dex_argocd_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.dex_grafana_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.dex_oauth2_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.dex_oauth2_cookie_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.dex_vault_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_uuid.certmanager_v2_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.externaldns_v2_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.loki_v2_aws_iam_policy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.loki_v2_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.route53_v2_aws_iam_policy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.tls_cert_backup_s3_v2_aws_iam_policy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.tls_cert_backup_s3_v2_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.tls_cert_restore_s3_v2_aws_iam_policy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.tls_cert_restore_s3_v2_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.vault_init_s3_v2_aws_iam_policy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.vault_init_s3_v2_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.vault_s3_backup_v2_aws_iam_policy](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.vault_s3_backup_v2_aws_iam_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_environments"></a> [cluster\_environments](#input\_cluster\_environments) | Full definition of each cluster environment: name, GitHub OAuth/App credentials for dex and the tenant org, ingress/traefik/nginx toggles, storage sizing, vault policy mappings, argocd RBAC, and optional gluekube provider/waggle credentials. Migrated tenants pass a single-element list per module instantiation. | <pre>list(object({<br/>    environment_name                        = string<br/>    host_network_enabled                    = bool<br/>    traefik_enable_internal_lb              = optional(bool, false)<br/>    traefik_enable_public_lb                = optional(bool, true)<br/>    nginx_enable_public_lb                  = optional(bool, true)<br/>    prometheus_volume_claim_storage_request = optional(string, "50")<br/>    vault_data_storage                      = optional(string, "10")<br/>    nginx_controller_replica_count          = optional(string, "2")<br/>    traefik_internal_lb_deployment_replicas = optional(string, "2")<br/>    traefik_public_lb_deployment_replicas   = optional(string, "2")<br/>    github_oauth_app_client_id              = string<br/>    github_oauth_app_client_secret          = string<br/>    github_tenant_app_id                    = string<br/>    github_tenant_app_installation_id       = string<br/>    github_tenant_app_b64enc_private_key    = string<br/>    admin_github_org_name                   = string<br/>    tenant_github_org_name                  = string<br/>    kubeadm_cluster                         = optional(bool, false)<br/>    vault_github_org_team_policy_mappings = list(object({<br/>      oidc_groups = list(string)<br/>      policy_name = string<br/>    }))<br/>    argocd_rbac_policies = string<br/>    provider_credentials = optional(map(any), null)<br/>    waggle_credentials = optional(object({<br/>      waggle_endpoint      = string<br/>      waggle_api_key       = string<br/>      waggle_datacenter_id = string<br/>    }), null)<br/>  }))</pre> | n/a | yes |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Shared tenant values produced by the tenant-base module (its captain\_cluster\_inputs output). | <pre>object({<br/>    tenant_key                                                 = string<br/>    tenant_account_id                                          = string<br/>    this_is_development                                        = string<br/>    primary_region                                             = string<br/>    backup_region                                              = string<br/>    github_owner                                               = string<br/>    parent_zone_id                                             = string<br/>    parent_zone_name                                           = string<br/>    management_tenant_dns_zone_name                            = string<br/>    dnssec_kms_key_arn                                         = string<br/>    s3_multi_region_access_point_arn                           = string<br/>    s3_multi_region_access_point_arn_for_object_level_policies = string<br/>    s3_primary_arn                                             = string<br/>    s3_replica_arn                                             = string<br/>    tls_cert_backup_s3_key_prefix                              = string<br/>    vault_backup_s3_key_prefix                                 = string<br/>    autoglue_credential_route53_id                             = string<br/>  })</pre> | n/a | yes |
| <a name="input_tenant_secrets"></a> [tenant\_secrets](#input\_tenant\_secrets) | Shared tenant secrets produced by the tenant-base module (its captain\_cluster\_secrets output). | <pre>object({<br/>    autoglue_iam = object({<br/>      access_key_id     = string<br/>      secret_access_key = string<br/>    })<br/>    autoglue_credentials = optional(object({<br/>      autoglue_key        = string<br/>      autoglue_org_secret = string<br/>      base_url            = string<br/>    }))<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
