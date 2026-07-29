resource "kubernetes_secret_v1" "backup" {
  count = var.backup != null ? 1 : 0

  metadata {
    name      = "${var.cluster_name}-backup"
    namespace = kubernetes_namespace_v1.namespace.metadata[0].name
  }

  data = {
    ACCESS_KEY_ID     = var.backup.access_key
    ACCESS_SECRET_KEY = var.backup.secret_key
  }

  type = "Opaque"
}
