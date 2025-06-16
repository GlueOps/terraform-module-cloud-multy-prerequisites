variable "csi_driver_version" {
  description = "EBS CSI driver"
  type        = string
  nullable    = false
}

variable "coredns_version" {
  description = "CoreDns version"
  type        = string
  nullable    = false
}

variable "kube_proxy_version" {
  description = "KubeProxy version"
  type        = string
  nullable    = false
}

variable "ami_release_version" {
  description = "EKS node pool AMI release version"
  type        = string
  nullable    = false
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  nullable    = false
}


data "local_file" "version" {
  filename = "${path.module}/version.tpl"
}

output "tenant_cluster_versions" {
  value = replace(replace(replace(replace(replace(
    data.local_file.version.content,
    "csi_driver_version_placeholder", "${var.csi_driver_version}"),
    "coredns_version_placeholder", "${var.coredns_version}"),
    "kube_proxy_version_placeholder", "${var.kube_proxy_version}"),
    "ami_release_version_placeholder", "${var.ami_release_version}"),
    "kubernetes_version_placeholder", "${var.kubernetes_version}")
}
