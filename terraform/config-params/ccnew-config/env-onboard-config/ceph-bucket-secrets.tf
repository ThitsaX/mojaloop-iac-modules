data "kubernetes_secret_v1" "loki_bucket" {
  metadata {
      name      = "${var.env_name}-loki-bucket"
      namespace = var.env_name
  }
}

resource "vault_kv_secret_v2" "loki_bucket_access_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/loki_bucket_access_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.loki_bucket.data.username
    }
  )
}

resource "vault_kv_secret_v2" "loki_bucket_secret_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/loki_bucket_secret_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.loki_bucket.data.password
    }
  )
}


data "kubernetes_secret_v1" "tempo_bucket" {
  metadata {
      name      = "${var.env_name}-tempo-bucket"
      namespace = var.env_name
  }
}

resource "vault_kv_secret_v2" "tempo_bucket_access_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/tempo_bucket_access_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.tempo_bucket.data.username
    }
  )
}

resource "vault_kv_secret_v2" "tempo_bucket_secret_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/tempo_bucket_secret_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.tempo_bucket.data.password
    }
  )
}


data "kubernetes_secret_v1" "velero_bucket" {
  metadata {
      name      = "${var.env_name}-velero-bucket"
      namespace = var.env_name
  }
}

resource "vault_kv_secret_v2" "velero_bucket_access_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/velero_bucket_access_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.velero_bucket.data.username
    }
  )
}

resource "vault_kv_secret_v2" "velero_bucket_secret_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/velero_bucket_secret_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.velero_bucket.data.password
    }
  )
}

data "kubernetes_secret_v1" "percona_bucket" {
  metadata {
      name      = "${var.env_name}-percona-bucket"
      namespace = var.env_name
  }
}

resource "vault_kv_secret_v2" "percona_bucket_access_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/percona_bucket_access_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.percona_bucket.data.username
    }
  )
}

resource "vault_kv_secret_v2" "percona_bucket_secret_key_id" {
  mount               = var.kv_path
  name                = "${var.env_name}/percona_bucket_secret_key_id"
  delete_all_versions = true
  data_json = jsonencode(
    {
      value = data.kubernetes_secret_v1.percona_bucket.data.password
    }
  )
}

data "gitlab_project" "env" {
  path_with_namespace = "iac/${var.env_name}"
}

resource "gitlab_project_variable" "ceph_loki_bucket" {
  project   = data.gitlab_project.env.id
  key       = "ceph_loki_bucket"
  value     = "${var.env_name}-loki"
  protected = false
  masked    = false
}

resource "gitlab_project_variable" "ceph_tempo_bucket" {
  project   = data.gitlab_project.env.id
  key       = "ceph_tempo_bucket"
  value     = "${var.env_name}-tempo"
  protected = false
  masked    = false
}

resource "gitlab_project_variable" "ceph_velero_bucket" {
  project   = data.gitlab_project.env.id
  key       = "ceph_velero_bucket"
  value     = "${var.env_name}-velero"
  protected = false
  masked    = false
}

resource "gitlab_project_variable" "ceph_percona_bucket" {
  project   = data.gitlab_project.env.id
  key       = "ceph_percona_bucket"
  value     = "${var.env_name}-percona"
  protected = false
  masked    = false
}
