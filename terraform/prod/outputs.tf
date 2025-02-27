output "oci_aftier_micro_amd_pub_ip" {
  value = module.oci_aftier_micro_amd.instance_public_ip
}

output "instance_oracle_arm_pub_ip" {
  value = module.oci_aftier_flex_arm.instance_public_ip
}

output "gcp_instance_amd_public_ip" {
  value = module.instance_gcp_amd.instance_public_ip
}