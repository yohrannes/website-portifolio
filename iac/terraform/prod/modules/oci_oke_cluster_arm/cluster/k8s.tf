terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
  }
}

resource "null_resource" "wait_for_cluster_deletion" {
  triggers = {
    cluster_id = oci_containerengine_cluster.k8s_cluster.id
  }

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
      echo "Checking and deleting cluster ${self.triggers.cluster_id} if necessary..."
      CURRENT_STATE=$(oci ce cluster get --cluster-id ${self.triggers.cluster_id} --query 'data.lifecycle-state' --raw-output 2>/dev/null || echo "NOT_FOUND")
      if [ "$CURRENT_STATE" != "NOT_FOUND" ] && [ "$CURRENT_STATE" != "DELETED" ]; then
        echo "Cluster in state $CURRENT_STATE. Attempting deletion..."
        oci ce cluster delete --cluster-id ${self.triggers.cluster_id} --force
      fi

      echo "Waiting for REAL deletion of cluster ${self.triggers.cluster_id}..."
      for i in {1..30}; do
        STATE=$(oci ce cluster get --cluster-id ${self.triggers.cluster_id} --query 'data.lifecycle-state' --raw-output 2>/dev/null || echo "NOT_FOUND")
        echo "Final status: $STATE"
        if [ "$STATE" = "NOT_FOUND" ] || [ "$STATE" = "DELETED" ]; then
          echo "Cluster removed!"
          exit 0
        fi
        sleep 10
      done
      echo "Timeout waiting for cluster to be removed!"
      exit 1
    EOT
    interpreter = ["/bin/sh", "-c"]
  }
  depends_on = [oci_containerengine_cluster.k8s_cluster]
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

resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "k8s-node-pool"
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
}