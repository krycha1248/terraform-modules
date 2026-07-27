data "cloudflare_zones" "this" {
  name   = var.zone_name
  status = "active"
}

resource "cloudflare_dns_record" "recordA" {
  zone_id = data.cloudflare_zones.this.result[0].id
  name    = var.domain_name
  type    = "A"
  content = var.ip_address
  ttl     = 1
}

resource "cloudflare_dns_record" "recordCNAME" {
  count   = var.www_subdomain_enabled ? 1 : 0
  zone_id = data.cloudflare_zones.this.result[0].id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  content = cloudflare_dns_record.recordA.name
  ttl     = 1
}
