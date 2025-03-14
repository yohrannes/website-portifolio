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

module "e2-micro" {
  source  = "yohrannes/e2-micro/google"
  version = "1.0.8"
  credentials_path = "~/.gcp/credentials.json"
  project_name = "website-portifolio"
}