module "bucket_aws" {
  source = "./modules/bucket_aws"
}

module "dynamodb" {
  source = "./modules/dynamodb_lock_state"
}

module "instance_oracle_arm" {
  source = "./modules/instance_oracle_arm"
}

module "instance_oracle_amd" {
  source = "./modules/instance_oracle_amd"
}

module "instance_gcp_amd" {
#  source = "./modules/instance_gcp_amd"
  source = "git::https://github.com/yohrannes/terraform_gcp_instance_aways_free.git?ref=v1.0.4"
  project_name = "website-portifolio"
}
