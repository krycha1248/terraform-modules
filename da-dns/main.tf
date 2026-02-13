locals {
  # Mapowanie typu rekordu do nazwy pola w API DirectAdmin
  selecttype_map = {
    A     = "arecs0"
    AAAA  = "arecs0"
    CNAME = "cnamerecs0"
    MX    = "mxrecs0"
    NS    = "nsrecs0"
    PTR   = "ptrrecs0"
    TXT   = "txtrecs0"
  }

  # Logika budowy ciała requestu do usunięcia rekordu
  delete_body = var.record_type == "CNAME" ? format(
    "domain=%s&action=select&cnamerecs0=name=%s&value=%s",
    var.domain,
    urlencode(var.record_name),
    urlencode(var.record_value)
  ) : format(
    "domain=%s&action=select&%s=name%%3D%s%%26value%%3D%s",
    var.domain,
    lookup(local.selecttype_map, var.record_type, "arecs0"),
    urlencode(var.record_name),
    urlencode(var.record_value)
  )
}

resource "http_request" "dns_record" {
  # DirectAdmin API endpoint
  method   = "POST"
  base_url = var.da_host
  path     = "/CMD_API_DNS_CONTROL"

  basic_auth = {
    username = var.da_user
    password = var.da_pass
  }

  # Tworzenie rekordu
  request_body = format(
    "domain=%s&action=add&type=%s&name=%s&value=%s%s%s",
    var.domain,
    var.record_type,
    urlencode(var.record_name),
    urlencode(var.record_value),
    var.record_ttl != null ? "&ttl=${var.record_ttl}" : "",
    var.record_priority != null && var.record_type == "MX" ? "&mx_priority=${var.record_priority}" : ""
  )

  is_response_body_json   = false
  response_body_id_filter = "$.id"

  # Usuwanie rekordu
  is_delete_enabled = true
  delete_method     = "POST"
  delete_path       = "/CMD_API_DNS_CONTROL"
  delete_headers    = {
    "Content-Type" = "application/x-www-form-urlencoded"
  }
  delete_request_body = local.delete_body

  # Retry w przypadku problemów z API (opcjonalnie)
  retries = 3
  retry_delay = 5
}
