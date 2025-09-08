variable "user_email" {
  description = "The email of the user"
  type        = string
}

variable "tenancy_ocid" {
  description = "The OCID of the tenancy"
  type        = string
}

variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "packer_compartment_name" {
  description = "Compartment Name"
  type        = string
}

variable "packer_compartment_description" {
  description = "Compartment Description"
  type        = string
  default     = "test-compartment description"
  sensitive   = true
}

variable "availability_domain" {
  description = "Availability Domain"
  type        = string
}

variable "packer_user_name" {
  description = "Nome do usuário para adicionar ao grupo PackerGroup"
  type        = string
  default     = "yohrannes"
}

variable "image_name" {
  description = "Nome do grupo PackerGroup"
  type        = string
}

# PACKER CREDENTIALS

variable "oci_config_content" {
  description = "Content of the OCI config file"
  type        = string
  sensitive   = true
}

variable "oci_private_key_content" {
  description = "Content of the OCI private key"
  type        = string
  sensitive   = true
}

variable "oci_public_key_content" {
  description = "Content of the OCI public key"
  type        = string
  sensitive   = true
}

variable "oci_config_path" {
  description = "Path where OCI config should be stored"
  type        = string
  default     = "/tmp/.oci/config"
}

variable "oci_private_key_path" {
  description = "Path where OCI private key should be stored"
  type        = string
  default     = "/tmp/.oci/private_key.pem"
}

variable "oci_public_key_path" {
  description = "Path where OCI public key should be stored"
  type        = string
  default     = "/tmp/.oci/public_key.pem"
}