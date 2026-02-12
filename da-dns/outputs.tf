output "record_name" {
  value = var.record_name
}

output "domain" {
  value = var.domain
}

output "record_value" {
  value = var.record_value
}

output "dns_response" {
    value = http_request.dns_record.response_body
}
