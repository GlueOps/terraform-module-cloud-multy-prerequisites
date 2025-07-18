variable "argocd_helm_chart_version" {
  description = "Argocd helm chart version"
  type        = string
  nullable    = false
}

variable "argocd_app_version" {
  description = "Codespace version"
  type        = string
  nullable    = false
}


variable "calico_helm_chart_version" {
  description = "Calico helm chart version"
  type        = string
  nullable    = false
}

variable "calico_ctl_version" {
  description = "Calico ctl version"
  type        = string
  nullable    = false
}

variable "tigera_operator_version" {
  description = "calico tigera operator version"
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

variable "terraform_module_version" {
  description = "terraform-module-cloud-aws-kubernetes-cluster version"
  type        = string
  nullable    = false
}

data "local_file" "version" {
  filename = "${path.module}/version.tpl"
}

output "platform_versions" {
  value = replace(replace(replace(replace(replace(replace(replace(replace(
    data.local_file.version.content,
    "glueops_platform_helm_chart_version_placeholder", "${var.glueops_platform_version}"),
    "argocd_helm_chart_version_placeholder", "${var.argocd_helm_chart_version}"),
    "argocd_app_version_placeholder", "${var.argocd_app_version}"),
    "codespace_version_placeholder", "${var.codespace_version}"),
    "calico_helm_chart_version_placeholder", "${var.calico_helm_chart_version}"),
    "calico_ctl_version_placeholder", "${var.calico_ctl_version}"),
    "terraform_module_version_placeholder", "${var.terraform_module_version}"),
  "tigera_operator_version_placeholder", "${var.tigera_operator_version}")
}
