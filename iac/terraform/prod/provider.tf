terraform {
  cloud {
    organization = "org-website-portifolio"
    workspaces {
      tags = ["credentials_google_prod", "oke_prod", "runner1_prod", "runner2_prod", "webapp_instance_prod"]
    }
  }

  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">= 8.9.0"
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
  cluster_id = module.webapp.cluster_id
}

provider "kubernetes" {
  host                   = data.oci_containerengine_cluster_kube_config.kubeconfig.host
  cluster_ca_certificate = base64decode(data.oci_containerengine_cluster_kube_config.kubeconfig.certificate_authority_data)
  token                  = data.oci_containerengine_cluster_kube_config.kubeconfig.token
}

provider "helm" {
  kubernetes {
    host                   = data.oci_containerengine_cluster_kube_config.kubeconfig.host
    cluster_ca_certificate = base64decode(data.oci_containerengine_cluster_kube_config.kubeconfig.certificate_authority_data)
    token                  = data.oci_containerengine_cluster_kube_config.kubeconfig.token
  }
}

