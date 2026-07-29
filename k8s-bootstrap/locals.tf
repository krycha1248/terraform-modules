locals {
  proxy_protocol_enabled = length(var.proxy_protocol_trusted_ips) > 0
}