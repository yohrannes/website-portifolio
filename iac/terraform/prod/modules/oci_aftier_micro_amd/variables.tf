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
    display_name : "pub_vm-A"
    assign_public_ip : true
    image_ocid : "ocid1.image.oc1.iad.aaaaaaaa2bulxukxsjyv3ap3x45eueiqxxpxpsfrv6qppq7xrwtiima2c2pq" # images in https://docs.oracle.com/en-us/iaas/images/
    shape : {
      name          = "VM.Standard.E2.1.Micro"
      ocpus         = 1
      memory_in_gbs = 1
    }
  }
}
