data "local_file" "readme" {
  filename = "${path.module}/tenant-readme.md.tpl"
}


locals {
  tenant_readme = replace(replace(replace(
      data.local_file.readme.content,
        "placeholder_repo_name", "${var.var.repostory_name}"),
        "placeholder_tenant_key", "${var.tenant_key}"),
        "placeholder_cluster_environment", "${var.cluster_environment}")

}

