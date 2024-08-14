resource "netbird_setup_key" "env_gw" {
  name        = "${var.env_name}-gw"
  type        = "reusable"
  auto_groups = [netbird_group.env_gw.id]
  ephemeral   = false
  usage_limit = 0
  expires_in  = 86400
}

resource "netbird_setup_key" "env_k8s" {
  name        = "${var.env_name}-k8s"
  type        = "reusable"
  auto_groups = [netbird_group.env_k8s.id]
  ephemeral   = true
  usage_limit = 0
  expires_in  = 86400
}

resource "netbird_group" "env_gw" {
  name = "${var.env_name}-gw"
}

resource "netbird_group" "env_users" {
  name = "${local.netbird_project_id}:${var.env_name}-vpn-users"
}

resource "netbird_route" "env_k8s" {
  description = "${var.env_name}-k8s"
  enabled     = true
  groups      = [netbird_group.env_users.id, local.cc_user_group_id]
  keep_route  = true
  masquerade  = true
  metric      = 9999
  peer_groups = [netbird_group.env_gw.id]
  network     = var.env_cidr
  network_id  = "${var.env_name}-k8s"
}

data "netbird_groups" "all" {
}
locals {
  cc_user_group_id = [for group in data.netbird_groups.all.groups : group.id if strcontains(group.name, "${local.netbird_project_id}:${var.netbird_user_rbac_group}")][0]
}
