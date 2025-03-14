module "aws_bucket" {
  source = "./modules/bucket_aws"
}

module "dynamodb" {
  source = "./modules/dynamodb_lock_state"
}

module "aws_dynamodb" {
  source = "./modules/dynamodb_lock_state"
}

module "oci_aftier_flex_arm" {
  source = "./modules/oci_aftier_flex_arm"
}

module "oci_aftier_micro_amd" {
  source = "./modules/oci_aftier_micro_amd"
}

module "gcp_ftier_micro_amd" {
  source  = "yohrannes/e2-micro/google"
  version = "1.1.1"
  credentials_path = "~/.gcp/credentials.json" #Required
  startup_script_path = "./startup-files/startup-script.sh"
  ssh_key_path = "~/.ssh/id_rsa.pub" #Required 
}