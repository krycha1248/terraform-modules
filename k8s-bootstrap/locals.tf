locals {
  proxy_protocol_enabled = length(var.proxy_protocol_trusted_ips) > 0

  traefik_common_port_config = merge(
    local.proxy_protocol_enabled ? {
      proxyProtocol = {
        trustedIPs = var.proxy_protocol_trusted_ips
      }
    } : null,
    length(var.forwarded_headers_trusted_ips) > 0 ? {
      forwardedHeaders = {
        trustedIPs = var.forwarded_headers_trusted_ips
      }
    } : null
  )

  traefik_web_redirect_config = var.redirect_http_to_https ? {
    # Allow ACME HTTP-01 challenge paths (/.well-known/acme-challenge/*)
    # to bypass the HTTP→HTTPS redirect. Without this, Let's Encrypt
    # gets a 301 redirect instead of the challenge token and validation fails.
    allowACMEByPass = true

    http = {
      redirections = {
        entryPoint = {
          to        = "websecure"
          scheme    = "https"
          permanent = true
        }
      }
    }
  } : null
}
