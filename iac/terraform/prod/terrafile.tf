
# Google cloud provider 

module "service-account" {
  source  = "yohrannes/service-account/google"
  version = "0.1.1"
  project_id = var.project_id # Required
}

#module "gcp_ftier_micro_amd" {
#  project_id = var.project_id # Required
#  source  = "yohrannes/e2-micro-free-tier/google"
#  version = "1.2.11" 
#  credentials_path = "~/.gcp/credentials.json" #Required
#  startup_script_path = "./startup-files/startup-script.sh"
#  ssh_key_path = "~/.ssh/id_rsa.pub" #Required 
#}

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
  ssh_public_key = var.ssh_public_key
  source = "./modules/oci_aftier_flex_arm"
}

module "oci_aftier_micro_amd" {
  ssh_public_key = var.ssh_public_key
  source = "./modules/oci_aftier_micro_amd"
  disable_ssh_port = var.disable_ssh_port
  availability_domain = var.availability_domain
  tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
  user_email = "yohrannes@gmail.com"
#  instance_image_ocid = "ocid1.image.oc1.iad.aaaaaaaa2bulxukxsjyv3ap3x45eueiqxxpxpsfrv6qppq7xrwtiima2c2pq"
}

module "oci_oke_cluster_arm" {
  ssh_public_key = var.ssh_public_key
  source = "./modules/oci_oke_cluster_arm"
#  ssh_public_key = file("~/.ssh/id_rsa.pub")
  fingerprint = null
  private_key_path = "~/.oci/oci_api_key.pem"
  tenancy_ocid = null
  user_ocid = null
  oci_profile = "DEFAULT"
}
