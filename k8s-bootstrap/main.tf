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

        annotations = {
          "service.beta.kubernetes.io/ovh-loadbalancer-proxy-protocol" = "v2"
        }

        spec = {
          externalTrafficPolicy = "Local"
        }
      }

      ports = {
        web = {
          proxyProtocol = {
            trustedIPs = [
              "0.0.0.0/0"
            ]
          }

          forwardedHeaders = {
            trustedIPs = [
              "0.0.0.0/0"
            ]
          }

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

        websecure = {
          proxyProtocol = {
            trustedIPs = [
              "0.0.0.0/0"
            ]
          }

          forwardedHeaders = {
            trustedIPs = [
              "0.0.0.0/0"
            ]
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

resource "helm_release" "cloudnativepg" {
  depends_on       = [helm_release.cert_manager]
  count            = var.deploy_cnpg ? 1 : 0
  name             = "cloudnativepg"
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  namespace        = "cloudnative-pg"
  create_namespace = true
  wait             = true
  timeout          = 600
}

resource "helm_release" "cnpg_plugin_barman_cloud" {
  count            = var.deploy_cnpg ? 1 : 0
  name             = "plugin-barman-cloud"
  namespace        = helm_release.cloudnativepg[0].namespace
  create_namespace = false
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "plugin-barman-cloud"
}
