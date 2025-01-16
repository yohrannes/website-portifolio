output "instance_public_ip" {
  value       = oci_core_instance.tf_gitlab_runner.public_ip
}
