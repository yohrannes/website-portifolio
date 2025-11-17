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
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.106.0"
    }
  }
}

provider "oci" {
  # Will use automatically ~/.oci/config with profile DEFAULT
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

provider "aws" {
  region = "us-east-1"
}