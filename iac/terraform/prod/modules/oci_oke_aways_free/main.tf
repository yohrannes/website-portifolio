terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

module "storage" {
  source         = "./storage"
  compartment_id = var.compartment_id
  tenancy_id     = var.tenancy_id
  namespace      = var.namespace
}
