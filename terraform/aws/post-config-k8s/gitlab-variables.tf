resource "gitlab_project_variable" "route53_external_dns_access_key" {
  project   = var.current_gitlab_project_id
  key       = "route53_external_dns_access_key"
  value     = aws_iam_access_key.route53-external-dns.id
  protected = false
  masked    = true
}

resource "gitlab_project_variable" "route53_external_dns_secret_key" {
  project   = var.current_gitlab_project_id
  key       = "route53_external_dns_secret_key"
  value     = aws_iam_access_key.route53-external-dns.secret
  protected = false
  masked    = true
}

resource "gitlab_project_variable" "longhorn_backups_access_key" {
  project   = var.current_gitlab_project_id
  key       = "longhorn_backups_access_key"
  value     = aws_iam_access_key.longhorn_backups.id
  protected = false
  masked    = true
}

resource "gitlab_project_variable" "longhorn_backups_secret_key" {
  project   = var.current_gitlab_project_id
  key       = "longhorn_backups_secret_key"
  value     = aws_iam_access_key.longhorn_backups.secret
  protected = false
  masked    = true
}

resource "gitlab_project_variable" "vault_iam_user_access_key" {
  project   = var.current_gitlab_project_id
  key       = "vault_iam_user_access_key"
  value     = aws_iam_access_key.vault_unseal.id
  protected = false
  masked    = true
}

resource "gitlab_project_variable" "vault_iam_user_secret_key" {
  project   = var.current_gitlab_project_id
  key       = "vault_iam_user_secret_key"
  value     = aws_iam_access_key.vault_unseal.secret
  protected = false
  masked    = true
}

data "gitlab_project_variable" "k8s_cluster_type" {
  project   = var.current_gitlab_project_id
  key       = "K8S_CLUSTER_TYPE"
}

data "gitlab_project_variable" "cloud_region" {
  project   = var.current_gitlab_project_id
  key       = "CLOUD_REGION"
}

data "gitlab_project_variable" "netmaker_ops_token" {
  project   = var.current_gitlab_project_id
  key       = "NETMAKER_OPS_TOKEN"
}

data "gitlab_project" "env" {
  id = var.current_gitlab_project_id
}

data "gitlab_group_variable" "nexus_fqdn" {
  group   = data.gitlab_project.env.namespace_id
  key       = "NEXUS_FQDN"
}

data "gitlab_group_variable" "nexus_docker_repo_listening_port" {
  group   = data.gitlab_project.env.namespace_id
  key       = "NEXUS_DOCKER_REPO_LISTENING_PORT"
}

data "gitlab_group_variable" "seaweedfs_fqdn" {
  group   = data.gitlab_project.env.namespace_id
  key       = "SEAWEEDFS_FQDN"
}

data "gitlab_group_variable" "seaweedfs_s3_listening_port" {
  group   = data.gitlab_project.env.namespace_id
  key       = "SEAWEEDFS_S3_LISTENING_PORT"
}

data "gitlab_group_variable" "vault_fqdn" {
  group   = data.gitlab_project.env.namespace_id
  key       = "VAULT_FQDN"
}

data "gitlab_group_variable" "vault_listening_port" {
  group   = data.gitlab_project.env.namespace_id
  key       = "VAULT_LISTENING_PORT"
}