resource "openstack_compute_instance_v2" "instance" {
  provider     = openstack.ovh
  flavour_name = var.flavour_name
  key_pair     = var.key_pair
  image_name   = var.image_name
  name         = var.name
  network = {
    name = var.network_name
  }
}
