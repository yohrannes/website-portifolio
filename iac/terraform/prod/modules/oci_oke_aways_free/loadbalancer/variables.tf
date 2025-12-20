locals {
  # Cria um map de instances para uso com for_each
  # Formato: { "0" => "ocid1.instance...", "1" => "ocid1.instance...", ... }
  backend_instances = { 
    for idx, instance in data.oci_core_instances.instances.instances : 
      tostring(idx) => instance.id 
  }
}

variable "namespace" {
}

variable "node_pool_id" {
}

variable "compartment_id" {
}

variable "public_subnet_id" {
}

variable "node_size" {
}

variable "node_port_http" {
}

variable "node_port_https" {
}

variable "listener_port_http" {
}

variable "listener_port_https" {
}