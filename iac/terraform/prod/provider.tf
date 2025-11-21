terraform {
  cloud {
    organization = "org-website-portifolio"
    workspaces {
      tags = ["credentials_google_prod", "oke_prod", "runner1_prod", "runner2_prod", "webapp_instance_prod"]
    }
  }

  required_providers {

    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.106.0"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.oci_tenancy_ocid
  user_ocid    = var.oci_user_ocid
  fingerprint  = var.oci_fingerprint
  private_key  = var.oci_private_key
  region       = var.oci_region
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}