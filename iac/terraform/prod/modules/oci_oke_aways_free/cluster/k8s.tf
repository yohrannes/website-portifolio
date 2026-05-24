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

resource "time_sleep" "wait_cluster_creation" {
  depends_on      = [oci_containerengine_cluster.k8s_cluster]
  create_duration = "30s"
}

resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "k8s-node-pool"

  depends_on = [time_sleep.wait_cluster_creation]

  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.vcn_private_subnet_id
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
      subnet_id           = var.vcn_private_subnet_id
    }
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
      subnet_id           = var.vcn_private_subnet_id
    }
    size = var.node_size
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

  lifecycle {
    ignore_changes = [
      node_config_details[0].placement_configs,
    ]
  }
}

resource "time_sleep" "wait_node_pool_creation" {
  depends_on      = [oci_containerengine_node_pool.k8s_node_pool]
  create_duration = "60s"
}

data "oci_core_boot_volumes" "k8s_boot_volumes" {
  depends_on          = [time_sleep.wait_node_pool_creation]
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  filter {
    name   = "display_name"
    values = ["oke-*"]
    regex  = true
  }
}



#data "oci_core_instances" "all_instances" {
#  compartment_id = var.compartment_id
#  
#  filter {
#    name   = "display_name"
#    values = ["${oci_containerengine_cluster.k8s_cluster.name}-*"]
#    regex  = true
#  }
#}

#data "oci_core_vnic_attachments" "all_vnic_attachments" {
#  compartment_id = var.compartment_id
#  
#  filter {
#    name   = "instance_id"
#    values = data.oci_core_instances.all_instances.instances[*].id
#  }
#}
#
#locals {
#  vnic_by_instance = {
#    for att in data.oci_core_vnic_attachments.all_vnic_attachments.vnic_attachments :
#      att.instance_id => {
#        vnic_id       = att.vnic_id
#        subnet_id     = att.subnet_id
#        private_ip    = att.private_ip
#        state         = att.state
#      }
#  }
#  
#  all_node_pool_instances = [
#    for inst in data.oci_core_instances.all_instances.instances : {
#      instance_id     = inst.id
#      instance_name   = inst.display_name
#      instance_state  = inst.state
#      primary_vnic    = inst.primary_vnic_id
#      primary_subnet  = inst.primary_subnet_id
#      availability_domain = inst.availability_domain
#      vnic_status     = try(local.vnic_by_instance[inst.id].state, "UNKNOWN")
#      vnic_ip         = try(local.vnic_by_instance[inst.id].private_ip, "")
#      vnic_subnet     = try(local.vnic_by_instance[inst.id].subnet_id, "")
#    }
#  ]
#}