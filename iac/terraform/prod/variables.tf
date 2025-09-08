variable "project_id" {
  description = "The project ID"
  type        = string
  default = "website-portifolio"
}

variable "disable_ssh_port" {
  description = "Disable SSH port"
  type        = bool
  default     = false
}

variable "availability_domain" {
  description = "The availability domain to use for the resources"
  type        = string
  default     = "lIpY:US-ASHBURN-AD-3"
}

variable "ssh_public_key" {
  description = "SSH public key content for instance access"
  type        = string
  sensitive   = true
}

# PACKER CREDENTIALS

variable "packer_oci_config_content" {
  description = "Content of the OCI config file"
  type        = string
  sensitive   = true
}

variable "packer_oci_private_key_content" {
  description = "Content of the OCI private key"
  type        = string
  sensitive   = true
}

variable "packer_oci_public_key_content" {
  description = "Content of the OCI public key"
  type        = string
  sensitive   = true
}