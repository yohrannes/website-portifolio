locals {
  cird_block_subnets = cidrsubnet(oci_core_vcn.tf_vcn.cidr_blocks[0], 8, 0)
}

resource "oci_identity_compartment" "web-port-comp" {
  # Required
  compartment_id = var.compartment_id
  description    = var.compartment_description
  name           = var.compartment_name
}

resource "oci_core_vcn" "tf_vcn" {
  #Required
  compartment_id = oci_identity_compartment.web-port-comp.id
  cidr_blocks    = var.tf_vcn.cidr_blocks
  #Optional
  display_name = var.tf_vcn.display_name
}

resource "oci_core_subnet" "tf_subnet" {
  #Required
  compartment_id = oci_identity_compartment.web-port-comp.id
  vcn_id         = oci_core_vcn.tf_vcn.id
  #cidr_block     = var.tf_subnet.cidr_block
  cidr_block = local.cird_block_subnets
  #Optional
  security_list_ids          = [oci_core_security_list.tf_sec_list.id]
  display_name               = var.tf_subnet.display_name
  prohibit_public_ip_on_vnic = !var.tf_subnet.is_public
  prohibit_internet_ingress  = !var.tf_subnet.is_public
}

resource "oci_core_internet_gateway" "tf_int_gateway" {
  compartment_id = oci_identity_compartment.web-port-comp.id
  vcn_id         = oci_core_vcn.tf_vcn.id
  display_name   = var.tf_int_gateway.display_name
}

resource "oci_core_default_route_table" "tf_route_table" {
  compartment_id             = oci_identity_compartment.web-port-comp.id
  manage_default_resource_id = oci_core_vcn.tf_vcn.default_route_table_id
  # Optional
  display_name = var.tf_subnet.route_table.display_name
  dynamic "route_rules" {
    for_each = [true]
    content {
      destination       = var.tf_int_gateway.ig_destination
      description       = var.tf_subnet.route_table.description
      network_entity_id = oci_core_internet_gateway.tf_int_gateway.id
    }
  }
}

resource "oci_core_instance" "tf_instance" {
  compartment_id      = oci_identity_compartment.web-port-comp.id
  shape               = var.tf_instance.shape.name
  availability_domain = var.tf_instance.availability_domain
  display_name        = var.tf_instance.display_name

  source_details {
    source_id   = var.tf_instance.image_ocid
    source_type = "image"
  }

  dynamic "shape_config" {
    for_each = [true]
    content {
      #Optional
      memory_in_gbs = var.tf_instance.shape.memory_in_gbs
      ocpus         = var.tf_instance.shape.ocpus
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.tf_subnet.id
    assign_public_ip = var.tf_instance.assign_public_ip
  }

  metadata = {
    ssh_authorized_keys = local.ssh_key
    user_data           = base64encode(file("${path.module}/scripts/startup-script.sh"))
  }

}

resource "oci_core_security_list" "tf_sec_list" {
  compartment_id = oci_identity_compartment.web-port-comp.id
  vcn_id         = oci_core_vcn.tf_vcn.id
  display_name   = "Public Security List"

#  ingress_security_rules {
#    protocol = "6" # TCP
#    source   = "0.0.0.0/0"
#
#    # 80 (HTTP)
#    tcp_options {
#      min = 80
#      max = 80
#    }
#  }
#
#  ingress_security_rules {
#    protocol = "6"
#    source   = "0.0.0.0/0"
#    tcp_options {
#      min = 443
#      max = 443
#    }
#  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"
    icmp_options {
      type = 8
      code = 0
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
  }
}

