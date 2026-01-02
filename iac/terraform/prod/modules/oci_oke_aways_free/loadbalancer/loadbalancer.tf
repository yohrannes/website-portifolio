terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}



data "oci_core_instances" "instances" {
  compartment_id = var.compartment_id
}

resource "oci_network_load_balancer_network_load_balancer" "nlb" {
  compartment_id = var.compartment_id
  display_name   = "k8s-nlb"
  subnet_id      = var.public_subnet_id

  is_private                     = false
  is_preserve_source_destination = false
}

resource "oci_network_load_balancer_backend_set" "nlb_backend_set_http" {
  health_checker {
    protocol = "TCP"
  }
  name                     = "k8s-backend-set-http"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  policy                   = "FIVE_TUPLE"
  depends_on               = [oci_network_load_balancer_network_load_balancer.nlb]

  is_preserve_source = false

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_network_load_balancer.nlb.id
    ]
  }
}

resource "oci_network_load_balancer_backend_set" "nlb_backend_set_https" {
  health_checker {
    protocol = "TCP"
  }
  name                     = "k8s-backend-set-https"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  policy                   = "FIVE_TUPLE"
  depends_on               = [oci_network_load_balancer_network_load_balancer.nlb]

  is_preserve_source = false

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_network_load_balancer.nlb.id
    ]
  }
}

resource "time_sleep" "wait_before_http_backends" {
  create_duration = "10s"
  depends_on      = [oci_network_load_balancer_backend_set.nlb_backend_set_http]
}

resource "time_sleep" "wait_between_http_backends" {
  for_each        = { for i in range(var.node_size) : tostring(i) => i }
  create_duration = "5s"

  depends_on = [time_sleep.wait_before_http_backends]
}

resource "oci_network_load_balancer_backend" "nlb_backend_http" {
  for_each = { for i in range(var.node_size) : tostring(i) => data.oci_core_instances.instances.instances[i].id }

  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set_http.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.node_port_http
  target_id                = each.value

  depends_on = [time_sleep.wait_between_http_backends]

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_backend_set.nlb_backend_set_http.id
    ]
  }
}

resource "time_sleep" "wait_before_https_backends" {
  create_duration = "10s"
  depends_on      = [oci_network_load_balancer_backend_set.nlb_backend_set_https, oci_network_load_balancer_backend.nlb_backend_http]
}

resource "time_sleep" "wait_between_https_backends" {
  for_each        = { for i in range(var.node_size) : tostring(i) => i }
  create_duration = "5s"

  depends_on = [time_sleep.wait_before_https_backends]
}

resource "oci_network_load_balancer_backend" "nlb_backend_https" {
  for_each = { for i in range(var.node_size) : tostring(i) => data.oci_core_instances.instances.instances[i].id }

  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set_https.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.node_port_https
  target_id                = each.value

  depends_on = [time_sleep.wait_between_https_backends]

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_backend_set.nlb_backend_set_https.id
    ]
  }
}

resource "oci_network_load_balancer_listener" "nlb_listener_http" {
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_backend_set_http.name
  name                     = "k8s-nlb-listener_http"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.listener_port_http
  protocol                 = "TCP"
  depends_on               = [oci_network_load_balancer_backend.nlb_backend_http]
}

resource "oci_network_load_balancer_listener" "nlb_listener_https" {
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_backend_set_https.name
  name                     = "k8s-nlb-listener-https"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.listener_port_https
  protocol                 = "TCP"
  depends_on               = [oci_network_load_balancer_backend.nlb_backend_https]
}