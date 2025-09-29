output "compartment_id" {
  value = oci_identity_compartment.yohapp-comp.id
}

output "instance_public_ip" {
  value = oci_core_instance.ic_pub_vm-A.public_ip
}

output "subnetA_pub_id" {
  value = oci_core_subnet.subnetA_pub.id
}

output "tenancy_ocid" {
  value = var.tenancy_ocid
}

output "availability_domain" {
  value = var.availability_domain
}

output "packer-registry-ubuntu-webapp-oci-amd" {
  value = data.hcp_packer_artifact.instance-webapp-oci-amd.external_identifier
}

## PACKER OUTPUTS

output "oci_packer_compartment_ocid" {
  value = module.packer.packer_compartment_ocid
}

output "oci_packer_subnet_ocid" {
  value = module.packer.packer_subnet_ocid
}

output "packer_compartment_ocid" {
  value = module.packer.packer_compartment_ocid
}

output "packer_subnet_ocid" {
  value = module.packer.packer_subnet_ocid
}

output "packer_user_ocid" {
  value = module.packer.packer_user_ocid
}

output "packer_user_name" {
  value = module.packer.packer_user_name
}

output "packer_group_ocid" {
  value = module.packer.packer_group_ocid
}

output "packer_api_key_fingerprint" {
  value = module.packer.packer_api_key_fingerprint
}

output "packer_private_key_path" {
  value = module.packer.packer_private_key_path
}

output "packer_public_key_path" {
  value = module.packer.packer_public_key_path
}

output "packer_oci_config_path" {
  value = module.packer.packer_oci_config_path
}

output "packer_image_name" {
  value = module.packer.packer_image_name
}

output "packer_images_to_delete_ids" {
  value = module.packer.packer_images_to_delete_ids
}

output "debug_all_images" {
  value = <<-EOT
    All Images:
  EOT 
}

output "debug_filtered_images" {
  value = module.packer.debug_filtered_images
}

output "packer_instructions" {
  value = module.packer.packer_instructions
}