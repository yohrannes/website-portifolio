terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}


resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = var.public_subnet_id
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
    service_lb_subnet_ids = [var.public_subnet_id]
  }

}

resource "null_resource" "cluster_wait" {
  depends_on = [oci_containerengine_cluster.k8s_cluster]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "oci_containerengine_node_pool" "k8s_node_pool_ad1" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "k8s-node-pool-ad1"
  
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.vcn_private_subnet_id
    }
    size = 1
  }
  
  node_shape = var.shape

  node_shape_config {
    memory_in_gbs = var.memory_in_gbs_per_node
    ocpus         = var.ocpus_per_node
  }

  node_source_details {
    image_id    = var.image_id
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "k8s-cluster"
  }

  ssh_public_key = var.ssh_public_key
  
  depends_on = [null_resource.cluster_wait]
}

resource "null_resource" "wait_ad1" {
  depends_on = [oci_containerengine_node_pool.k8s_node_pool_ad1]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "oci_containerengine_node_pool" "k8s_node_pool_ad2" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "k8s-node-pool-ad2"
  
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
      subnet_id           = var.vcn_private_subnet_id
    }
    size = 1
  }
  
  node_shape = var.shape

  node_shape_config {
    memory_in_gbs = var.memory_in_gbs_per_node
    ocpus         = var.ocpus_per_node
  }

  node_source_details {
    image_id    = var.image_id
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "k8s-cluster"
  }

  ssh_public_key = var.ssh_public_key
  
  depends_on = [null_resource.wait_ad1]
}

resource "null_resource" "wait_ad2" {
  depends_on = [oci_containerengine_node_pool.k8s_node_pool_ad2]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "oci_containerengine_node_pool" "k8s_node_pool_ad3" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "k8s-node-pool-ad3"
  
  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
      subnet_id           = var.vcn_private_subnet_id
    }
    size = 1
  }
  
  node_shape = var.shape

  node_shape_config {
    memory_in_gbs = var.memory_in_gbs_per_node
    ocpus         = var.ocpus_per_node
  }

  node_source_details {
    image_id    = var.image_id
    source_type = "image"
  }

  initial_node_labels {
    key   = "name"
    value = "k8s-cluster"
  }

  ssh_public_key = var.ssh_public_key
  
  depends_on = [null_resource.wait_ad2]
}