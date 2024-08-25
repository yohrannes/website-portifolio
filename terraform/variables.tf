variable "compartment_id" {
  description = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
  type        = string
}

variable "compartment_name" {
  description = "Compartment Name"
  type        = string
  default     = "yohapp"
}

variable "compartment_description" {
  description = "Compartment Description"
  type        = string
  default     = "test-compartment description"
}

variable "vcn1" {
  description = "The details of VCN1."
  default = {
    cidr_blocks : ["10.23.0.0/20"]
    display_name : "vcn01"
  }
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
}

variable "internet_gateway_A" {
  description = "The details of the internet gateway"
  default = {
    display_name : "IC_IG-A"
    ig_destination = "0.0.0.0/0"
  }
}

variable "ssh_authorized_keys_path" {
  description = "~/.ssh/id_rsa.pub"
  type        = string
}

variable "ic_pub_vm_A" {
  description = "The details of the compute instance"
  default = {
    display_name : "pub_vm-A"
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