output "kubernetes_config" {
  value     = ovh_cloud_project_kube.cluster.kubeconfig
  sensitive = true
}

output "kubernetes_host" {
  value = ovh_cloud_project_kube.cluster.kubeconfig_attributes.host
}

output "kubernetes_ca_certificate" {
  value     = ovh_cloud_project_kube.cluster.kubeconfig_attributes.cluster_ca_certificate
  sensitive = true
}

output "kubernetes_client_certificate" {
  value     = ovh_cloud_project_kube.cluster.kubeconfig_attributes.client_certificate
  sensitive = true
}

output "kubernetes_client_key" {
  value     = ovh_cloud_project_kube.cluster.kubeconfig_attributes.client_key
  sensitive = true
}