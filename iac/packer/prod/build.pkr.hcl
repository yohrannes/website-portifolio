# Build configuration - mantendo a simplicidade do exemplo original
build {
  sources = ["source.oracle-oci.basic"]
  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true

    playbook_file    = "./ansible/playbook.yml"
    ansible_env_vars = ["ANSIBLE_REMOTE_TMP=/tmp/.ansible/tmp" ]
    roles_path       = "./ansible/roles"
    user = var.user

    // extra_arguments = ["-vvvv"]
  }
}