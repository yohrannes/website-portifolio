terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
  }
}

resource "oci_core_security_list" "private_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  display_name = "k8s-private-subnet-sl"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  ingress_security_rules {
  protocol    = "6"
  source      = "10.0.0.0/24"
  source_type = "CIDR_BLOCK"
  stateless   = false
      tcp_options {
          max = 30594
          min = 30594
      }
  }
  ingress_security_rules {
      protocol    = "6"
      source      = "10.0.0.0/24"
      source_type = "CIDR_BLOCK"
      stateless   = false

      tcp_options {
          max = 31013
          min = 31013
      }
  }
  ingress_security_rules {
      protocol    = "6"
      source      = "10.0.0.0/24"
      source_type = "CIDR_BLOCK"
      stateless   = false

      tcp_options {
          max = 31284
          min = 31284
      }
  }
  ingress_security_rules {
      protocol    = "all"
      source      = "0.0.0.0/0"
      source_type = "CIDR_BLOCK"
      stateless   = false
  }
}

resource "oci_core_security_list" "public_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  display_name = "k8s-public-subnet-sl"

  egress_security_rules {
      destination      = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      protocol         = "all"
      stateless        = false
    }
  egress_security_rules {
      destination      = "10.0.1.0/24"
      destination_type = "CIDR_BLOCK"
      protocol         = "6"
      stateless        = false

      tcp_options {
          max = 30594
          min = 30594
        }
    }
  egress_security_rules {
      destination      = "10.0.1.0/24"
      destination_type = "CIDR_BLOCK"
      protocol         = "6"
      stateless        = false

      tcp_options {
          max = 31013
          min = 31013
        }
    }
  egress_security_rules {
      destination      = "10.0.1.0/24"
      destination_type = "CIDR_BLOCK"
      protocol         = "6"
      stateless        = false

      tcp_options {
          max = 31284
          min = 31284
        }
    }

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 80
      min = 80
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_subnet" "vcn_private_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  cidr_block     = "10.0.1.0/24"

  route_table_id             = var.nat_route_id
  security_list_ids          = [oci_core_security_list.private_subnet_sl.id]
  display_name               = "k8s-private-subnet"
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "vcn_public_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  cidr_block     = "10.0.0.0/24"

  route_table_id    = var.ig_route_id
  security_list_ids = [oci_core_security_list.public_subnet_sl.id]
  display_name      = "k8s-public-subnet"
}