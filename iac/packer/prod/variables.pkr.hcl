variable "user" {
  type        = string
  description = "Default instance user"
  default     = "ubuntu"
}

variable "compartment_ocid" {
  type        = string
  description = "OCID do compartment onde a instância será criada"
}

variable "availability_domain" {
  type        = string
  description = "Domínio de disponibilidade onde a instância será criada"
  default     = "lIpY:US-ASHBURN-AD-3"
}

variable "subnet_ocid" {
  type        = string
  description = "OCID da subnet onde a instância será criada"
}

variable "key_file" {
  type        = string
  description = "Caminho para o arquivo de chave privada OCI"
  default     = "/root/.oci/oci_api_key.pem"
}