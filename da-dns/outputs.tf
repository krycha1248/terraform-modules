output "record_name" {
  value = var.record_name
}

output "domain" {
  value = var.domain
}

output "dns_response" {
    value = http_request.dns_record.response_body
}
