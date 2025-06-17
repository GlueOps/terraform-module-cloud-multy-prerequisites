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



variable "argocd_helm_chart_version" {
  type        = string
  description = "Argocd helm chart version"
}

variable "glueops_platform_version" {
  type        = string
  description = "glueops platform version like v0.59.2"
}

variable "codespace_version" {
  type        = string
  description = "codespace version"
}

variable "tools_version" {
  type        = string
  description = "This is the tools version"
}

data "local_file" "readme" {
  filename = "${path.module}/tenant-readme.md.tpl"
}

output "tenant_readme" {
  value = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
    data.local_file.readme.content,
    "placeholder_github_owner", "${var.placeholder_github_owner}"),
    "placeholder_repo_name", "${var.repository_name}"),
    "placeholder_tenant_key", "${var.tenant_key}"),
    "placeholder_cluster_environment", "${var.cluster_environment}"),
    "placeholder_argocd_crd_version", "${var.argocd_app_version}"),
    "placeholder_argocd_helm_chart_version", "${var.argocd_helm_chart_version}"),
    "placeholder_glueops_platform_version", "${var.glueops_platform_version}"),
    "placeholder_codespace_version", "${var.codespace_version}"),
    "placeholder_tenant_github_org_name", "${var.tenant_github_org_name}"),
  "placeholder_tools_version", "${var.tools_version}")
}
