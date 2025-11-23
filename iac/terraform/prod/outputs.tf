# GCP OUTPUTS

output "runner2_pub_ip" {
  description = "The public IP address of the GCP FREE TIER MICRO AMD (Gitlab Runner instance)"
  value       = module.runner2.instance_public_ip
}

# OCI OUTPUTS

output "runner1_pub_ip" {
  description = "The public IP address of the OCI AWAYS FREE MICRO AMD (Gitlab Runner instance)"
  value       = module.runner1.instance_public_ip
}

output "availability_domain" {
  description = "The availability domain used for the resources"
  value       = var.availability_domain
}

output "oci_aftier_micro_amd_pub_ip" {
  description = "The public IP address of the OCI AFTIER FLEX ARM (Portifolio Website instance)"
  value       = module.oci_aftier_micro_amd.instance_public_ip
}

# OKE CLUSTER ARM OUTPUTS

output "oci_oke_cluster_arm_compartment_id" {
  description = "The compartment ID where the OKE cluster is deployed"
  value       = module.oci_oke_cluster_arm.compartment_id
}

output "oci_core_instances_1" {
  description = "The list of OCIDs for the first set of compute instances in the OKE cluster"
  value       = module.oci_oke_cluster_arm.oci_core_instances_1
}

output "oci_core_instances_2" {
  description = "The list of OCIDs for the second set of compute instances in the OKE cluster"
  value       = module.oci_oke_cluster_arm.oci_core_instances_2
}

output "oci_core_instances_3" {
  description = "The list of OCIDs for the third set of compute instances in the OKE cluster"
  value       = module.oci_oke_cluster_arm.oci_core_instances_3
}

## PACKER OUTPUTS

#output "oci_packer_compartment_ocid" {
#  description = "The OCID of the compartment created for Packer resources"
#  value = module.oci_aftier_micro_amd.oci_packer_compartment_ocid
#}
#
#output "oci_packer_subnet_ocid" {
#  description = "The OCID of the subnet created for Packer resources"
#  value = module.oci_aftier_micro_amd.oci_packer_subnet_ocid
#}

output "packer_compartment_ocid" {
  description = "The OCID of the compartment used for Packer operations"
  value       = module.oci_aftier_micro_amd.packer_compartment_ocid
}

output "packer_subnet_ocid" {
  description = "The OCID of the subnet used for Packer operations"
  value       = module.oci_aftier_micro_amd.packer_subnet_ocid
}

#output "packer_user_ocid" {
#  value     = module.oci_aftier_micro_amd.packer_user_ocid
#  sensitive = true
#}

#output "packer_user_name" {
#  value = module.oci_aftier_micro_amd.packer_user_name
#}

#output "packer_group_ocid" {
#  value = module.oci_aftier_micro_amd.packer_group_ocid
#}

#output "packer_api_key_fingerprint" {
#  value = module.oci_aftier_micro_amd.packer_api_key_fingerprint
#}

#output "packer_private_key_path" {
#  value = module.oci_aftier_micro_amd.packer_private_key_path
#}

#output "packer_public_key_path" {
#  value = module.oci_aftier_micro_amd.packer_public_key_path
#}

#output "packer_oci_config_path" {
#  value = module.oci_aftier_micro_amd.packer_oci_config_path
#}

output "packer_image_name" {
  value = module.oci_aftier_micro_amd.packer_image_name
}

#output "debug_all_images" {
#  value = module.oci_aftier_micro_amd.debug_all_images
#}
#
#output "debug_filtered_images" {
#  value = module.oci_aftier_micro_amd.debug_filtered_images
#}

output "packer_instructions" {
  value = module.oci_aftier_micro_amd.packer_instructions
}