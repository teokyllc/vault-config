resource "vault_mount" "ssh" {
  path        = "ssh-client-signer"
  type        = "ssh"
}

resource "vault_ssh_secret_backend_ca" "backend_ca" {
    backend = vault_mount.ssh.path
}