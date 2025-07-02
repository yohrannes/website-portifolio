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

## OCI AFTIER MICRO AMD OUTPUTS

output "availability_domain" {
  value = module.oci_aftier_micro_amd.availability_domain
}


## PACKER OUTPUTS

output "oci_packer_compartment_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_compartment_ocid
}

output "oci_packer_subnet_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_subnet_ocid
}

output "packer_compartment_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_compartment_ocid
}

output "packer_subnet_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_subnet_ocid
}

output "packer_user_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_user_ocid
}

output "packer_user_name" {
  value = module.oci_aftier_micro_amd_packer_image.packer_user_name
}

output "packer_group_ocid" {
  value = module.oci_aftier_micro_amd_packer_image.packer_group_ocid
}

output "api_key_fingerprint" {
  value = module.oci_aftier_micro_amd_packer_image.api_key_fingerprint
}

output "private_key_path" {
  value = module.oci_aftier_micro_amd_packer_image.private_key_path
}

output "public_key_path" {
  value = module.oci_aftier_micro_amd_packer_image.public_key_path
}

output "oci_config_path" {
  value = module.oci_aftier_micro_amd_packer_image.oci_config_path
}

output "packer_instructions" {
  value = <<-EOT
    Packer Instructions:

    1. Config file: ${module.oci_aftier_micro_amd_packer_image.oci_config_path}
    2. Private key path: ${module.oci_aftier_micro_amd_packer_image.private_key_path}
    3. API fingerprint: ${module.oci_aftier_micro_amd_packer_image.api_key_fingerprint}
    
    Set this on packer:
    - config_file_profile: "DEFAULT"
    - or set the env vars: ${module.oci_aftier_micro_amd_packer_image.oci_config_path} and ${module.oci_aftier_micro_amd_packer_image.private_key_path}
      export OCI_CONFIG_FILE="${module.oci_aftier_micro_amd_packer_image.oci_config_path}"
  EOT
}