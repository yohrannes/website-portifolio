terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.31.0"
    }
  }
}

resource "null_resource" "wait_for_nlb_deletion" {
  triggers = {
    nlb_id = oci_network_load_balancer_network_load_balancer.nlb.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      echo "Waiting for REAL deletion of NLB ${self.triggers.nlb_id}..."
      for i in {1..30}; do
        STATUS=$(oci nlb network-load-balancer get --network-load-balancer-id ${self.triggers.nlb_id} --query 'data."lifecycle-state"' --raw-output 2>/dev/null || echo "NOT_FOUND")
        echo "Final status: $STATUS"
        if [ "$STATUS" = "NOT_FOUND" ] || [ "$STATUS" = "DELETED" ]; then
          echo "NLB removed!"
          exit 0
        fi
        sleep 10
      done
      echo "Timeout waiting NLB to be removed!"
      exit 1
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [oci_network_load_balancer_network_load_balancer.nlb]
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

resource "oci_network_load_balancer_backend" "nlb_backend_http" {
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set_http.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.node_port_http
  depends_on               = [oci_network_load_balancer_backend_set.nlb_backend_set_http]
  count                    = var.node_size
  target_id                = data.oci_core_instances.instances.instances[count.index].id

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_backend_set.nlb_backend_set_http.id
    ]
  }

}

resource "oci_network_load_balancer_backend" "nlb_backend_https" {
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set_https.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.node_port_https
  depends_on               = [oci_network_load_balancer_backend_set.nlb_backend_set_https]
  count                    = var.node_size
  target_id                = data.oci_core_instances.instances.instances[count.index].id

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