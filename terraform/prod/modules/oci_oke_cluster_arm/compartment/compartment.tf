terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
  }
}

resource "oci_identity_compartment" "_" {
  name          = var.compartment_name
  description   = var.compartment_name
  enable_delete = false
}
