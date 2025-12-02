#resource "oci_bastion_bastion" "bastion_aftier_micro_amd" {
#  compartment_id               = module.oci_aftier_micro_amd.compartment_id
#  bastion_type                 = "STANDARD"
#  target_subnet_id             = module.oci_aftier_micro_amd.subnetA_pub_id
#  name                         = "bastion-aftier_micro_amd"
#  client_cidr_block_allow_list = ["0.0.0.0/0"]
#  max_session_ttl_in_seconds   = 10800
#}