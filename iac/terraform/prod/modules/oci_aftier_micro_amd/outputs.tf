output "compartment_id" {
  value = oci_identity_compartment.yohapp-comp.id
}

output "instance_public_ip" {
  value = oci_core_instance.ic_pub_vm-A.public_ip
}

output "subnetA_pub_id" {
  value = oci_core_subnet.subnetA_pub.id
}

#output "module_path" {
#  value = path.module
#}
