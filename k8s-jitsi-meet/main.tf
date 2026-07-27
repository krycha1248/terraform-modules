resource "kubernetes_namespace_v1" "jitsi_namespace" {
  metadata {
    name = "jitsi"
  }
}

resource "kubernetes_manifest" "certissuer" {
  manifest = yamldecode(templatefile("${path.module}/cert-issuer.yaml.tpl", {
    email                           = var.acme_email
    namespace_name                  = kubernetes_namespace_v1.jitsi_namespace.metadata[0].name
    cluster_issuer_name             = var.cluster_issuer_name
    cluster_issuer_private_key_name = var.cluster_issuer_private_key_secret_name
    ingress_class_name              = var.ingress_class_name
  }))
}