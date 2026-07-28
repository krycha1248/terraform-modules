data "kubernetes_namespace_v1" "keycloak_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_manifest" "issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"
    metadata = {
      name      = var.cluster_issuer_name
      namespace = data.kubernetes_namespace_v1.keycloak_namespace.metadata[0].name
    }
    spec = {
      acme = {
        email  = var.acme_email
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = var.cluster_issuer_private_key_secret_name
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = var.ingress_class_name
              }
            }
          }
        ]
      }
    }
  }
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "oci://ghcr.io/codecentric/helm-charts"
  chart      = "keycloakx"
  namespace  = data.kubernetes_namespace_v1.keycloak_namespace.metadata[0].name
  wait       = true
  values = [templatefile("${path.module}/values.yaml.tpl", {
    domain_name        = var.domain_name
    db_hostname        = var.db_hostname
    ingress_class_name = var.ingress_class_name
  })]
}
