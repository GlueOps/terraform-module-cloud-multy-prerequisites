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




data "local_file" "readme" {
  filename = "${path.module}/tenant-readme.md.tpl"
}


output "tenant_readme" {
  tenant_readme = replace(replace(replace(
    data.local_file.readme.content,
    "placeholder_repo_name", "${var.repository_name}"),
    "placeholder_tenant_key", "${var.company_key}"),
  "placeholder_cluster_environment", "${var.cluster_environment}")

}

