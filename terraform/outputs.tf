output "instance_public_ip" {
  value = module.instance_oracle_amd.instance_public_ip
}
output "instance_runner_public_ip" {
  value = module.instance_oracle_arm.instance_public_ip
}