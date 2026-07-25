output "kubernetes_config" {
  description = "Kubernetes configuration file (kubeconfig) for the cluster"
  value       = ovh_cloud_project_kube.cluster.kubeconfig
  sensitive   = true
}

output "kubernetes_host" {
  description = "Kubernetes API server host for the cluster"
  value       = ovh_cloud_project_kube.cluster.kubeconfig_attributes.host
}

output "kubernetes_ca_certificate" {
  description = "Kubernetes API server CA certificate for the cluster"
  value       = ovh_cloud_project_kube.cluster.kubeconfig_attributes.cluster_ca_certificate
  sensitive   = true
}

output "kubernetes_client_certificate" {
  description = "Kubernetes API server client certificate for the cluster"
  value       = ovh_cloud_project_kube.cluster.kubeconfig_attributes.client_certificate
  sensitive   = true
}

output "kubernetes_client_key" {
  description = "Kubernetes API server client key for the cluster"
  value       = ovh_cloud_project_kube.cluster.kubeconfig_attributes.client_key
  sensitive   = true
}
