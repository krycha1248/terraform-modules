variable "kube_host" {
  description = "The Kubernetes API server host URL."
  type        = string
  nullable    = false
}

variable "kube_client_certificate" {
  description = "Base64 encoded client certificate for Kubernetes authentication."
  type        = string
  nullable    = false
}

variable "kube_client_key" {
  description = "Base64 encoded client key for Kubernetes authentication."
  type        = string
  nullable    = false
}

variable "kube_cluster_ca_certificate" {
  description = "Base64 encoded CA certificate for the Kubernetes cluster."
  type        = string
  nullable    = false
}

variable "deploy_traefik" {
  description = "Flag to determine whether to deploy Traefik."
  type        = bool
  default     = false
}

variable "loadbalancer_annotations" {
  description = "Cloud provider specific annotations for Traefik LoadBalancer Service"
  type        = map(string)
  default     = {}
}

variable "proxy_protocol_trusted_ips" {
  description = "Trusted IP ranges allowed to send PROXY protocol. Empty list disables PROXY protocol."
  type        = list(string)
  default     = []
}

variable "forwarded_headers_trusted_ips" {
  description = "Trusted IP ranges allowed to send X-Forwarded-* headers."
  type        = list(string)
  default     = []
}

variable "deploy_cnpg" {
  description = "Flag to determine whether to deploy CloudNativePG."
  type        = bool
  default     = false
}
