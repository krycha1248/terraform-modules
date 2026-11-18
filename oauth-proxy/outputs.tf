output "service_name" {
  description = "Name of the Kubernetes Service for oauth2-proxy"
  value       = kubernetes_service_v1.this.metadata[0].name
}

output "service_port" {
  description = "Port of the Kubernetes Service for oauth2-proxy"
  value       = var.service_port
}

output "service_host" {
  description = "Full in-cluster DNS name of the oauth2-proxy Service"
  value       = "${kubernetes_service_v1.this.metadata[0].name}.${var.namespace}.svc.cluster.local"
}

output "deployment_name" {
  description = "Name of the oauth2-proxy Kubernetes Deployment"
  value       = kubernetes_deployment_v1.this.metadata[0].name
}

output "namespace" {
  description = "Kubernetes namespace where oauth2-proxy is deployed"
  value       = var.namespace
}

output "cookie_secret" {
  description = "The session cookie secret (auto-generated or user-provided)"
  value       = local.effective_cookie_secret
  sensitive   = true
}

output "traefik_forward_auth_middleware" {
  description = "Name of the Traefik ForwardAuth Middleware (for use in Ingress annotations: namespace-name@kubernetescrd)"
  value       = var.create_traefik_middleware ? "${var.namespace}-${var.app_name}-auth@kubernetescrd" : null
}

output "traefik_errors_middleware" {
  description = "Name of the Traefik Errors Middleware (for use in Ingress annotations: namespace-name@kubernetescrd)"
  value       = var.create_traefik_middleware ? "${var.namespace}-${var.app_name}-errors@kubernetescrd" : null
}

output "traefik_middleware_annotation" {
  description = "Full ready-to-use annotation value for Traefik Ingress: 'traefik.ingress.kubernetes.io/router.middlewares'"
  value       = var.create_traefik_middleware ? "${var.namespace}-${var.app_name}-errors@kubernetescrd,${var.namespace}-${var.app_name}-auth@kubernetescrd" : null
}
