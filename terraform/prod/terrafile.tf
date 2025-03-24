
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

#AWS provider

module "aws_bucket" {
  source = "./modules/bucket_aws"
}

module "dynamodb" {
  source = "./modules/dynamodb_lock_state"
}

#Oracle cloud provider

module "aws_dynamodb" {
  source = "./modules/dynamodb_lock_state"
}

module "oci_aftier_flex_arm" {
  source = "./modules/oci_aftier_flex_arm"
}

module "oci_aftier_micro_amd" {
  source = "./modules/oci_aftier_micro_amd"
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