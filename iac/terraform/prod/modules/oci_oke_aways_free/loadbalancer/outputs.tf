output "load_balancer_public_ip" {
  value = oci_network_load_balancer_network_load_balancer.nlb.ip_addresses[0].ip_address
}

output "oci_core_instances_1" {
  value = data.oci_core_instances.instances.instances[0].id
}

output "oci_core_instances_2" {
  value = data.oci_core_instances.instances.instances[1].id
}

output "oci_core_instances_3" {
  value = data.oci_core_instances.instances.instances[2].id
}