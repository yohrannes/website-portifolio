# OKE Cluster Destroy Troubleshooting Guide

Sometimes the destroy process for an OKE cluster may fail due to existing resources that are still attached to the cluster's VNICs. To troubleshoot and resolve this issue, follow these steps:

## 1. Identify VNICs and Associated Resources

```bash
# List all VNICs in the compartment
oci network vnic list --compartment-id <compartment-id>

# Get VNIC details
oci network vnic get --vnic-id <vnic-id>
```

## 2. Manual Resource Deletion Order

If Terraform destroy fails, you must manually delete resources in the correct dependency order using OCI CLI:

Delete resources in this specific order to avoid dependency conflicts:

### Step 1: OKE Resources
```bash
# Delete node pools first
oci ce node-pool delete --node-pool-id <node-pool-id> --force

# Delete cluster
oci ce cluster delete --cluster-id <cluster-id> --force
```

### Step 2: Load Balancers
```bash
oci lb load-balancer delete --load-balancer-id <load-balancer-id> --force
```

### Step 3: Compute Instances
```bash
oci compute instance terminate --instance-id <instance-id> --force
```

### Step 4: Database Systems
```bash
oci db system terminate --db-system-id <db-system-id> --force
```

### Step 5: Verify VNICs Removed
```bash
oci network vnic list --compartment-id <compartment-id> --subnet-id <subnet-id>
```

### Step 6: Network Resources
```bash
# Subnets
oci network subnet delete --subnet-id <subnet-id> --force

# Security Lists
oci network security-list delete --security-list-id <security-list-id> --force

# Route Tables
oci network route-table delete --rt-id <route-table-id> --force

# Gateways
oci network internet-gateway delete --ig-id <internet-gateway-id> --force
oci network nat-gateway delete --nat-gateway-id <nat-gateway-id> --force

# VCN
oci network vcn delete --vcn-id <vcn-id> --force
```

### Step 7: Compartment
```bash
oci iam compartment delete --compartment-id <compartment-id> --force
```