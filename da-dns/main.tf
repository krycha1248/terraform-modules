resource "http_request" "dns_record" {
  method   = "POST"
  base_url = var.da_host
  path     = "/CMD_API_DNS_CONTROL"

  basic_auth = {
    username = var.da_user
    password = var.da_pass
  }

  request_body = "domain=${var.domain}&action=add&type=${var.record_type}&name=${var.record_name}&value=${var.record_value}"

  is_response_body_json   = false
  response_body_id_filter = "$.id"

  is_delete_enabled = true
  delete_method     = "POST"
  delete_path       = "/CMD_API_DNS_CONTROL"
  delete_headers    = {
    "Content-Type" = "application/x-www-form-urlencoded"
  }
  delete_request_body = "domain=${var.domain}&action=select&arecs0=name=${var.record_name}"
}

