variable "compartment_ocid" {
  type        = string
  description = "OCID do compartment onde a instância será criada"
}

variable "availability_domain" {
  type        = string
  description = "Domínio de disponibilidade onde a instância será criada"
}

variable "subnet_ocid" {
  type        = string
  description = "OCID da subnet onde a instância será criada"
}