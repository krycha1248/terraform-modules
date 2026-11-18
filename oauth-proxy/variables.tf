variable "namespace" {
  description = "Kubernetes namespace to deploy oauth2-proxy into"
  type        = string
}

variable "create_namespace" {
  description = "Whether to create the Kubernetes namespace if it does not exist"
  type        = bool
  default     = false
}

variable "app_name" {
  description = "Application and resource name prefix"
  type        = string
  default     = "oauth2-proxy"
}

variable "replicas" {
  description = "Number of pod replicas"
  type        = number
  default     = 1
}

variable "image_name" {
  description = "Docker image repository for oauth2-proxy"
  type        = string
  default     = "quay.io/oauth2-proxy/oauth2-proxy"
}

variable "image_tag" {
  description = "Docker image tag for oauth2-proxy"
  type        = string
  default     = "v7.8.1"
}

variable "image_pull_policy" {
  description = "Image pull policy for the container"
  type        = string
  default     = "IfNotPresent"
}

variable "image_pull_secrets" {
  description = "List of image pull secrets for private registry access"
  type        = list(string)
  default     = []
}

#
# OAuth2 / OIDC Provider Settings
#

variable "provider_type" {
  description = "OAuth / OIDC provider type (e.g. github, keycloak-oidc, oidc, google, gitlab, azure)"
  type        = string
  default     = "github"
}

variable "github_org" {
  description = "Restrict login to members of this GitHub organization (provider=github only)"
  type        = string
  default     = ""
}

variable "github_team" {
  description = "Restrict login to members of this GitHub team (provider=github only, format: org/team)"
  type        = string
  default     = ""
}

variable "github_users" {
  description = "List of allowed GitHub usernames (e.g. ['krycha1248', 'jan_kowalski'])"
  type        = list(string)
  default     = []
}

variable "client_id" {
  description = "OAuth2 / OIDC Client ID"
  type        = string
}

variable "client_secret" {
  description = "OAuth2 / OIDC Client Secret"
  type        = string
  sensitive   = true
}

variable "oidc_issuer_url" {
  description = "OIDC Issuer URL (e.g. https://keycloak.wlodek.net/realms/myrealm)"
  type        = string
  default     = ""
}

variable "scope" {
  description = "OAuth2 / OIDC Scopes requested during authentication. Defaults to 'read:user user:email read:org' for GitHub, 'openid email profile' for OIDC."
  type        = string
  default     = ""
}

variable "redirect_url" {
  description = "OAuth2 callback URL (e.g. https://auth.wlodek.net/oauth2/callback). If empty, auto-detected from request host."
  type        = string
  default     = ""
}

variable "email_domains" {
  description = "List of allowed email domains (use ['*'] to allow all authenticated users)"
  type        = list(string)
  default     = ["*"]
}

variable "whitelist_domains" {
  description = "Allowed redirect domains after login"
  type        = list(string)
  default     = []
}

#
# Cookie Settings
#

variable "cookie_secret" {
  description = "Secret used to sign session cookies (must be 16, 24, or 32 bytes). If empty, a 32-character secret is generated automatically."
  type        = string
  sensitive   = true
  default     = ""
}

variable "cookie_name" {
  description = "Name of the authentication session cookie"
  type        = string
  default     = "_oauth2_proxy"
}

variable "cookie_domain" {
  description = "Domain scope for the session cookie (e.g. .wlodek.net)"
  type        = string
  default     = ""
}

variable "cookie_secure" {
  description = "Whether to set the Secure attribute on cookies (recommended true when served over HTTPS)"
  type        = bool
  default     = true
}

variable "cookie_expire" {
  description = "Session cookie expiration duration"
  type        = string
  default     = "168h"
}

variable "cookie_refresh" {
  description = "Interval to refresh session tokens"
  type        = string
  default     = "1h"
}

#
# Proxy & Upstream Settings
#

variable "upstreams" {
  description = "List of upstream URLs to proxy authenticated requests to. In ForwardAuth/Middleware mode, defaults to ['static://202']."
  type        = list(string)
  default     = ["static://202"]
}

