output "oracle_instance_amd_public_ip" {
  value = module.instance_oracle_amd.instance_public_ip
}

output "oracle_instance_arm_runner_public_ip" {
  value = module.instance_oracle_arm.instance_public_ip
}

output "gcp_instance_amd_public_ip" {
  value = module.instance_gcp_amd.instance_public_ip
}