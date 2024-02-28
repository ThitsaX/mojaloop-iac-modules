terraform {
  source = "git::https://github.com/mojaloop/iac-modules.git//terraform/ansible/managed-services-deploy?ref=${get_env("IAC_TERRAFORM_MODULES_TAG")}"
}

dependency "managed_services" {
  config_path = "../managed-services"
  mock_outputs = {
    bastion_hosts          = {}
    bastion_hosts_var_maps = {}
    bastion_ssh_key        = "key"
    bastion_os_username    = "null"
    bastion_public_ip      = "null"
  }
  skip_outputs = local.skip_outputs
  mock_outputs_allowed_terraform_commands = local.skip_outputs ? ["init", "validate", "plan", "show", "apply"] : ["init", "validate", "plan", "show"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}


inputs = {
  bastion_hosts               = dependency.managed_services.outputs.bastion_hosts
  bastion_hosts_var_maps      = merge(dependency.managed_services.outputs.bastion_hosts_var_maps, local.bastion_hosts_var_maps)
  bastion_hosts_yaml_maps     = local.bastion_hosts_yaml_maps
  ansible_bastion_key         = dependency.managed_services.outputs.bastion_ssh_key
  ansible_bastion_os_username = dependency.managed_services.outputs.bastion_os_username
  ansible_bastion_public_ip   = dependency.managed_services.outputs.bastion_public_ip
  ansible_collection_tag      = local.env_map[local.CLUSTER_NAME].ansible_collection_tag
  ansible_base_output_dir     = local.ANSIBLE_BASE_OUTPUT_DIR
  ansible_playbook_name       = "managed_services_deploy"
}

locals {
  env_vars = yamldecode(
  file("${find_in_parent_folders("environment.yaml")}"))
  common_vars = yamldecode(file("${find_in_parent_folders("common-vars.yaml")}"))
  env_map = { for val in local.env_vars.envs :
    val["env"] => {
      cloud_region                         = val["cloud_region"]
      k8s_cluster_type                     = val["k8s_cluster_type"]
      cloud_platform                       = val["cloud_platform"]
      domain                               = val["domain"]
      iac_terraform_modules_tag            = val["iac_terraform_modules_tag"]
      ansible_collection_tag               = val["ansible_collection_tag"]
      enable_vault_oauth_to_gitlab         = val["enable_vault_oauth_to_gitlab"]
      enable_grafana_oauth_to_gitlab       = val["enable_grafana_oauth_to_gitlab"]
      letsencrypt_email                    = val["letsencrypt_email"]
      dns_zone_force_destroy               = val["dns_zone_force_destroy"]
      longhorn_backup_object_store_destroy = val["longhorn_backup_object_store_destroy"]
      enable_k6s_test_harness              = val["enable_k6s_test_harness"]
      k6s_docker_server_instance_type      = val["k6s_docker_server_instance_type"]
      vpc_cidr                             = val["vpc_cidr"]
    }
  }
  skip_outputs            = get_env("CI_COMMIT_BRANCH") != get_env("CI_DEFAULT_BRANCH")
  ANSIBLE_BASE_OUTPUT_DIR = get_env("ANSIBLE_BASE_OUTPUT_DIR")
  K8S_CLUSTER_TYPE        = get_env("K8S_CLUSTER_TYPE")
  CLUSTER_NAME            = get_env("CLUSTER_NAME")
  bastion_hosts_yaml_maps = {
    netmaker_join_tokens = yamlencode([get_env("NETMAKER_ENV_TOKEN")])
  }
  bastion_hosts_var_maps = {
    netmaker_master_key = get_env("METMAKER_MASTER_KEY")
    netmaker_api_host   = get_env("NETMAKER_HOST_NAME")
  }
}

include "root" {
  path = find_in_parent_folders()
}

skip = get_env("CI_COMMIT_BRANCH") != get_env("CI_DEFAULT_BRANCH")
