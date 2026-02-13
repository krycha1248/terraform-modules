variable "da_host" {
  description = "DirectAdmin Address"
  type        = string
}

variable "da_user" {
  description = "DirectAdmin Login"
  type        = string
}

variable "da_pass" {
  description = "DirectAdmin Password"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain"
  type        = string
}

variable "record_name" {
  description = "Record name"
  type        = string
}

variable "record_type" {
  description = "Typ rekordu DNS"
  type        = string
  default     = "A"

  validation {
    condition     = contains(["A", "AAAA", "CNAME", "MX", "TXT", "NS"], var.record_type)
    error_message = "record_type must be one of these: A, AAAA, CNAME, MX, TXT, NS"
  }
}

variable "record_value" {
  description = "Record Value"
  type        = string
}

variable "record_ttl" {
  description = "TTL for the DNS record (optional)"
  type        = number
  default     = null
}

variable "record_priority" {
  description = "Priority for MX record (optional, only used for MX type)"
  type        = number
  default     = null
}
