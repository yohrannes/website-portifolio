output "instance_public_ip" {
  value = oci_core_instance.tf_instance.public_ip
}
