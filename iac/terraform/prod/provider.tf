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
      version = ">= 8.16.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.106.0"
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

data "oci_containerengine_cluster_kube_config" "kubeconfig" {
  cluster_id    = module.webapp.cluster_id
  token_version = "2.0.0"
}

variable "oke_token" {
  type    = string
  default = ""
}

locals {
  # Extração manual do YAML para evitar o erro de 'Unsupported attribute'
  k8s_config = yamldecode(data.oci_containerengine_cluster_kube_config.kubeconfig.content)
}

provider "kubernetes" {
  host                   = local.k8s_config["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(local.k8s_config["clusters"][0]["cluster"]["certificate-authority-data"])
  token                  = var.oke_token
}

provider "helm" {
  kubernetes {
    host                   = local.k8s_config["clusters"][0]["cluster"]["server"]
    cluster_ca_certificate = base64decode(local.k8s_config["clusters"][0]["cluster"]["certificate-authority-data"])
    token                  = var.oke_token
  }
}
