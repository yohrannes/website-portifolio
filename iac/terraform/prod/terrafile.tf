
# Google cloud provider
module "service-account" {
  source  = "yohrannes/service-account/google"
  version = "0.2.0"
  enable_sa_resource = true
  print_credentials = true
  project_id = var.project_id # Required
}

module "gcp_ftier_micro_amd" {
  project_id = var.project_id # Required
  source     = "yohrannes/e2-micro-free-tier/google"
  version    = "v8.6.13"
  #  credentials_path = "~/.config/gcloud/application_default_credentials.json"
  startup_script_path = "./startup-files/startup-script.sh"
  ssh_key_path        = var.ssh_public_key #Required
  instance_name       = "gitlab-runner"
}

module "webport_bucket" {
  source     = "./modules/bucket_gcp"
  project_id = var.project_id # Required
}

#Oracle cloud provider

module "oci_aftier_flex_arm" {
  ssh_public_key = var.ssh_public_key
  source         = "./modules/oci_aftier_flex_arm"
}

module "oci_aftier_micro_amd" {
  ssh_public_key      = var.ssh_public_key
  source              = "./modules/oci_aftier_micro_amd"
  disable_ssh_port    = var.disable_ssh_port
  availability_domain = var.availability_domain
  tenancy_ocid        = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
  compartment_id      = "ocid1.tenancy.oc1..aaaaaaaawb7j4hswwgcjncr2ezu5mptw6o5n6h7ixvef5lzqsqkbtmwk44aq"
  user_email          = "yohrannes@gmail.com"
  #  instance_image_ocid = "ocid1.image.oc1.iad.aaaaaaaa2bulxukxsjyv3ap3x45eueiqxxpxpsfrv6qppq7xrwtiima2c2pq"
  packer_oci_config_content      = var.packer_oci_config_content
  packer_oci_private_key_content = var.packer_oci_private_key_content
  packer_oci_public_key_content  = var.packer_oci_public_key_content
}

module "oci_oke_cluster_arm" {
  ssh_public_key = var.ssh_public_key
  source         = "./modules/oci_oke_cluster_arm"
  #  ssh_public_key = file("~/.ssh/id_rsa.pub")
  fingerprint      = null
#  private_key_path = "~/.oci/oci_api_key.pem"
  private_key_path = null
  tenancy_ocid     = null
  user_ocid        = null
#  oci_profile      = "DEFAULT"
  oci_profile      = null
}
