variable "record_type" {
  description = "Typ rekordu DNS (A, CNAME, MX, NS, PTR)"
  type        = string
}

variable "record_name" {
  description = "Nazwa rekordu DNS"
  type        = string
}

variable "record_value" {
  description = "Wartość rekordu DNS"
  type        = string
}

# Mapa typów rekordów → parametry selecttype w API DirectAdmin
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
  delete_request_body = "domain=${var.domain}&action=select&${lookup(local.selecttype_map, var.record_type, "arecs0")}=" 
    # dodajemy zakodowaną nazwę i wartość
    "${replace(var.record_name, ".", "%2E")}%26value%3D${var.record_value}"
}
