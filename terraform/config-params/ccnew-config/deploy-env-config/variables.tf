
variable "kv_path" {
  description = "path for kv engine"
  default     = "secret"
}

variable "nexus_fqdn" {
  description = "fqdn for nexus"
}

variable "environment_list" {
  description = "env repos to pre-create"         
}


variable "nexus_docker_repo_listening_port" {
  description = "listening port for nexus"
  default     = 443
}

variable "ceph_obj_store_gw_fqdn" {
  description = "fqdn for ceph object storage gw"
}

variable "ceph_obj_store_gw_port" {
  description = "port for ceph object storage gw"
  default     = 443
}

variable "tenant_vault_listening_port" {
  description = "port for vault"
  default     = 443
}

variable "max_objects" {
  description = "max number of objects in a bucket"
  default     = 1000
}

variable "max_size" {
  description = "max size of objects in a bucket"
  default     = "100G"
}


variable "storage_class" {
  description = "object storage class of ceph"
  default     = "ceph-bucket"
}

variable "namespace" {
  description = "namespace to create the buckets"
  default     = "gitlab"
}