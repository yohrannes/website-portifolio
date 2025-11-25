
# GENERAL VARIABLES

variable "disable_ssh_port" {
  description = "Disable SSH port"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "SSH public key content for instance access"
  type        = string
  sensitive   = true
}

# HCP PACKER CREDENTIALS

variable "hcp_client_id" {
  description = "HCP Client ID"
  type        = string
  sensitive   = true
}

variable "hcp_client_secret" {
  description = "HCP Client Secret"
  type        = string
  sensitive   = true
}

# GCP CREDENTIALS

variable "project_id" {
  description = "The project ID"
  type        = string
  default     = "website-portifolio"
}

# OCI CREDENTIALS

variable "availability_domain" {
  description = "The availability domain to use for the resources"
  type        = string
  default     = "lIpY:US-ASHBURN-AD-3"
}

variable "oci_tenancy_ocid" {
  description = "The OCID of the OCI tenancy"
  type        = string
  sensitive   = true
}

variable "oci_user_ocid" {
  description = "The OCID of the OCI user"
  type        = string
  sensitive   = true
}

variable "oci_fingerprint" {
  description = "The fingerprint of the OCI API key"
  type        = string
  sensitive   = true
}

variable "oci_private_key" {
  description = "The OCI API private key content"
  type        = string
  sensitive   = true
}

variable "oci_region" {
  description = "The OCI region"
  sensitive   = true
}

# OCI PACKER CREDENTIALS

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