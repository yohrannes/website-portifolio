data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.compartment_id
}

resource "oci_objectstorage_bucket" "cluster_shared_bucket" {
  compartment_id = var.compartment_id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "cluster-shared-bucket"
  access_type    = "NoPublicAccess"
}
