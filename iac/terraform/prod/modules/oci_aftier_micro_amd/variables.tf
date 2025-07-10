variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
  sensitive   = true
}

variable "tenancy_ocid" {
  description = "The OCID of the tenancy"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
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

variable "disable_ssh_port" {
  description = "Disable SSH port"
  type        = bool
}

variable "availability_domain" {
  description = "Availability Domain"
  type        = string
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
