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