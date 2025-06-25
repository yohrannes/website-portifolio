#variable "tenancy_ocid" {
#  description = "The OCID of the tenancy"
#  type        = string
#  default     = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
#  sensitive   = true
#}

variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
  default     = "ocid1.compartment.oc1..aaaaaaaav75d5oqcouk5wugq4cbfk76qqkpuznlhwmegh2qycud6rxapdkha"
  sensitive   = true
}

variable "packer_compartment_name" {
  description = "Compartment Name"
  type        = string
  default     = "yohapp-packer-comp"
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
  default     = "lIpY:US-ASHBURN-AD-1"
}

variable "packer_user_name" {
  description = "Nome do usuário para adicionar ao grupo PackerGroup"
  type        = string
  default     = "yohrannes"
}