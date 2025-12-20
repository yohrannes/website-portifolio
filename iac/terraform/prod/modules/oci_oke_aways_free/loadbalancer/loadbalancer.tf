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

## Task:
#### delete load balancer before NLB deletion

# Bug available on OCI
# Error: 409-Conflict, Invalid State Transition of NLB lifeCycle state from Updating to Updating
# Solution: Serialize backend creation with time_sleep resources and use for_each instead of count

# ============================================================================
# DATA SOURCES
# ============================================================================

data "oci_core_instances" "instances" {
  compartment_id = var.compartment_id
}

# ============================================================================
# CLEANUP PROVISIONER (only runs on destroy)
# ============================================================================

resource "null_resource" "wait_for_nlb_deletion" {
  triggers = {
    nlb_id = oci_network_load_balancer_network_load_balancer.nlb.id
  }
  
  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
      export COMPARTMENT_ID=$(terraform output oci_oke_cluster_arm_compartment_id | sed 's/"//g')

      echo "Checking for any non-NLB load balancers in compartment $COMPARTMENT_ID..."
      
      LB_IDS=$(oci lb load-balancer list --compartment-id $COMPARTMENT_ID --query 'data[].id' --raw-output)
      if [ -n "$LB_IDS" ]; then
        for LB_ID in $LB_IDS; do
          echo "Deleting load balancer $LB_ID..."
          oci lb load-balancer delete --load-balancer-id $LB_ID --force
        done
      else
        echo "No non-NLB load balancers found."
      fi

      # Now handle the NLB
      echo "Checking and deleting NLB ${self.triggers.nlb_id} if necessary..."
      CURRENT_STATE=$(oci nlb network-load-balancer get --network-load-balancer-id ${self.triggers.nlb_id} --query 'data."lifecycle-state"' --raw-output 2>/dev/null || echo "NOT_FOUND")
      if [ "$CURRENT_STATE" != "NOT_FOUND" ] && [ "$CURRENT_STATE" != "DELETED" ]; then
        echo "NLB in state $CURRENT_STATE. Try deleting..."
        oci nlb network-load-balancer delete --network-load-balancer-id ${self.triggers.nlb_id} --force
      fi

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
      echo "Timeout waiting for NLB to be removed!"
      exit 1
    EOT
    interpreter = ["/bin/sh", "-c"]
  }
  
  depends_on = [oci_network_load_balancer_network_load_balancer.nlb]
}

# ============================================================================
# NETWORK LOAD BALANCER
# ============================================================================

resource "oci_network_load_balancer_network_load_balancer" "nlb" {
  compartment_id = var.compartment_id
  display_name   = "k8s-nlb"
  subnet_id      = var.public_subnet_id

  is_private                     = false
  is_preserve_source_destination = false
}

# ============================================================================
# BACKEND SETS
# ============================================================================

resource "oci_network_load_balancer_backend_set" "nlb_backend_set_http" {
  health_checker {
    protocol = "TCP"
  }
  
  name                     = "k8s-backend-set-http"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = false

  depends_on = [oci_network_load_balancer_network_load_balancer.nlb]

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
  is_preserve_source       = false

  depends_on = [oci_network_load_balancer_network_load_balancer.nlb]

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_network_load_balancer.nlb.id
    ]
  }
}

# ============================================================================
# TIME SLEEP RESOURCES - Prevents NLB state conflicts
# ============================================================================

resource "time_sleep" "wait_between_backends_http" {
  for_each = local.backend_instances
  
  create_duration = "15s"
  
  depends_on = [
    oci_network_load_balancer_backend_set.nlb_backend_set_http
  ]
}

resource "time_sleep" "wait_between_backends_https" {
  for_each = local.backend_instances
  
  create_duration = "15s"
  
  depends_on = [
    oci_network_load_balancer_backend_set.nlb_backend_set_https,
    # Ensures HTTPS only starts after HTTP completes
    oci_network_load_balancer_backend.nlb_backend_http
  ]
}

# ============================================================================
# BACKENDS - HTTP
# ============================================================================

resource "oci_network_load_balancer_backend" "nlb_backend_http" {
  for_each = local.backend_instances
  
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set_http.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.node_port_http
  target_id                = each.value

  depends_on = [
    time_sleep.wait_between_backends_http
  ]

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_backend_set.nlb_backend_set_http.id
    ]
  }
}

# ============================================================================
# BACKENDS - HTTPS
# ============================================================================

resource "oci_network_load_balancer_backend" "nlb_backend_https" {
  for_each = local.backend_instances
  
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set_https.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.node_port_https
  target_id                = each.value

  depends_on = [
    time_sleep.wait_between_backends_https
  ]

  lifecycle {
    replace_triggered_by = [
      oci_network_load_balancer_backend_set.nlb_backend_set_https.id
    ]
  }
}

# ============================================================================
# LISTENERS
# ============================================================================

resource "oci_network_load_balancer_listener" "nlb_listener_http" {
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_backend_set_http.name
  name                     = "k8s-nlb-listener_http"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.listener_port_http
  protocol                 = "TCP"
  
  depends_on = [
    oci_network_load_balancer_backend.nlb_backend_http
  ]
}

resource "oci_network_load_balancer_listener" "nlb_listener_https" {
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_backend_set_https.name
  name                     = "k8s-nlb-listener-https"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb.id
  port                     = var.listener_port_https
  protocol                 = "TCP"
  
  depends_on = [
    oci_network_load_balancer_backend.nlb_backend_https
  ]
}