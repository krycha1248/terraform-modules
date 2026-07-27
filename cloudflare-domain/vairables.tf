variable "domain_name" {
  description = "The domain name to manage in Cloudflare."
  type        = string
  nullable    = false
}

variable "zone_name" {
  description = "The Cloudflare zone name for the domain."
  type        = string
  nullable    = false
}

variable "ip_address" {
  description = "The IP address for the A record."
  type        = string
  nullable    = false
}

variable "www_subdomain_enabled" {
  description = "Flag to determine whether to create a CNAME record for the www subdomain."
  type        = bool
  default     = false
}
