terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  # Will use automatically ~/.oci/config with profile DEFAULT
}