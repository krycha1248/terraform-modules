output "cluster_address" {
  value = "${kubernetes_manifest.cluster.manifest.metadata.name}-rw.${kubernetes_manifest.cluster.manifest.metadata.namespace}.svc.cluster.local"
}