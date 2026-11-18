locals {
  common_labels = merge(
    {
      "app.kubernetes.io/name"       = var.app_name
      "app.kubernetes.io/instance"   = var.app_name
      "app.kubernetes.io/version"    = var.image_tag
      "app.kubernetes.io/managed-by" = "terraform"
    },
    var.extra_labels
  )

  effective_cookie_secret = var.cookie_secret != "" ? var.cookie_secret : random_password.cookie_secret.result

  default_scope   = var.provider_type == "github" ? "read:user user:email read:org" : "openid email profile"
  effective_scope = var.scope != "" ? var.scope : local.default_scope

  effective_whitelist_domains = distinct(concat(
    var.whitelist_domains,
    var.domain_name != "" ? [var.domain_name, ".${var.domain_name}"] : []
  ))

  base_args = concat(
    [
      "--http-address=0.0.0.0:4180",
      "--provider=${var.provider_type}",
      "--client-id=${var.client_id}",
      "--cookie-name=${var.cookie_name}",
      "--cookie-secure=${var.cookie_secure}",
      "--cookie-expire=${var.cookie_expire}",
      "--cookie-refresh=${var.cookie_refresh}",
      "--reverse-proxy=${var.reverse_proxy}",
      "--real-client-ip-header=${var.real_client_ip_header}",
      "--skip-provider-button=${var.skip_provider_button}",
      "--pass-authorization-header=${var.pass_authorization_header}",
      "--pass-user-headers=${var.pass_user_headers}",
      "--set-xauthrequest=${var.set_xauthrequest}",
      "--scope=${local.effective_scope}",
    ],
    var.oidc_issuer_url != "" ? ["--oidc-issuer-url=${var.oidc_issuer_url}"] : [],
    var.github_org != "" ? ["--github-org=${var.github_org}"] : [],
    var.github_team != "" ? ["--github-team=${var.github_team}"] : [],
    [for u in var.github_users : "--github-user=${u}"],
    var.redirect_url != "" ? ["--redirect-url=${var.redirect_url}"] : [],
    var.cookie_domain != "" ? ["--cookie-domain=${var.cookie_domain}"] : [],
    [for u in var.upstreams : "--upstream=${u}"],
    [for d in var.email_domains : "--email-domain=${d}"],
    [for w in local.effective_whitelist_domains : "--whitelist-domain=${w}"],
    var.custom_templates_enabled ? ["--custom-templates-dir=/etc/oauth2-proxy/templates"] : [],
    var.extra_args
  )
}

# Generate 32-character cookie secret automatically if not explicitly provided
resource "random_password" "cookie_secret" {
  length           = 32
  override_special = "-_"
}

# Optional namespace creation
resource "kubernetes_namespace_v1" "this" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name   = var.namespace
    labels = local.common_labels
  }
}

# Secret storing sensitive credentials (cookie secret and OAuth2 client secret)
resource "kubernetes_secret_v1" "this" {
  metadata {
    name      = "${var.app_name}-secret"
    namespace = var.namespace
    labels    = local.common_labels
  }

  data = {
    "cookie-secret" = local.effective_cookie_secret
    "client-secret" = var.client_secret
  }
}

# ConfigMap storing custom HTML templates (sign_in.html, error.html, robots.txt)
resource "kubernetes_config_map_v1" "templates" {
  count = var.custom_templates_enabled ? 1 : 0

  metadata {
    name      = "${var.app_name}-templates"
    namespace = var.namespace
    labels    = local.common_labels
  }

  data = {
    "sign_in.html" = var.custom_sign_in_template != "" ? var.custom_sign_in_template : templatefile("${path.module}/templates/sign_in.html.tpl", {
      portal_title       = var.portal_title
      portal_description = var.portal_description
    })
    "error.html" = var.custom_error_template != "" ? var.custom_error_template : templatefile("${path.module}/templates/error.html.tpl", {
      portal_title = var.portal_title
    })
    "robots.txt" = "{{define \"robots.txt\"}}User-agent: *\nDisallow: /{{end}}"
  }
}

