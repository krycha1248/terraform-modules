resource "kubernetes_manifest" "cnpg_operator" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"
    metadata = {
      name      = var.cluster_name
      namespace = var.namespace
    }

    spec = {
      instances = var.instances_count
      storage = {
        size = var.storage_size
      }
    }
  }

  wait {
    fields = {
      "status.phase" = "Cluster in healthy state"
    }
  }
}
