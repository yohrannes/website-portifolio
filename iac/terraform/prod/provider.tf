terraform {
  cloud {
    organization = "org-website-portifolio"
    workspaces {
      tags = ["credentials_web_port_dev", "oci_oke_web_port_prod", "web_port_dev"]  # Tags que correspondem às suas workspaces
    }
  }
  
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