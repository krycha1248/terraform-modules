resource "ovh_cloud_project_network_private" "private_network" {
  service_name = var.service_name
  vlan_id      = var.vlan_id
  name         = var.network_name
  regions      = var.regions
}

resource "ovh_cloud_project_network_private_subnet" "private_subnet" {
  service_name = ovh_cloud_project_network_private.private_network.service_name
  network_id   = ovh_cloud_project_network_private.private_network.id
  region       = var.regions[0]
  start        = var.network_start_address
  end          = var.network_end_address
  network      = var.network_cidr
  dhcp         = true
}

resource "ovh_cloud_project_gateway" "gateway" {
  service_name = ovh_cloud_project_network_private.private_network.service_name
  name         = var.gateway_name
  model        = var.gateway_model
  region       = var.regions[0]
  network_id   = tolist(ovh_cloud_project_network_private.private_network.regions_attributes[*].openstackid)[0]
  subnet_id    = ovh_cloud_project_network_private_subnet.private_subnet.id
}
