module "packer" {
  source = "./modules/packer"
  tenancy_ocid = var.tenancy_ocid
  compartment_id = var.compartment_id
  packer_compartment_name = "yohapp-packer-comp"
  availability_domain = var.availability_domain
  image_name = "ubuntu2204-e2-1micro-packer-"
  user_email = var.user_email
}