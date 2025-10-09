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

output "packer_api_key_fingerprint" {
  value = oci_identity_api_key.user_api_key.fingerprint
}

output "packer_private_key_path" {
  value = local_file.private_key.filename
}

output "packer_public_key_path" {
  value = local_file.public_key.filename
}

output "packer_oci_config_path" {
  value = local_file.oci_config.filename
}

output "packer_image_name" {
  value = var.image_name
}

output "packer_instructions" {
  value = <<-EOT
    Packer Instructions:

    1. Config file: ${local_file.oci_config.filename}
    2. Private key path: ${local_file.private_key.filename}
    3. API fingerprint: ${oci_identity_api_key.user_api_key.fingerprint}

    Set this on packer:
    - config_file_profile: "DEFAULT"
    - or set the env vars:
      export OCI_CONFIG_FILE="${local_file.oci_config.filename}"
  EOT
}