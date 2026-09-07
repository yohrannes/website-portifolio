
# Google cloud provider

#module "service-accounts" {
#  source  = "terraform-google-modules/service-accounts/google"
#  version = "4.7.0"

  # insert the 1 required variable here
#}

module "runner2" {
  project_id          = var.project_id                        # Required
  source              = "yohrannes/e2-micro-free-tier/google" # Check if there exist an instance image with gitlab-runner already installed.
  version             = "v8.6.13"
  startup_script_path = "./startup-files/startup-script.sh"
  ssh_key_path        = var.ssh_public_key #Required
  instance_name       = "runner2"
}

#Oracle cloud provider

module "webapp_failover" {
  ssh_public_key      = var.ssh_public_key
  source              = "./modules/st-a1-flex-aways-free"
  disable_ssh_port    = var.disable_ssh_port
  availability_domain = var.availability_domain
  tenancy_ocid        = var.oci_tenancy_ocid
  compartment_id      = var.oci_tenancy_ocid
  user_email          = "yohrannes@gmail.com"
  compartment_name    = "webapp-failover-comp"
  #  packer_oci_config_content      = var.packer_oci_config_content
  #  packer_oci_private_key_content = var.packer_oci_private_key_content
  #  packer_oci_public_key_content  = var.packer_oci_public_key_content
}

module "webapp" {
  ssh_public_key   = var.ssh_public_key
  source           = "./modules/oci_oke_aways_free"
  fingerprint      = null
  private_key_path = null
  tenancy_ocid     = var.oci_tenancy_ocid
  user_ocid        = null
  oci_profile      = "DEFAULT"

  ## Activate -parallelism=1 on terraform Cloud
  ## Workspace settings > General > Advanced options > Terraform CLI Arguments

}

module "cluster_services" {
  source = "./modules/cluster-services"
}
