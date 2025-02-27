module "bucket_aws" {
  source = "./modules/bucket_aws"
}

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
  source       = "git::https://github.com/yohrannes/terraform_gcp_instance_aways_free.git?ref=v1.0.5"
  project_name = "website-portifolio"
}