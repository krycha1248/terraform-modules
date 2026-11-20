resource "ovh_cloud_project_kube" "cluster" {
  service_name       = var.service_name
  name               = var.cluster_name
  region             = var.region
  private_network_id = ovh_cloud_network_private_vrack.private_network.id
  nodes_subnet_id    = ovh_cloud_network_private_vrack_subnet.private_subnet.id

  private_network_configuration {
    default_vrack_gateway              = ovh_cloud_network_private_vrack_subnet.private_subnet.current_state.gateway_ip
    private_network_routing_as_default = true
  }
}

resource "ovh_cloud_project_kube_nodepool" "node_pool_1" {
  service_name  = ovh_cloud_project_kube.cluster.service_name
  kube_id       = ovh_cloud_project_kube.cluster.id
  name          = var.node_pool_name
  flavor_name   = var.node_pool_flavor
  desired_nodes = var.node_pool_desired_nodes
}
