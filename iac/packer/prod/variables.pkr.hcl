locals {
  debug = var.tenancy_ocid
}

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "subnet_ocid" {}

variable "availability_domain" {
  type        = string
  description = "Availability Domain"
  default     = "lIpY:US-ASHBURN-AD-1"
}
