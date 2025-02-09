locals {
  ssh_user       = "ubuntu"  # Substitua pelo nome de usuário apropriado
  ssh_public_key = file("/root/.ssh/id_rsa.pub")
  formatted_key  = "${local.ssh_user}:${trimspace(local.ssh_public_key)}"
}