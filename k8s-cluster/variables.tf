variable "service_name" {
  description = "OVH Public Cloud Project id"
  type        = string
  nullable    = false
}

variable "vlan_id" {
  description = "OVH Public Cloud Project VLAN id"
  type        = string
  nullable    = false
  default     = "0"
}

variable "network_name" {
  description = "OVH Public Cloud Project Network name"
  type        = string
  nullable    = false
  default     = "Kubernetes Private Network"
}

variable "subnet_name" {
  description = "OVH Public Cloud Project Subnet name"
  type        = string
  nullable    = false
  default     = "Kubernetes Private Subnet"
}

variable "region" {
  description = "OVH Public Cloud Project Network region"
  type        = string
  nullable    = false
  default     = "WAW1"
}

variable "cluster_name" {
  description = "OVH Public Cloud Project Kubernetes cluster name"
  type        = string
  nullable    = false
  default     = "Kubernetes Cluster"
}

variable "node_pool_name" {
  description = "OVH Public Cloud Project Kubernetes cluster node pool name"
  type        = string
  nullable    = false
  default     = "kubernetes-node-pool"
}

variable "node_pool_flavor" {
  description = "OVH Public Cloud Project Kubernetes cluster node pool flavor"
  type        = string
  nullable    = false
  default     = "d2-4"
}

variable "node_pool_desired_nodes" {
  description = "OVH Public Cloud Project Kubernetes cluster node pool desired nodes"
  type        = number
  nullable    = false
  default     = 1
}

variable "gateway_name" {
  description = "OVH Public Cloud Project Kubernetes cluster gateway name"
  type        = string
  nullable    = false
  default     = "Kubernetes Gateway"
}

variable "gateway_model" {
  description = "OVH Public Cloud Project Kubernetes cluster gateway model"
  type        = string
  nullable    = false
  default     = "s"
}

variable "network_cidr" {
  description = "OVH Public Cloud Project Kubernetes cluster network CIDR"
  type        = string
  nullable    = false
  default     = "10.0.0.0/24"
}

variable "network_start_address" {
  description = "OVH Public Cloud Project Kubernetes cluster network start IP address"
  type        = string
  nullable    = false
  default     = "10.0.0.2"
}

variable "network_end_address" {
  description = "OVH Public Cloud Project Kubernetes cluster network end IP address"
  type        = string
  nullable    = false
  default     = "10.0.0.254"
}

variable "gateway_ip" {
  description = "OVH Public Cloud Project Kubernetes cluster gateway IP address"
  type        = string
  nullable    = false
  default     = "10.0.0.1"
}

variable "dhcp_enabled" {
  description = "OVH Public Cloud Project Kubernetes cluster network DHCP enabled"
  type        = bool
  nullable    = false
  default     = true
}