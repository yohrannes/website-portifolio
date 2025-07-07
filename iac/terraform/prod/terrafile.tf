
# Google cloud provider 

module "service-account" {
  source  = "yohrannes/service-account/google"
  version = "0.1.1"
  project_id = var.project_id # Required
}

module "gcp_ftier_micro_amd" {
  project_id = var.project_id # Required
  source  = "yohrannes/e2-micro-free-tier/google"
  version = "1.2.7" 
  credentials_path = "~/.gcp/credentials.json" #Required
  startup_script_path = "./startup-files/startup-script.sh"
  ssh_key_path = "~/.ssh/id_rsa.pub" #Required 
}

module "webport_bucket" {
  source = "./modules/bucket_gcp"
  project_id = var.project_id # Required
}

#AWS provider

module "aws_bucket" {
  source = "./modules/bucket_aws"
}

module "aws_dynamodb" {
  source = "./modules/dynamodb_lock_state"
}

#Oracle cloud provider

module "oci_aftier_flex_arm" {
  source = "./modules/oci_aftier_flex_arm"
}

module "oci_aftier_micro_amd" {
  source = "./modules/oci_aftier_micro_amd"
  disable_ssh_port = var.disable_ssh_port
  availability_domain = var.availability_domain
}

module "oci_aftier_micro_amd_packer_image" {
  source = "./modules/oci_aftier_micro_amd_packer_image"
  tenancy_ocid = module.oci_aftier_micro_amd.tenancy_ocid
  packer_compartment_name = "yohapp-packer-comp"
  compartment_id = module.oci_aftier_micro_amd.compartment_id
  availability_domain = var.availability_domain
  image_name = "ubuntu2204-e2-1micro-packer-"
}

module "oci_oke_cluster_arm" {
  source = "./modules/oci_oke_cluster_arm"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
  fingerprint = null
  private_key_path = "~/.oci/oci_api_key.pem"
  tenancy_ocid = null
  user_ocid = null
  oci_profile = "DEFAULT"
}
