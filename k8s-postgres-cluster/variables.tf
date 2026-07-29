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

variable "cluster_name" {
  description = "The name of the PostgreSQL cluster."
  type        = string
  nullable    = false
  default     = "cnpg-cluster"
}

variable "namespace" {
  description = "The Kubernetes namespace where the PostgreSQL cluster will be deployed."
  type        = string
  nullable    = false
  default     = "default"
}

variable "instances_count" {
  description = "The number of instances in the PostgreSQL cluster."
  type        = number
  nullable    = false
  default     = 2
}

variable "storage_size" {
  description = "The size of the storage for each PostgreSQL instance."
  type        = string
  nullable    = false
  default     = "1Gi"
}

variable "mode" {
  type = string
  default = "normal"

  validation {
    condition = contains(["normal", "restore"], var.mode)
    error_message = "mode must be normal or restore."
  }
}

variable "backup_retention_policy" {
  type = string
  default = "30d"
}

variable "backup" {
  type = object({
    endpoint = string
    bucket = string
    path = string
    access_key = string
    secret_key = string
    schedule = string
  })

  default = null
}
