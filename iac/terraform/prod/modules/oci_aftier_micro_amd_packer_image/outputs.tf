output "packer_compartment_ocid" {
  value = oci_identity_compartment.yohapp-packer-comp.id
}

output "packer_subnet_ocid" {
  value = oci_core_subnet.subnetA_pub.id
}

output "packer_user_ocid" {
  value = local.user_ocid
}

output "packer_user_name" {
  value = var.packer_user_name
}

output "packer_group_ocid" {
  value = oci_identity_group.packer_group.id
}