terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 8.16.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.0"
    }
  }
}
