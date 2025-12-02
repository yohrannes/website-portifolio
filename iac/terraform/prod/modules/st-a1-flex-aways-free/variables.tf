variable "user_email" {
  description = "The email of the user"
  type        = string
  sensitive   = true
}

variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
  sensitive   = true
}

variable "tenancy_ocid" {
  description = "The OCID of the tenancy"
  type        = string
  sensitive   = true
}

variable "compartment_name" {
  description = "Compartment Name"
  type        = string
  default     = "port-comp"
}

variable "compartment_description" {
  description = "Compartment Description"
  type        = string
  default     = "test-compartment description"
  sensitive   = true
}

variable "vcn1" {
  description = "The details of VCN1."
  default = {
    cidr_blocks : ["10.23.0.0/20"]
    display_name : "vcn01"
  }
  sensitive = true
}

variable "subnetA_pub" {
  description = "The details of the subnet"
  default = {
    cidr_block : "10.23.11.0/24"
    display_name : "IC_pub_snet-A"
    is_public : true
    route_table : {
      display_name = "routeTable-Apub"
      description  = "routeTable-Apub"
    }
  }
  sensitive = true
}

variable "internet_gateway_A" {
  type        = map(string)
  description = "The details of the internet gateway"
  default = {
    display_name : "IC_IG-A"
    ig_destination = "0.0.0.0/0"
  }
  sensitive = true
}

variable "ssh_authorized_keys_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key content for instance access"
  type        = string
  sensitive   = true
}

variable "disable_ssh_port" {
  description = "Disable SSH port"
  type        = bool
}

variable "availability_domain" {
  description = "Availability Domain"
  type        = string
}

#variable "instance_image_ocid" {
#  description = "The OCID of the Ubuntu image to use"
# type        = string
#}

variable "packer_module" {
  type        = bool
  description = "Flag to indicate if the packer module should be used"
  default     = null
}

variable "ic_pub_vm_A" {
  description = "The details of the compute instance"
  default = {
    display_name : "web-port-instance"
    availability_domain : "lIpY:US-ASHBURN-AD-1"
    assign_public_ip : true
    image_ocid : "ocid1.image.oc1.iad.aaaaaaaagxazxgs5mz5xglwm5i7a7pdphiu7f3h2u6njatz6akisfxdgjmwq"
    shape : {
      name          = "VM.Standard.A1.Flex"
      ocpus         = 1
      memory_in_gbs = 3
    }
  }
}

# PACKER CREDENTIALS

#variable "packer_oci_config_content" {
#  description = "Content of the OCI config file"
#  type        = string
#  sensitive   = true
#}
#
#variable "packer_oci_private_key_content" {
#  description = "Content of the OCI private key"
#  type        = string
#  sensitive   = true
#}
#
#variable "packer_oci_public_key_content" {
#  description = "Content of the OCI public key"
#  type        = string
#  sensitive   = true
#}