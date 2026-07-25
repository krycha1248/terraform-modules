output "kubernetes_config" {
  value     = ovh_cloud_project_kube.cluster.kubeconfig
  sensitive = true
}

output "kubernetes_cluster_id" {
  value = ovh_cloud_project_kube.cluster.id
}