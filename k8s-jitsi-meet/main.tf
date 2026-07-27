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

resource "helm_release" "jitsi" {
  depends_on = [
    kubernetes_manifest.certissuer
  ]
  name       = "jitsi"
  repository = "https://jitsi-contrib.github.io/jitsi-helm/"
  chart      = "jitsi"
  namespace  = kubernetes_namespace_v1.jitsi_namespace.metadata[0].name
  wait       = true

  values = [templatefile("${path.module}/values.yaml.tpl", {
    domain     = var.domain
    ingress_ip = var.ingress_ip
  })]
}
