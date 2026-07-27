resource "helm_release" "traefik" {
  count            = var.deploy_traefik ? 1 : 0
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "traefik"
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [
    yamlencode({
      service = {
        type = "LoadBalancer"
        spec = {
          # Preserve real client source IP (otherwise pods see node/internal IPs).
          externalTrafficPolicy = "Local"
        }
      }
      ports = {
        web = {
          # Allow ACME HTTP-01 challenge paths (/.well-known/acme-challenge/*)
          # to bypass the HTTP→HTTPS redirect. Without this, Let's Encrypt
          # gets a 301 redirect instead of the challenge token and validation fails.
          allowACMEByPass = true
          http = {
            redirections = {
              entryPoint = {
                to        = "websecure"
                scheme    = "https"
                permanent = true
              }
            }
          }
        }
      }
    })
  ]
}

data "kubernetes_service_v1" "traefik" {
  count = var.deploy_traefik ? 1 : 0
  metadata {
    name      = "traefik"
    namespace = helm_release.traefik[0].namespace
  }
}

resource "helm_release" "cert_manager" {
  count            = var.deploy_traefik ? 1 : 0
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  timeout          = 600

  set = [
    {
      name  = "startupapicheck.enabled"
      value = "false"
    },
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}
