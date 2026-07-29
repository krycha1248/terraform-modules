variable "service_name" {
  description = "OVH Public Cloud Project id"
  type        = string
  nullable    = false
}

variable "region_name" {
  description = "OVH Public Cloud Project region name"
  type        = string
  nullable    = false
  default     = "WAW"
}

variable "bucket_name" {
  description = "OVH Public Cloud Project storage bucket name"
  type        = string
  nullable    = false
  default     = "my-encrypted-storage"
}

variable "versioning_enabled" {
  description = "Enable versioning for the storage bucket"
  type        = string
  nullable    = false
  default     = "enabled"
  validation {
    condition     = contains(["enabled", "disabled"], var.versioning_enabled)
    error_message = "versioning_enabled must be either 'enabled' or 'disabled'."
  }
}

variable "user_description" {
  description = "OVH Public Cloud Project user description"
  type        = string
  nullable    = false
  default     = "User created for S3 bucket access"
}
