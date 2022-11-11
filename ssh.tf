resource "vault_mount" "ssh" {
  path        = "ssh-client-signer"
  type        = "ssh"
}

resource "vault_ssh_secret_backend_ca" "backend_ca" {
    backend = vault_mount.ssh.path
    generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "backend_role" {
    name                    = "ssh-client-signer"
    backend                 = vault_mount.ssh.path
    key_type                = "ca"
    allow_user_certificates = true
    algorithm_signer        = "rsa-sha2-256"
    allowed_extensions      = "permit-pty,permit-port-forwarding"
    default_user            = "ubuntu"
    ttl                     = "30m0s"
}