# Deployment running oauth2-proxy
resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels    = local.common_labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name" = var.app_name
      }
    }

    template {
      metadata {
        labels = local.common_labels
      }

      spec {
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secrets
          content {
            name = image_pull_secrets.value
          }
        }

        container {
          name              = "oauth2-proxy"
          image             = "${var.image_name}:${var.image_tag}"
          image_pull_policy = var.image_pull_policy
          args              = local.base_args

          port {
            name           = "http"
            container_port = 4180
            protocol       = "TCP"
          }

          env {
            name = "OAUTH2_PROXY_COOKIE_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.this.metadata[0].name
                key  = "cookie-secret"
              }
            }
          }

          env {
            name = "OAUTH2_PROXY_CLIENT_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.this.metadata[0].name
                key  = "client-secret"
              }
            }
          }

          dynamic "env" {
            for_each = var.extra_env
            content {
              name  = env.key
              value = env.value
            }
          }

          resources {
            limits = {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
            requests = {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = 4180
            }
            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/ping"
              port = 4180
            }
            initial_delay_seconds = 3
            period_seconds        = 5
            timeout_seconds       = 2
            failure_threshold     = 2
          }

          security_context {
            run_as_non_root            = true
            run_as_user                = 2000
            allow_privilege_escalation = false
            read_only_root_filesystem  = true

            capabilities {
              drop = ["ALL"]
            }
          }

          dynamic "volume_mount" {
            for_each = var.custom_templates_enabled ? [1] : []
            content {
              name       = "custom-templates"
              mount_path = "/etc/oauth2-proxy/templates"
              read_only  = true
            }
          }
        }

        dynamic "volume" {
          for_each = var.custom_templates_enabled ? [1] : []
          content {
            name = "custom-templates"
            config_map {
              name = kubernetes_config_map_v1.templates[0].metadata[0].name
            }
          }
        }
      }
    }
  }
}

# ClusterIP Service for oauth2-proxy
resource "kubernetes_service_v1" "this" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels    = local.common_labels
  }

  spec {
    type = "ClusterIP"

    selector = {
      "app.kubernetes.io/name" = var.app_name
    }

    port {
      name        = "http"
      port        = var.service_port
      target_port = 4180
      protocol    = "TCP"
    }
  }
}

# Traefik ForwardAuth Middleware
resource "kubernetes_manifest" "traefik_forward_auth" {
  count = var.create_traefik_middleware ? 1 : 0

  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "${var.app_name}-auth"
      namespace = var.namespace
      labels    = local.common_labels
    }
    spec = {
      forwardAuth = {
        address             = "http://${kubernetes_service_v1.this.metadata[0].name}.${var.namespace}.svc.cluster.local:${var.service_port}/oauth2/auth"
        trustForwardHeader  = true
        authResponseHeaders = var.auth_response_headers
      }
    }
  }
}

# Traefik Errors Middleware (redirects 401/403 to oauth2 login flow)
resource "kubernetes_manifest" "traefik_errors" {
  count = var.create_traefik_middleware ? 1 : 0

  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "Middleware"
    metadata = {
      name      = "${var.app_name}-errors"
      namespace = var.namespace
      labels    = local.common_labels
    }
    spec = {
      errors = {
        status = ["401-403"]
        service = {
          name = kubernetes_service_v1.this.metadata[0].name
          port = var.service_port
        }
        query = "/oauth2/sign_in?rd={url}"
      }
    }
  }
}

# Optional Ingress exposing oauth2-proxy endpoints (/oauth2/*) for login and callback
resource "kubernetes_ingress_v1" "this" {
  count = var.ingress_enabled && var.domain_name != "" ? 1 : 0

  metadata {
    name        = "${var.app_name}-ingress"
    namespace   = var.namespace
    labels      = local.common_labels
    annotations = var.ingress_annotations
  }

  spec {
    ingress_class_name = var.ingress_class_name

    rule {
      host = var.domain_name

      http {
        path {
          path      = var.ingress_path
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.this.metadata[0].name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }
  }
}
