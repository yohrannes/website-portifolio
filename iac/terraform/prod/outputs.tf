output "oci_aftier_micro_amd_pub_ip" {
  value = module.oci_aftier_micro_amd.instance_public_ip
}

output "instance_oracle_arm_pub_ip" {
  value = module.oci_aftier_flex_arm.instance_public_ip
}

output "gcp_instance_amd_public_ip" {
  value = module.gcp_ftier_micro_amd.instance_public_ip
}

output "oci_oke_cluster_arm_compartment_id" {
  value = module.oci_oke_cluster_arm.compartment_id
}

output "oci_core_instances_1" {
  value = module.oci_oke_cluster_arm.oci_core_instances_1
}

output "oci_core_instances_2" {
  value = module.oci_oke_cluster_arm.oci_core_instances_2
}

output "oci_core_instances_3" {
  value = module.oci_oke_cluster_arm.oci_core_instances_3
}

output "oci_packer_compartment_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_compartment_ocid
}

output "oci_packer_subnet_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_subnet_ocid
}