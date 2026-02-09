output "compartment_id" {
  value = module.compartment.compartment_id
}

output "cluster_id" {
  value = module.cluster.cluster_id
}

output "lb_public_ip" {
  value = module.loadbalancer.load_balancer_public_ip
}

output "oci_core_instances_1" {
  value = module.loadbalancer.oci_core_instances_1
}

output "oci_core_instances_2" {
  value = module.loadbalancer.oci_core_instances_2
}

output "oci_core_instances_3" {
  value = module.loadbalancer.oci_core_instances_3
}

#output "todas_as_vnics" {
#  value = module.cluster.todas_as_vnics
#