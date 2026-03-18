# OKE Cluster Destroy Troubleshooting Guide

Sometimes the destroy process for an OKE cluster may fail due to existing resources that are still attached to the cluster's VNICs. To troubleshoot and resolve this issue, follow these steps:

## 1. Identify VNICs and Associated Resources

```bash
# Get VNIC details
oci network vnic get --vnic-id <vnic-id>
```

## 2. Manual Resource Deletion Order

If Terraform destroy fails, you must manually delete resources in the correct dependency order using OCI CLI:

Delete resources in this specific order to avoid dependency conflicts:

### Step 1: OKE Resources
```bash
# Delete node pools first
oci ce node-pool list --compartment-id
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

### Step 4: Verify VNICs Removed
```bash
oci network vnic list --compartment-id <compartment-id> --subnet-id <subnet-id>
```

### Step 5: Network Resources
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

### Step 6: Compartment
```bash
oci iam compartment delete --compartment-id <compartment-id> --force
```


Actual problems

tf destroy process

subnet cant be destroied because of vnic reference



{
  "data": {
    "availability-domain": "lIpY:US-ASHBURN-AD-1",
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaawdmxscqgffonwqx6kjjzp2f56twkyxozkpj7heygzm3pvpndhciq",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "ocid1.cluster.oc1.iad.aaaaaaaaukeyprhkqokonxxjkb3lk3bsjuuaiotjhuvbeearwccfsxrhwlta",
        "CreatedOn": "2026-01-16T19:53:53.513Z"
      }
    },
    "display-name": "VNIC for LB ocid1.loadbalancer.oc1.iad.aaaaaaaauogqkmpyhcjkuzdxks25y5ginku37chw6h54rcm3435wfh64h43a",
    "freeform-tags": {},
    "hostname-label": null,
    "id": "ocid1.vnic.oc1.iad.abuwcljsczd5s6vbd634rnlfnj54oywnmlsj6z2g3u6rfvneedpqlqx3isfq",
    "ipv6-addresses": null,
    "is-primary": true,
    "lifecycle-state": "AVAILABLE",
    "mac-address": "02:00:17:16:E5:D7",
    "nsg-ids": [],
    "private-ip": "10.0.0.44",
    "public-ip": "129.80.49.99",
    "route-table-id": null,
    "security-attributes": {},
    "skip-source-dest-check": false,
    "subnet-id": "ocid1.subnet.oc1.iad.aaaaaaaar5pbgguxaldwlwlo4xrpiarcljo7nmqwikbya62t7x7rzywzne7q",
    "time-created": "2026-01-16T19:54:08.251000+00:00",
    "vlan-id": null
  },
  "etag": "2b94effe"
}





 then 

oci lb load-balancer delete --load-balancer-id <load-balancer-id> --force

tf destroy again and it works - destroy complete

but... then tf plan and apply again ....

╷
│ Error: 409-Conflict, Invalid State Transition of NLB lifeCycle state from Updating to Updating
│ Suggestion: The resource is in a conflicted state. Please retry again or contact support for help with service: Network Load Balancer Backend Set
│ Documentation: https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/network_load_balancer_backend_set
│ API Reference: https://docs.oracle.com/iaas/api/#/en/networkloadbalancer/20200501/BackendSet/CreateBackendSet
│ Request Target: POST https://network-load-balancer-api.us-ashburn-1.oci.oraclecloud.com/20200501/networkLoadBalancers/ocid1.networkloadbalancer.oc1.iad.amaaaaaahlpibdiageyleekq4dugkcqwo7t5j4ousdd3wygy4jibtujcxhwa/backendSets
│ Provider version: 7.27.0, released on 2025-11-20. This provider is 11 Update(s) behind to current.
│ Service: Network Load Balancer Backend Set
│ Operation Name: CreateBackendSet
│ OPC request ID: 6d1b0a03d3694c7a7cd334424e92cf24/5EEB779358255E614839896949414451/BD38EEFA077FAA66729010B2D0DE1BF0
│
│
│   with module.webapp.module.loadbalancer.oci_network_load_balancer_backend_set.nlb_backend_set_https,
│   on modules/oci_oke_aways_free/loadbalancer/loadbalancer.tf line 47, in resource "oci_network_load_balancer_backend_set" "nlb_backend_set_https":
│   47: resource "oci_network_load_balancer_backend_set" "nlb_backend_set_https" {
│
╵

tf plan and apply again and it works - apply complete