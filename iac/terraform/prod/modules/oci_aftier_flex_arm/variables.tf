variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq" # Main compartment
}

variable "compartment_name" {
  description = "Compartment Name"
  type        = string
  default     = "runner-comp"
}

variable "compartment_description" {
  description = "Compartment Description"
  type        = string
  default     = "Compartmant description ......"
}

variable "tf_vcn" {
  description = "The details of VCN."
  default = {
    cidr_blocks : ["10.1.0.0/16"]
    display_name : "tf_runner_vcn"
  }
}

variable "tf_subnet" {
  description = "The details of the subnet"
  default = {
    display_name : "GL_RUNNER_SUBNET"
    is_public : true
    route_table : {
      display_name = "tf_runner_route_table"
      description  = "tf_runner_route_table"
    }
  }
}

variable "tf_int_gateway" {
  description = "The details of the internet gateway"
  default = {
    display_name : "INT_GATEWAY"
    ig_destination = "0.0.0.0/0"
  }
}

# Needs to be same region of the cluster, same image_ocid of cluster nodes + check if that was really in aways free plan

variable "tf_gitlab_runner" {
  description = "The details of the compute instance"
  default = {
    display_name : "gitlab-runner"
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

variable "ssh_public_key" {
  description = "SSH public key content for instance access"
  type        = string
  sensitive   = true
}

locals {
  ssh_key = var.ssh_public_key
}