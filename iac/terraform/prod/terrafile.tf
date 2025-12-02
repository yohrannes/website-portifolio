
# Google cloud provider
module "service-account" {
  source             = "yohrannes/service-account/google"
  version            = "0.2.0"
  enable_sa_resource = true
  print_credentials  = true
  project_id         = var.project_id # Required
}

module "runner2" {
  project_id = var.project_id # Required
  source     = "yohrannes/e2-micro-free-tier/google"
  version    = "v8.6.13"
  startup_script_path = "./startup-files/startup-script.sh"
  ssh_key_path        = var.ssh_public_key #Required
  instance_name       = "runner2"
}

module "webport_bucket" {
  source     = "./modules/bucket_gcp"
  project_id = var.project_id # Required
}

#Oracle cloud provider

module "runner1" {
  ssh_public_key = var.ssh_public_key
  source         = "./modules/st-e2-1-micro-aways-free"
  compartment_id = var.oci_tenancy_ocid
  compartment_name = "runner1-comp"
}

module "webapp" {
  ssh_public_key      = var.ssh_public_key
  source              = "./modules/st-a1-flex-aways-free"
  disable_ssh_port    = var.disable_ssh_port
  availability_domain = var.availability_domain
  tenancy_ocid        = var.oci_tenancy_ocid
  compartment_id      = var.oci_tenancy_ocid
  user_email          = "yohrannes@gmail.com"
#  packer_oci_config_content      = var.packer_oci_config_content
#  packer_oci_private_key_content = var.packer_oci_private_key_content
#  packer_oci_public_key_content  = var.packer_oci_public_key_content
}

module "oci_oke_cluster_arm" {
  ssh_public_key = var.ssh_public_key
  source         = "./modules/oci_oke_cluster_arm"
  #  ssh_public_key = file("~/.ssh/id_rsa.pub")
  fingerprint = null
  #  private_key_path = "~/.oci/oci_api_key.pem"
  private_key_path = null
  tenancy_ocid     = null
  user_ocid        = null
  #  oci_profile      = "DEFAULT"
  oci_profile = null
}
