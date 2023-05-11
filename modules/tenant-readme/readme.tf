variable "company_key" {
  description = "The company key"
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

variable "placeholder_github_repo_path" {
  description = "The github owner and repo"
  type = string
  nullable = false
}


data "local_file" "readme" {
  filename = "${path.module}/tenant-readme.md.tpl"
}


output "tenant_readme" {
  value = replace(replace(replace(replace(
    data.local_file.readme.content,
    "placeholder_github_repo_path", "${var.placeholder_github_repo_path}"),
    "placeholder_repo_name", "${var.repository_name}"),
    "placeholder_tenant_key", "${var.company_key}"),
  "placeholder_cluster_environment", "${var.cluster_environment}")
}

