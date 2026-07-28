output "cluster_address" {
  value = "${kubernetes_manifest.cnpg_operator.manifest.metadata.name}-rw.${kubernetes_manifest.cnpg_operator.manifest.metadata.namespace}.svc.cluster.local"
}