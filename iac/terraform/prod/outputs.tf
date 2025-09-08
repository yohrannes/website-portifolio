# OCI GLOBAL OUTPUTS

output "availability_domain" {
  value = var.availability_domain
}

#OCI AFTIER MICRO AMD OUTPUTS

output "oci_aftier_micro_amd_pub_ip" {
  value = module.oci_aftier_micro_amd.instance_public_ip
}

# OCI AFTIER FLEX ARM OUTPUTS

output "instance_oracle_arm_pub_ip" {
  value = module.oci_aftier_flex_arm.instance_public_ip
}

# GCP FTIER MICRO AMD OUTPUTS

output "gcp_instance_amd_public_ip" {
  value = module.gcp_ftier_micro_amd.instance_public_ip
}

# OCI OKE CLUSTER ARM OUTPUTS

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

## PACKER OUTPUTS

output "oci_packer_compartment_ocid" {
  value = module.oci_aftier_micro_amd.oci_packer_compartment_ocid
}

output "oci_packer_subnet_ocid" {
  value = module.oci_aftier_micro_amd.oci_packer_subnet_ocid
}

output "packer_compartment_ocid" {
  value = module.oci_aftier_micro_amd.packer_compartment_ocid
}

output "packer_subnet_ocid" {
  value = module.oci_aftier_micro_amd.packer_subnet_ocid
}

output "packer_user_ocid" {
  value = module.oci_aftier_micro_amd.packer_user_ocid
  sensitive = true
}

output "packer_user_name" {
  value = module.oci_aftier_micro_amd.packer_user_name
}

output "packer_group_ocid" {
  value = module.oci_aftier_micro_amd.packer_group_ocid
}

output "packer_api_key_fingerprint" {
  value = module.oci_aftier_micro_amd.packer_api_key_fingerprint
}

output "packer_private_key_path" {
  value = module.oci_aftier_micro_amd.packer_private_key_path
}

output "packer_public_key_path" {
  value = module.oci_aftier_micro_amd.packer_public_key_path
}

output "packer_oci_config_path" {
  value = module.oci_aftier_micro_amd.packer_oci_config_path
}

output "packer_image_name" {
  value = module.oci_aftier_micro_amd.packer_image_name
}

output "packer_images_to_delete_ids" {
  value = module.oci_aftier_micro_amd.packer_images_to_delete_ids
}

output "debug_all_images" {
  value = module.oci_aftier_micro_amd.debug_all_images
}

output "debug_filtered_images" {
  value = module.oci_aftier_micro_amd.debug_filtered_images
}

output "packer_instructions" {
  value = module.oci_aftier_micro_amd.packer_instructions
}