locals {
  versions_yaml_content = file("${path.module}/VERSIONS/aws.yaml") # we should change this when cluster is kubeadm 
  versions_data         = yamldecode(local.versions_yaml_content)
}

module "tenant_cluster_versions" {
  source   = "./modules/kubernetes-versions/0.1.0"
  for_each = local.environment_map

  csi_driver_version  = one([for v in local.versions_data.versions : v.version if v.name == "csi_driver_version"])
  coredns_version     = one([for v in local.versions_data.versions : v.version if v.name == "coredns_version"])
  kube_proxy_version  = one([for v in local.versions_data.versions : v.version if v.name == "kube_proxy_version"])
  ami_release_version = one([for v in local.versions_data.versions : v.version if v.name == "ami_release_version"])
  kubernetes_version  = one([for v in local.versions_data.versions : v.version if v.name == "kubernetes_version"])
}
