variable "argocd_helm_chart_version" {
  description = "Argocd helm chart version"
  type        = string
  nullable    = false
}

variable "glueops_platform_version" {
  description = "GLueOps helm chart version"
  type        = string
  nullable    = false
}

variable "codespace_version" {
  description = "Codespace version"
  type        = string
  nullable    = false
}

data "local_file" "version" {
  filename = "${path.module}/version.tpl"
}

output "platform_versions" {
  value = replace(replace(replace(
    data.local_file.version.content,
    "glueops_platform_helm_chart_version_placeholder", "${var.glueops_platform_version}"),
    "argocd_helm_chart_version_placeholder", "${var.argocd_helm_chart_version}"),
    "codespace_version_placeholder", "${var.codespace_version}")
}
