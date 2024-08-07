# env related

resource "vault_mount" "transit" {
  path        = "transit"
  type        = "transit"
  description = "transit mount for cluster vault unsealing"
}

resource "vault_transit_secret_backend_key" "unseal_key" {
  for_each = toset(local.environment_list)
  backend  = vault_mount.transit.path
  name     = "unseal-key-${each.value}"
  deletion_allowed = true
}

resource "vault_policy" "env_transit" {
  for_each = toset(local.environment_list)
  name     = "env-transit-${each.value}"

  policy = <<EOT
path "${var.kv_path}/data/${each.value}/*" {
  capabilities = ["read", "list"]
}

path "${var.kv_path}/data/tenancy/*" {
  capabilities = ["read", "list"]
}

path "${vault_mount.transit.path}/encrypt/${vault_transit_secret_backend_key.unseal_key[each.value].name}" {
  capabilities = [ "update" ]
}

path "${vault_mount.transit.path}/decrypt/${vault_transit_secret_backend_key.unseal_key[each.value].name}" {
  capabilities = [ "update" ]
}
EOT
}

resource "vault_token" "env_token" {
  for_each  = toset(local.environment_list)
  policies  = [vault_policy.env_transit[each.value].name]
  no_parent = true
}

resource "vault_kv_secret_v2" "env_token" {
  for_each            = toset(local.environment_list)
  mount               = var.kv_path
  name                = "${each.value}/env_token"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = vault_token.env_token[each.value].client_token
    }
  )
}

resource "random_password" "vault_root_token" {
  length           = 30
  special          = true
  override_special = "_"
}


resource "vault_kv_secret_v2" "vault_root_token" {
  mount               = var.kv_path
  name                = "tenancy/vault_root_token"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = random_password.vault_root_token.result
    }
  )
}