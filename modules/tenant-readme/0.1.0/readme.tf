variable "tenant_key" {
  description = "The tenant key"
  type        = string
  nullable    = false
}

variable "cluster_environment" {
  description = "The environment of the cluster"
  type        = string
  nullable    = false
}

variable "repository_name" {
  description = "The name of the repository"
  type        = string
  nullable    = false
}

variable "placeholder_github_owner" {
  description = "The github owner"
  type        = string
  nullable    = false
}

variable "tenant_github_org_name" {
  description = "The GitHub organization of the Tenant"
  type        = string
  nullable    = false
}

variable "argocd_app_version" {
  type        = string
  description = "This is the appVersion of argocd. Example: v2.7.11"
}


data "local_file" "readme" {
  filename = "${path.module}/tenant-readme.md.tpl"
}

locals {
  codespace_version         = "v0.80.0"
  argocd_crd_version        = var.argocd_app_version
  argocd_helm_chart_version = "7.6.12"
  glueops_platform_version  = "v0.54.3" # this also needs to be updated in the module.glueops_platform_helm_values // generate-helm-values.tf
  tools_version             = "v0.26.0"
}


output "tenant_readme" {
  value = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
    data.local_file.readme.content,
    "placeholder_github_owner", "${var.placeholder_github_owner}"),
    "placeholder_repo_name", "${var.repository_name}"),
    "placeholder_tenant_key", "${var.tenant_key}"),
    "placeholder_cluster_environment", "${var.cluster_environment}"),
    "placeholder_argocd_crd_version", "${local.argocd_crd_version}"),
    "placeholder_argocd_helm_chart_version", "${local.argocd_helm_chart_version}"),
    "placeholder_glueops_platform_version", "${local.glueops_platform_version}"),
    "placeholder_codespace_version", "${local.codespace_version}"),
    "placeholder_tenant_github_org_name", "${var.tenant_github_org_name}"),
  "placeholder_tools_version", "${local.tools_version}")
}
