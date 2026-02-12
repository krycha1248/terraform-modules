locals {
  selecttype_map = {
    A     = "arecs0"
    CNAME = "cnamerecs0"
    MX    = "mxrecs0"
    NS    = "nsrecs0"
    PTR   = "ptrrecs0"
  }
}

resource "http_request" "dns_record" {
  method   = "POST"
  base_url = var.da_host
  path     = "/CMD_API_DNS_CONTROL"

  basic_auth = {
    username = var.da_user
    password = var.da_pass
  }

  # Tworzenie rekordu
  request_body = "domain=${var.domain}&action=add&type=${var.record_type}&name=${var.record_name}&value=${var.record_value}"

  is_response_body_json   = false
  response_body_id_filter = "$.id"

  # Usuwanie rekordu
  is_delete_enabled = true
  delete_method     = "POST"
  delete_path       = "/CMD_API_DNS_CONTROL"
  delete_headers    = {
    "Content-Type" = "application/x-www-form-urlencoded"
  }

  delete_request_body = var.record_type == "CNAME" ? format(
    "domain=%s&action=select&cnamerecs0=name=%s&value=%s",
    var.domain,
    var.record_name,
    var.record_value
  ) : format(
    "domain=%s&action=select&%s=name%%3D%s%%26value%%3D%s",
    var.domain,
    lookup(local.selecttype_map, var.record_type, "arecs0"),
    replace(var.record_name, ".", "%2E"),
    var.record_value
  )
}
