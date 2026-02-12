resource "openstack_compute_instance_v2" "instance" {
  flavor_name = var.flavor_name
  key_pair     = var.key_pair
  image_name   = var.image_name
  name         = var.name
  network = {
    name = var.network_name
  }
}
