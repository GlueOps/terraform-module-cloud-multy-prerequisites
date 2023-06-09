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


data "local_file" "readme" {
  filename = "${path.module}/tenant-readme.md.tpl"
}

locals {
  codespace_version         = "v0.23.0"
  argocd_crd_version        = "v2.7.4"
  argocd_helm_chart_version = "5.36.1"
  glueops_platform_version  = "0.15.0-alpha2"
  tools_version             = "v0.1.4"
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
