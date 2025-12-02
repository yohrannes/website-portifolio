terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.106.0"
    }
  }
}

#data "hcp_packer_artifact" "instance-webapp-oci-amd" {
#  bucket_name   = "instance-webapp-oci-amd"
#  channel_name  = "latest"
#  platform      = "packer.oracle.oci"
#  region        = "us-ashburn-1"
#}
#
#locals {
#  # cmpt_name_prefix = "A506"
#  # time_f           = formatdate("HHmmss", timestamp())
#}

resource "oci_identity_compartment" "yohapp-comp" {
  # Required
  compartment_id = var.compartment_id
  description    = var.compartment_description
  #name           = "${local.cmpt_name_prefix}-${var.compartment_name}-${local.time_f}"
  name = var.compartment_name
}

resource "oci_core_vcn" "example_vcn" {
  #Required
  compartment_id = oci_identity_compartment.yohapp-comp.id
  cidr_blocks    = var.vcn1.cidr_blocks
  #Optional
  display_name = var.vcn1.display_name
}

resource "oci_core_security_list" "public-security-list" {
  compartment_id = oci_identity_compartment.yohapp-comp.id
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "Public Security List"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  dynamic "ingress_security_rules" {
    for_each = var.disable_ssh_port ? [] : [1]
    content {
      stateless   = false
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      protocol    = "6"
      tcp_options {
        min = 22
        max = 22
      }
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1  
    protocol = "1"

    # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    icmp_options {
      type = 8
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 443
      max = 443
    }
  }

}

resource "oci_core_subnet" "subnetA_pub" {
  #Required
  compartment_id = oci_identity_compartment.yohapp-comp.id
  vcn_id         = oci_core_vcn.example_vcn.id
  cidr_block     = var.subnetA_pub.cidr_block
  #Optional
  security_list_ids          = [oci_core_security_list.public-security-list.id]
  display_name               = var.subnetA_pub.display_name
  prohibit_public_ip_on_vnic = !var.subnetA_pub.is_public
  prohibit_internet_ingress  = !var.subnetA_pub.is_public
}

resource "oci_core_internet_gateway" "the_internet_gateway" {
  compartment_id = oci_identity_compartment.yohapp-comp.id
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = var.internet_gateway_A.display_name
}

resource "oci_core_default_route_table" "the_route_table" {
  compartment_id             = oci_identity_compartment.yohapp-comp.id
  manage_default_resource_id = oci_core_vcn.example_vcn.default_route_table_id
  # Optional
  display_name = var.subnetA_pub.route_table.display_name
  dynamic "route_rules" {
    for_each = [true]
    content {
      destination       = var.internet_gateway_A.ig_destination
      description       = var.subnetA_pub.route_table.description
      network_entity_id = oci_core_internet_gateway.the_internet_gateway.id
    }
  }
}

resource "oci_core_instance" "ic_pub_vm-A" {
  compartment_id      = oci_identity_compartment.yohapp-comp.id
  shape               = var.ic_pub_vm_A.shape.name
  availability_domain = var.availability_domain
  display_name        = var.ic_pub_vm_A.display_name

  source_details {
#    source_id   = data.hcp_packer_artifact.instance-webapp-oci-amd.external_identifier
    source_id   = var.ic_pub_vm_A.image_ocid
    source_type = "image"
  }

  dynamic "shape_config" {
    for_each = [true]
    content {
      #Optional
      memory_in_gbs = var.ic_pub_vm_A.shape.memory_in_gbs
      ocpus         = var.ic_pub_vm_A.shape.ocpus
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnetA_pub.id
    assign_public_ip = var.ic_pub_vm_A.assign_public_ip
  }


  metadata = {
    #ssh_authorized_keys = join("\n", [for k in local.ssh_authorized_keys : chomp(k)])
    #ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    ssh_authorized_keys = var.ssh_public_key
    #user_data           = base64encode(file("${path.module}/scripts/startup-script.sh"))
  }

}
