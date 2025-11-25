output "instance_public_ip" {
  value = oci_core_instance.instance_specs.public_ip
}
