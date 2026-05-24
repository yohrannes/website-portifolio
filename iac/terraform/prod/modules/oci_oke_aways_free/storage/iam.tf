data "oci_identity_compartment" "current_infra_compartment" {
  id = var.compartment_id
}

resource "oci_identity_dynamic_group" "cluster_nodes" {
  compartment_id = data.oci_identity_compartment.current_infra_compartment.compartment_id
  name           = "OKE-Cluster-Nodes"
  description    = "Dynamic group for OKE worker nodes"
  matching_rule  = "instance.compartment.id = '${var.compartment_id}'"
}

resource "oci_identity_policy" "cluster_storage_policy" {
  compartment_id = var.compartment_id
  name           = "OKE-Cluster-Storage-Policy"
  description    = "Allow OKE nodes to manage objects in the shared bucket"
  statements = [
    "Allow dynamic-group OKE-Cluster-Nodes to manage objects in compartment id ${var.compartment_id} where target.bucket.name='cluster-shared-bucket'"
  ]
}
