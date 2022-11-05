resource "vault_ldap_auth_backend" "active_directory" {
    path         = "ldap"
    url          = "ldaps://ad1.teokyllc.internal:636"
    userdn       = "CN=Users,DC=teokyllc,DC=internal"
    userattr     = "sAMAccountName"
    groupdn      = "CN=Users,DC=teokyllc,DC=internal"
    groupfilter  = "(&(objectClass=group)(member:1.2.840.113556.1.4.1941:={{.UserDN}}))"
    groupattr    = "memberOf"
    binddn       = data.vault_generic_secret.ad_bind_user.data["binddn"]
    bindpass     = data.vault_generic_secret.ad_bind_user.data["bindpass"]
    certificate  = data.vault_generic_secret.ad_bind_user.data["teokyllc-ad1-ca"]
    starttls     = true
    insecure_tls = false
}

resource "vault_policy" "active_directory_admin_policy" {
  name   = "active-directory-admins"
  policy = <<EOT
path "sys/health"         { capabilities = ["read", "sudo"] }
path "sys/policies/acl"   { capabilities = ["list"] }
path "sys/policies/acl/*" { capabilities = ["create", "read", "update", "delete", "list", "sudo"] }
path "auth/*"             { capabilities = ["create", "read", "update", "delete", "list", "sudo"] }
path "sys/auth/*"         { capabilities = ["create", "update", "delete", "sudo"] }
path "sys/auth"           { capabilities = ["read"] }
path "secret/*"           { capabilities = ["create", "read", "update", "delete", "list", "sudo"] }
path "sys/mounts/*"       { capabilities = ["create", "read", "update", "delete", "list", "sudo"] }
path "sys/mounts"         { capabilities = ["read"] }
path "kv/*"               { capabilities = ["create", "read", "update", "delete", "list", "sudo"] }
path "pki/*"              { capabilities = ["create", "read", "update", "delete", "list", "sudo"] }
EOT
}

resource "vault_ldap_auth_backend_group" "active_directory_group" {
    groupname = "Vault-Admins"
    policies  = [vault_policy.active_directory_admin_policy.name]
    backend   = vault_ldap_auth_backend.active_directory.path
}