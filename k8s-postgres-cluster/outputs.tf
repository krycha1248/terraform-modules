output "cluster_address" {
  value = "${kubernetes_manifest.cnpg_operator.metadata.name}-rw.${kubernetes_manifest.cnpg_operator.metadata.namespace}.svc.cluster.local"
}