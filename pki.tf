resource "vault_mount" "pki" {
 path                      = "pki"
 type                      = "pki"
 description               = "PKI engine hosting intermediate CA"
 default_lease_ttl_seconds = local.default_1hr_in_sec
 max_lease_ttl_seconds     = local.default_3y_in_sec
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate_cert_request_10_2022" {
 backend      = vault_mount.pki.path
 type         = "internal"
 common_name  = "TEOKYLLC Intermediate CA"
 key_type     = "rsa"
 key_bits     = "4096"
 ou           = "security"
 organization = "TEOKYLLC"
 country      = "US"
 locality     = "Bardstown"
 province     = "Kentucky"
}

# output "intermediate_cert_request_10_2022_csr" {
#   value = vault_pki_secret_backend_intermediate_cert_request.intermediate_cert_request_10_2022.csr
# }

# cat ~/cacerts/intermediate_crt_10_2022.crt ~/cacerts/root-ca.crt > ~/cacerts/teokyllc-ca-chain.crt

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate_signed_cert" {
 backend      = vault_mount.pki.path
 certificate  = data.vault_generic_secret.ca-chain-cert.data["ca-chain"]
}

resource "vault_pki_secret_backend_role" "pki_role" {
  backend          = vault_mount.pki.path
  name             = local.pki_role_name
  ttl              = 3600
  allow_ip_sans    = true
  key_type         = "rsa"
  key_bits         = 4096
  allowed_domains  = ["teokyllc.internal"]
  allow_subdomains = true
}

resource "vault_policy" "pki_policy" {
  name   = local.pki_role_name
  policy = <<EOT
path "pki*" {  capabilities = ["create", "read", "update", "delete", "list", "sudo"]}
EOT
}