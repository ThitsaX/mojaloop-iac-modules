resource "local_file" "chart_values" {
  for_each = { for stateful_resource in local.local_stateful_resources : stateful_resource.resource_name => stateful_resource }

  content = templatefile("${local.stateful_resources_template_path}/${each.value.local_resource_config.resource_helm_values_ref}", {
    resource = each.value
  })
  filename = "${local.stateful_resources_output_path}/values-${each.value.local_resource_config.resource_helm_chart}-${each.value.resource_name}.yaml"
}

resource "local_file" "vault_crs" {
  for_each = { for stateful_resource in local.local_stateful_resources : stateful_resource.resource_name => stateful_resource }

  content = templatefile("${local.stateful_resources_template_path}/vault-crs.yaml.tpl", {
    resource = each.value
  })
  filename = "${local.stateful_resources_output_path}/vault-crs-${each.value.resource_name}.yaml"
}

resource "local_file" "managed_crs" {
  for_each = local.managed_resource_password_map

  content = templatefile("${local.stateful_resources_template_path}/managed-crs.yaml.tpl", {
    password_map = each.value
  })
  filename = "${local.stateful_resources_output_path}/managed-crs-${each.key}.yaml"
}

resource "local_file" "external_name_services" {
  content = templatefile("${local.stateful_resources_template_path}/external-name-services.yaml.tpl",
    { config                       = local.external_name_map
      stateful_resources_namespace = var.stateful_resources_namespace
  })
  filename = "${local.stateful_resources_output_path}/external-name-services.yaml"
}

resource "local_file" "kustomization" {
  content = templatefile("${local.stateful_resources_template_path}/stateful-resources-kustomization.yaml.tpl",
    { local_stateful_resources   = local.local_stateful_resources
      managed_stateful_resources = local.managed_stateful_resources
  })
  filename = "${local.stateful_resources_output_path}/kustomization.yaml"
}

resource "local_file" "namespace" {
  content = templatefile("${local.stateful_resources_template_path}/namespace.yaml.tpl",
    {
      all_ns = distinct(concat(var.create_stateful_resources_ns ? [var.stateful_resources_namespace] : [], local.all_logical_extra_namespaces, local.all_local_namespaces, local.all_local_extra_namespaces))
  })
  filename = "${local.stateful_resources_output_path}/namespace.yaml"
}

resource "local_file" "stateful-resources-app-file" {
  content  = templatefile("${local.stateful_resources_template_path}/app/${local.stateful_resources_app_file}.tpl", local.stateful_resources_vars)
  filename = "${local.app_stateful_resources_output_path}/${local.stateful_resources_name}-${local.stateful_resources_app_file}"
}

locals {
  stateful_resources_name            = var.stateful_resources_name
  stateful_resources_template_path   = "${path.module}/templates/stateful-resources"
  stateful_resources_output_path     = "${var.output_dir}/${local.stateful_resources_name}-stateful-resources"
  stateful_resources_app_file        = "stateful-resources-app.yaml"
  app_stateful_resources_output_path = "${var.output_dir}/app-yamls"
  stateful_resources                 = jsondecode(file(var.stateful_resources_config_file))
  enabled_stateful_resources         = { for stateful_resource in local.stateful_resources : stateful_resource.resource_name => stateful_resource if stateful_resource.enabled }
  managed_stateful_resources         = { for managed_resource in local.enabled_stateful_resources : managed_resource.resource_name => managed_resource if managed_resource.external_service }
  local_stateful_resources           = { for local_stateful_resource in local.enabled_stateful_resources : local_stateful_resource.resource_name => local_stateful_resource if !local_stateful_resource.external_service }
  local_external_name_map            = { for stateful_resource in local.local_stateful_resources : stateful_resource.logical_service_config.logical_service_name => stateful_resource.local_resource_config.override_service_name != null ? "${stateful_resource.local_resource_config.override_service_name}.${stateful_resource.local_resource_config.resource_namespace}.svc.cluster.local" : "${stateful_resource.resource_name}.${stateful_resource.local_resource_config.resource_namespace}.svc.cluster.local" }
  managed_external_name_map          = { for index, stateful_resource in local.managed_stateful_resources : stateful_resource.logical_service_config.logical_service_name => var.managed_db_host }  
  external_name_map                  = merge(local.local_external_name_map, local.managed_external_name_map)
  managed_resource_password_map = { for index, stateful_resource in local.managed_stateful_resources : stateful_resource.resource_name => {
    vault_path  = "${var.kv_path}/${var.cluster_name}/${stateful_resource.external_resource_config.password_key_name}"
    namespaces  = stateful_resource.logical_service_config.secret_extra_namespaces
    secret_name = stateful_resource.logical_service_config.user_password_secret
    secret_key  = stateful_resource.logical_service_config.user_password_secret_key
    }
  }

  stateful_resources_vars = {
    stateful_resources_namespace = var.stateful_resources_namespace
    gitlab_project_url           = var.gitlab_project_url
    stateful_resources_sync_wave = var.stateful_resources_sync_wave
    stateful_resources_name      = local.stateful_resources_name
  }
  all_logical_extra_namespaces = flatten([for stateful_resource in local.enabled_stateful_resources : stateful_resource.logical_service_config.secret_extra_namespaces])
  all_local_extra_namespaces   = flatten([for stateful_resource in local.local_stateful_resources : stateful_resource.local_resource_config.generate_secret_extra_namespaces])
  all_local_namespaces         = distinct([for stateful_resource in local.local_stateful_resources : stateful_resource.local_resource_config.resource_namespace])
}

variable "external_stateful_resource_instance_addresses" {
}

variable "create_stateful_resources_ns" {
  type        = bool
  description = "whether to create st res ns"
  default     = false
}

variable "gitlab_project_url" {
  type        = string
  description = "gitlab_project_url"
}

variable "cluster_name" {
  description = "Cluster name, lower case and without spaces. This will be used to set tags and name resources"
  type        = string
}

variable "gitlab_server_url" {
  type        = string
  description = "gitlab_server_url"
}

variable "current_gitlab_project_id" {
  type        = string
  description = "current_gitlab_project_id"
}

variable "kv_path" {
  description = "path for tenant kv engine"
  default     = "secret"
}

variable "stateful_resources_config_file" {
  default     = "../config/stateful-resources.json"
  type        = string
  description = "where to pull stateful resources config"
}

variable "stateful_resources_namespace" {
  type        = string
  description = "stateful_resources_namespace"
  default     = "stateful-resources"
}

variable "stateful_resources_name" {
  type        = string
  description = "stateful_resources_name"
}

variable "output_dir" {
  type        = string
  description = "output_dir"
}

variable "stateful_resources_sync_wave" {
  type        = string
  description = "stateful_resources_sync_wave, wait for vault config operator"
  default     = "-5"
}

variable "managed_db_host" {
  type        = string
  description = "url to managed db based on haproxy"
}