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

variable "acme_email" {
  description = "Email address for ACME certificate registration."
  type        = string
  nullable    = false
}

variable "cluster_issuer_name" {
  description = "cert-manager ClusterIssuer name used by ingress."
  type        = string
  default     = "letsencrypt-prod"
}

variable "cluster_issuer_private_key_secret_name" {
  description = "Secret name used by ClusterIssuer ACME account key."
  type        = string
  default     = "letsencrypt-prod"
}

variable "ingress_class_name" {
  description = "Ingress class name used by cert-manager."
  type        = string
  default     = "traefik"
}

variable "domain" {
  description = "Domain name for the Jitsi deployment."
  type        = string
  nullable    = false
}

variable "ingress_ip" {
  description = "Ingress IP address for the Jitsi deployment."
  type        = string
  nullable    = false
}