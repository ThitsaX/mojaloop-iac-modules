data "gitlab_project_variable" "k8s_cluster_type" {
  project = var.current_gitlab_project_id
  key     = "K8S_CLUSTER_TYPE"
}

data "gitlab_project_variable" "cloud_platform" {
  project = var.current_gitlab_project_id
  key     = "CLOUD_PLATFORM"
}

data "gitlab_project_variable" "cloud_region" {
  project = var.current_gitlab_project_id
  key     = "CLOUD_REGION"
}


data "gitlab_project_variable" "cert_manager_credentials_client_secret_name" {
  project = var.current_gitlab_project_id
  key     = var.properties_key_map["cert_manager_credentials_client_secret_name_key"]
}

data "gitlab_project_variable" "cert_manager_credentials_client_id_name" {
  project = var.current_gitlab_project_id
  key     = var.properties_key_map["cert_manager_credentials_client_id_name_key"]
}

data "gitlab_project_variable" "external_dns_credentials_client_secret_name" {
  project = var.current_gitlab_project_id
  key     = var.properties_key_map["external_dns_credentials_client_secret_name_key"]
}

data "gitlab_project_variable" "external_dns_credentials_client_id_name" {
  project = var.current_gitlab_project_id
  key     = var.properties_key_map["external_dns_credentials_client_id_name_key"]
}

# need to get these by hand because loki doesnt support k8s secret env vars.

data "vault_generic_secret" "grafana_oauth_client_id" {
  count = var.enable_grafana_oidc ? 1 : 0  
  path = "${var.kv_path}/${var.cluster_name}/${var.grafana_oidc_client_id_secret_key}"
}

data "vault_generic_secret" "grafana_oauth_client_secret" {
  count = var.enable_grafana_oidc ? 1 : 0    
  path = "${var.kv_path}/${var.cluster_name}/${var.grafana_oidc_client_secret_secret_key}"
}

data "gitlab_project_variable" "minio_loki_bucket" {
  project = var.current_gitlab_project_id
  key     = "minio_loki_bucket"
}

data "gitlab_project_variable" "minio_tempo_bucket" {
  project = var.current_gitlab_project_id
  key     = "minio_tempo_bucket"
}

data "gitlab_project_variable" "minio_longhorn_bucket" {
  project = var.current_gitlab_project_id
  key     = "minio_longhorn_bucket"
}

data "gitlab_project_variable" "minio_velero_bucket" {
  project = var.current_gitlab_project_id
  key     = "minio_velero_bucket"
}

data "gitlab_project_variable" "minio_percona_backup_bucket" {
  project = var.current_gitlab_project_id
  key     = "minio_percona_bucket"
}