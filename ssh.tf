resource "vault_mount" "ssh" {
  path        = "ssh-client-signer"
  type        = "ssh"
}