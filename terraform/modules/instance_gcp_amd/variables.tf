locals {
  ssh_public_key = file("${path.module}/ssh_keys/id_rsa.pub")  # Armazene a chave no diretório do projeto
  ssh_user       = "debian"  # Usuário correto para Debian
  formatted_key  = "${local.ssh_user}:${trimspace(local.ssh_public_key)}"
}