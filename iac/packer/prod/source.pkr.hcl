locals {
  timestamp = regex_replace(timestamp(), "[-TZ:]", "")
}

source "oracle-oci" "basic" {

  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain

  base_image_filter {
    operating_system         = "Canonical Ubuntu"
    operating_system_version = "22.04"
    display_name_search      = "Canonical-Ubuntu-22.04-2025"
  }

  #base_image_ocid = "ocid1.image.oc1.iad.aaaaaaaahae3xgdks5kionenl4twlkmp6wd5xe26vxnhcoxtugm3dkddzapa"

  #you may skip the image creation if you are running tests
  #when you want to test set this as true
  skip_create_image = false

  shape      = "VM.Standard.E2.1.Micro"
  image_name = "ubuntu2204-e2-1micro-packer-${local.timestamp}"
  disk_size  = 50 # Mínimo 50GB

  subnet_ocid = var.subnet_ocid

  ssh_username = "ubuntu"
  ssh_timeout  = "15m"

  #metadata = {
  #  user_data = base64encode(<<-EOF
  #    #!/bin/bash
  #    exec > /var/log/startup-script.log 2>&1
  #    set -x
  #    echo "exec initial config.."
  #    # Adicione seus scripts aqui
  #  EOF
  #  )
  #}

  use_private_ip = false

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.subnet_ocid
  }

  instance_tags = {
    "Environment" = "Build"
    "CreatedBy"   = "Packer"
    "BuildTime"   = local.timestamp
  }
}