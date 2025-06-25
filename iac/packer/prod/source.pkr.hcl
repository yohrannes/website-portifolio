locals {
  timestamp = regex_replace(timestamp(), "[-TZ:]", "")
}

source "oracle-oci" "basic" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  key_file     = var.private_key_path
  region       = var.region

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

  shape = "VM.Standard.E2.1.Micro"
  image_name = "Packer_Builder_Test_${local.timestamp}"
  disk_size = 50  # Mínimo 50GB

  subnet_ocid = var.subnet_ocid
  
  ssh_username = "ubuntu"
  ssh_timeout  = "15m"
  
  metadata = {
    user_data = base64encode(<<-EOF
      #!/bin/bash
      exec > /var/log/startup-script.log 2>&1
      set -x
      # Script de pré-bootstrap (equivalente ao pre-bootstrap do classic)
      echo "exec initial config.."
      # Adicione seus scripts aqui
    EOF
    )
  }
  
  # Adicionar configuração de debug
  use_private_ip = false
  
  # Configurações de validação
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