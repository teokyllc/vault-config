data "vault_generic_secret" "ad_bind_user" {
  path = "kv/AD-Bind-User"
}

data "vault_generic_secret" "ca-chain-cert" {
  path = "kv/cert"
}