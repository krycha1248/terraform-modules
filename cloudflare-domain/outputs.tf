output "domain_name" {
  value = cloudflare_dns_record.recordA.name
}

output "ip_address" {
  value = cloudflare_dns_record.recordA.content
}