variable "reverse_proxy" {
  description = "Enable reverse proxy mode to trust X-Forwarded-* headers from upstream ingress/load balancer"
  type        = bool
  default     = true
}

variable "real_client_ip_header" {
  description = "Header to inspect for the real client IP address when reverse_proxy is true (e.g. X-Forwarded-For, X-Real-IP, CF-Connecting-IP)"
  type        = string
  default     = "X-Forwarded-For"
}

variable "skip_provider_button" {
  description = "Skip the 'Sign in with...' button and redirect directly to identity provider"
  type        = bool
  default     = false
}

variable "pass_authorization_header" {
  description = "Pass OIDC IDToken to upstream in Authorization Bearer header"
  type        = bool
  default     = true
}

variable "pass_user_headers" {
  description = "Pass authenticated user info (X-Forwarded-User, X-Forwarded-Email) to upstream"
  type        = bool
  default     = true
}

variable "set_xauthrequest" {
  description = "Set X-Auth-Request-* response headers (required for ForwardAuth mode)"
  type        = bool
  default     = true
}

#
# Traefik Middleware Settings
#

variable "create_traefik_middleware" {
  description = "Whether to create Traefik ForwardAuth and Errors Middleware CRDs"
  type        = bool
  default     = true
}

variable "auth_response_headers" {
  description = "Headers copied from oauth2-proxy response to the upstream application request"
  type        = list(string)
  default = [
    "X-Auth-Request-User",
    "X-Auth-Request-Email",
    "X-Auth-Request-Access-Token",
    "Authorization"
  ]
}

#
# Service & Ingress Settings
#

variable "service_port" {
  description = "Kubernetes Service port for oauth2-proxy"
  type        = number
  default     = 4180
}

variable "ingress_enabled" {
  description = "Whether to create a Kubernetes Ingress resource exposing the /oauth2 endpoints"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for the Ingress resource (e.g. kubealert.wlodek.net)"
  type        = string
  default     = ""
}

variable "ingress_path" {
  description = "Path prefix to route to oauth2-proxy (default /oauth2 allows the app to own / while oauth2-proxy handles auth callbacks)"
  type        = string
  default     = "/oauth2"
}

variable "ingress_class_name" {
  description = "Ingress class name (e.g. traefik)"
  type        = string
  default     = "traefik"
}

variable "ingress_annotations" {
  description = "Annotations to attach to the Ingress resource"
  type        = map(string)
  default = {
    "traefik.ingress.kubernetes.io/router.entrypoints" = "web,websecure"
  }
}

#
# Custom Templates Settings
#

variable "custom_templates_enabled" {
  description = "Whether to mount and use custom HTML templates for login and error pages"
  type        = bool
  default     = true
}

variable "portal_title" {
  description = "Application / portal title displayed on custom sign-in and error pages"
  type        = string
  default     = "KubeAlert"
}

variable "portal_description" {
  description = "Description displayed on the custom sign-in page"
  type        = string
  default     = "Sign in with your GitHub account to access the application."
}

variable "custom_sign_in_template" {
  description = "Custom sign_in.html content (overrides built-in template if provided)"
  type        = string
  default     = ""
}

variable "custom_error_template" {
  description = "Custom error.html content (overrides built-in template if provided)"
  type        = string
  default     = ""
}

#
# Resources & Customization
#

variable "resources" {
  description = "Resource limits and requests for oauth2-proxy"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "200m"
      memory = "128Mi"
    }
    requests = {
      cpu    = "50m"
      memory = "64Mi"
    }
  }
}

variable "extra_env" {
  description = "Additional environment variables to pass to the container"
  type        = map(string)
  default     = {}
}

variable "extra_args" {
  description = "Additional command-line arguments to pass to oauth2-proxy"
  type        = list(string)
  default     = []
}

variable "extra_labels" {
  description = "Extra labels to attach to all created Kubernetes resources"
  type        = map(string)
  default     = {}
}
