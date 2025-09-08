terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 7.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

locals {
  user_by_email = [
    for user in data.oci_identity_users.all_users_for_email.users :
    user if user.email == var.user_email
  ]
  user_ocid = length(local.user_by_email) > 0 ? local.user_by_email[0].id : null
  filtered_images = [
    for image in data.oci_core_images.existing_images.images :
    image if can(regex("${var.image_name}\\d{14}", image.display_name))
  ]

  sorted_times = sort([for img in local.filtered_images : img.time_created])

  sorted_images = [
    for t in local.sorted_times : 
    one([for img in local.filtered_images : img if img.time_created == t])
  ]

  images_to_delete = length(local.sorted_images) > 3 ? slice(local.sorted_images, 0, length(local.sorted_images) - 3) : []
}

data "oci_identity_users" "all_users_for_email" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "tls_private_key" "api_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "oci_identity_api_key" "user_api_key" {
  user_id   = local.user_ocid
  key_value = tls_private_key.api_key.public_key_pem
}

resource "oci_identity_compartment" "yohapp-packer-comp" {
  compartment_id = var.tenancy_ocid
  description    = var.packer_compartment_description
  name           = var.packer_compartment_name
}

resource "oci_identity_group" "packer_group" {
  compartment_id = var.tenancy_ocid
  description    = "Grupo para usuários do Packer"
  name           = "PackerGroup"
}

resource "oci_identity_user_group_membership" "packer_user_membership" {
  group_id = oci_identity_group.packer_group.id
  user_id  = local.user_ocid
}

resource "oci_identity_policy" "packer_policy" {
  compartment_id = var.tenancy_ocid
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

resource "local_file" "oci_config" {
  content         = var.oci_config_content
  filename        = var.oci_config_path
  file_permission = "0600"
  
  provisioner "local-exec" {
    command = "mkdir -p $(dirname ${var.oci_config_path})"
  }
}

resource "local_file" "private_key" {
  content         = var.oci_private_key_content
  filename        = var.oci_private_key_path
  file_permission = "0600"
  
  provisioner "local-exec" {
    command = "mkdir -p $(dirname ${var.oci_private_key_path})"
  }
}

resource "local_file" "public_key" {
  content         = var.oci_public_key_content
  filename        = var.oci_public_key_path
  file_permission = "0644"
  
  provisioner "local-exec" {
    command = "mkdir -p $(dirname ${var.oci_public_key_path})"
  }
}