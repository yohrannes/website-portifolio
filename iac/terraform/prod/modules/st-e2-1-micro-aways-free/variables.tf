variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "compartment_name" {
  description = "Compartment Name"
  type        = string
}

variable "compartment_description" {
  description = "Compartment Description"
  type        = string
  default     = "Compartmant description ......"
}

variable "vcn" {
  description = "The details of VCN."
  type = object({
    cidr_blocks  = list(string)
    display_name = string
  })
  default = {
    cidr_blocks : ["10.1.0.0/16"]
    display_name : "tf_web_vcn"
  }
}

variable "subnet" {
  description = "The details of the subnet"
  type = object({
    display_name = string
    is_public    = bool
    route_table = object({
      display_name = string
      description  = string
    })
  })
  default = {
    display_name : "RUNNER1_SUBNET"
    is_public : true
    route_table : {
      display_name = "runner1_route_table"
      description  = "runner1_route_table"
    }
  }
}

variable "int_gateway" {
  description = "The details of the internet gateway"
  type = object({
    display_name   = string
    ig_destination = string
  })
  default = {
    display_name : "INT_GATEWAY"
    ig_destination = "0.0.0.0/0"
  }
}

# Needs to be same region of the cluster, same image_ocid of cluster nodes + check if that was really in aways free plan

variable "instance_specs" {
  description = "The details of the compute instance"
  type = object({
    display_name        = string
    availability_domain = string
    assign_public_ip    = bool
    image_ocid          = string
    shape = object({
      name          = string
      ocpus         = number
      memory_in_gbs = number
    })
  })
  default = {
    display_name : "runner1"
    availability_domain : "lIpY:US-ASHBURN-AD-3"
    assign_public_ip : true
    image_ocid : "ocid1.image.oc1.iad.aaaaaaaaz7br7vztzzjvyfxiqbu2fumsuegfkofpyeapf7tamqxpwmyt5ygq" # images in https://docs.oracle.com/en-us/iaas/images/
    #image_ocid : "ocid1.image.oc1.iad.aaaaaaaa2bulxukxsjyv3ap3x45eueiqxxpxpsfrv6qppq7xrwtiima2c2pq" # images in https://docs.oracle.com/en-us/iaas/images/
    shape : {
      name          = "VM.Standard.E2.1.Micro"
      ocpus         = 1
      memory_in_gbs = 1
    }
  }
}

variable "ssh_public_key" {
  description = "SSH public key content for instance access"
  type        = string
  sensitive   = true
}

locals {
  ssh_key = var.ssh_public_key
}