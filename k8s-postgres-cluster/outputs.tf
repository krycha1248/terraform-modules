output "cluster_address" {
  value = "${kubernetes_manifest.cnpg_cluster.manifest.metadata.name}-rw.${kubernetes_manifest.cnpg_cluster.manifest.metadata.namespace}.svc.cluster.local"
}