resource "vault_auth_backend" "approle" {
  type = "approle"
}

# vault read auth/approle/role/intermediate-teokyllc-internal/role-id
resource "vault_approle_auth_backend_role" "pki_approle" {
  backend            = vault_auth_backend.approle.path
  role_name          = local.pki_role_name
  token_policies     = [local.pki_role_name]
  secret_id_ttl      = local.default_3y_in_sec
  token_num_uses     = 0
  token_ttl          = local.default_30min_in_sec
  token_max_ttl      = local.default_1hr_in_sec
  secret_id_num_uses = 0
}

# vault write -f auth/approle/role/intermediate-teokyllc-internal/secret-id
resource "vault_approle_auth_backend_role_secret_id" "pki_secret_id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.pki_approle.role_name
}