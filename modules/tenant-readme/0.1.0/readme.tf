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

variable "glueops_platform_version" {
  type        = string
  description = "glueops platform version like v0.59.2"
}

variable "codespace_version" {
  type        = string
  description = "codespace version"
}

data "local_file" "readme" {
  filename = "${path.module}/tenant-readme.md.tpl"
}

output "tenant_readme" {
  value = replace(replace(replace(replace(replace(replace(replace(
    data.local_file.readme.content,
    "placeholder_github_owner", "${var.placeholder_github_owner}"),
    "placeholder_repo_name", "${var.repository_name}"),
    "placeholder_tenant_key", "${var.tenant_key}"),
    "placeholder_cluster_environment", "${var.cluster_environment}"),
    "placeholder_glueops_platform_version", "${var.glueops_platform_version}"),
    "placeholder_codespace_version", "${var.codespace_version}"),
  "placeholder_tenant_github_org_name", "${var.tenant_github_org_name}")
}
