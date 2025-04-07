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