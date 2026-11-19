resource "ovh_cloud_network_private_vrack" "private_network" {
  service_name = var.service_name
  vlan_id      = var.vlan_id
  name         = var.network_name
  region       = var.region
}

resource "ovh_cloud_network_private_vrack_subnet" "private_subnet" {
  cidr         = var.network_cidr
  name         = var.subnet_name
  service_name = ovh_cloud_network_private_vrack.private_network.service_name
  network_id   = ovh_cloud_network_private_vrack.private_network.id
  region       = var.region
  dhcp_enabled = var.dhcp_enabled
  allocation_pools = [ 
    {
      start = var.network_start_address
      end   = var.network_end_address
    }
  ]
}

resource "ovh_cloud_project_gateway" "gateway" {
  service_name = ovh_cloud_network_private_vrack.private_network.service_name
  name         = var.gateway_name
  model        = var.gateway_model
  region       = var.regions[0]
  network_id   = tolist(ovh_cloud_network_private_vrack.private_network.regions_attributes[*].openstackid)[0]
  subnet_id    = ovh_cloud_network_private_vrack_subnet.private_subnet.id
}
