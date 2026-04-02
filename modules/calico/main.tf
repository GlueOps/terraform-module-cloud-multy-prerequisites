variable "calicoctl_version" {
  description = "The version of calicoctl to use in the generated values file."
  type        = string
}

variable "tigera_operator_version" {
  description = "The version of tigera operator to use in the generated values file."
  type        = string
}

output "helm_values" {
  value = templatefile("${path.module}/values.tpl", {
    calicoctl_version_placeholder       = var.calicoctl_version,
    tigera_operator_version_placeholder = var.tigera_operator_version
  })
}
