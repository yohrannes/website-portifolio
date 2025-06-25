terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 7.6.0"
    }
  }
}

locals {
  user_ocid = trimspace(data.external.user_ocid.result.user_ocid)
}

data "external" "user_ocid" {
  program = ["sh", "-c", "oci iam user list --query 'data[0].id' --raw-output | jq -R '{\"user_ocid\": .}'"]
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_identity_compartment" "yohapp-packer-comp" {
  compartment_id = var.compartment_id
  description    = var.packer_compartment_description
  name           = var.packer_compartment_name
}

resource "oci_identity_policy" "packer_policy" {
  compartment_id = var.compartment_id
  description    = "Política para permitir operações do Packer no compartment"
  name           = "packer-policy"
  
  statements = [
    "Allow group PackerGroup to manage instance-family in compartment ${oci_identity_compartment.yohapp-packer-comp.name}",
    "Allow group PackerGroup to manage instance-images in compartment ${oci_identity_compartment.yohapp-packer-comp.name}",
    "Allow group PackerGroup to use virtual-network-family in compartment ${oci_identity_compartment.yohapp-packer-comp.name}",
    "Allow group PackerGroup to use compute-image-capability-schema in tenancy",
  ]
}

resource "oci_core_vcn" "example_vcn" {
  compartment_id = oci_identity_compartment.yohapp-packer-comp.id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "packer-vcn"
}

resource "oci_identity_group" "packer_group" {
  compartment_id = var.compartment_id
  description    = "Grupo para usuários do Packer"
  name           = "PackerGroup"
}

resource "oci_identity_user_group_membership" "packer_user_membership" {
  group_id = oci_identity_group.packer_group.id
  user_id  = local.user_ocid
}

resource "oci_core_internet_gateway" "example_igw" {
  compartment_id = oci_identity_compartment.yohapp-packer-comp.id
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "packer-igw"
}

resource "oci_core_route_table" "example_rt" {
  compartment_id = oci_identity_compartment.yohapp-packer-comp.id
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "packer-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.example_igw.id
  }
}

resource "oci_core_security_list" "example_sl" {
  compartment_id = oci_identity_compartment.yohapp-packer-comp.id
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "packer-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    
    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "subnetA_pub" {
  compartment_id      = oci_identity_compartment.yohapp-packer-comp.id
  vcn_id              = oci_core_vcn.example_vcn.id
  cidr_block          = "10.0.0.0/24"
  display_name        = "packer-subnet"
  availability_domain = var.availability_domain
  route_table_id      = oci_core_route_table.example_rt.id
  security_list_ids   = [oci_core_security_list.example_sl.id]
}