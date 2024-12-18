module "bucket_aws" {
  source = "./modules/bucket_aws"
}

module "instance_oracle_arm" {
  source = "./modules/instance_oracle_arm"
}

module "instance_oracle_amd" {
  source = "./modules/instance_oracle_amd"
}