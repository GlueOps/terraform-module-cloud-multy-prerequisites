data "local_file" "readme" {
  filename = "${path.module}/README.md.tpl"
}


locals {
  gcp_project_setup = replace(replace(replace(
      data.local_file.readme.content,
        "placeholder_repo_name", "${var.var.repostory_name}"),
        "placeholder_tenant_key", "${var.tenant_key}"),
        "placeholder_cluster_environment", "${var.cluster_environment}")

}

