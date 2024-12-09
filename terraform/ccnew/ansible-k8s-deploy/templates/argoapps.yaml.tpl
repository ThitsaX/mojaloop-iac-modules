argocd_override:
  initial_application_gitrepo_tag: "${iac_terraform_modules_tag}"
  apps:        
    utils:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        argocd_helm:
          public_ingress_access_domain: "${argocd_public_access}"
          helm_version: "${argocd_helm_version}"
        rook_ceph:
          helm_version: "${rook_ceph_helm_version}"
          image_version: "${rook_ceph_image_version}"
          rook_csi_kubelet_dir_path: "${rook_csi_kubelet_dir_path}"
          cloud_platform: "${cloud_platform}"
          mon_volumes_storage_class: "${rook_ceph_mon_volumes_storage_class}"
          mon_volume_size: "${rook_ceph_mon_volumes_size}"
          osd_volumes_storage_class: "${rook_ceph_osd_volumes_storage_class}"
          cloud_pv_reclaim_policy: "${rook_ceph_cloud_pv_reclaim_policy}"
          osd_count: "${rook_ceph_osd_count}"
          volume_size_per_osd: "${rook_ceph_volume_size_per_osd}"
          csi_driver_replicas: "${rook_ceph_csi_driver_replicas}"
          objects_replica_count: "${rook_ceph_objects_replica_count}"
          volumes_provider: "${rook_ceph_volumes_provider}"
          volumes_storage_region: "${cloud_region}"
          cluster_domain: "${cluster_domain}"
        reflector:
          helm_version: "${reflector_helm_version}"
        reloader:
          helm_version: "${reloader_helm_version}"
        crossplane:
          helm_version: "${crossplane_helm_version}"
          debug: "${crossplane_log_level}"
        kubernetes_secret_generator:
          helm_version: "${kubernetes_secret_generator_helm_version}"
        external_secrets:
          helm_version: "${external_secrets_helm_version}"
        istio:
          proxy_log_level: "${istio_proxy_log_level}"
          helm_version: "${istio_helm_version}"
          external_ingress_https_port: "'${external_ingress_https_port}'"
          external_ingress_http_port: "'${external_ingress_http_port}'"
          external_ingress_health_port: "'${external_ingress_health_port}'"
          internal_ingress_https_port: "'${internal_ingress_https_port}'"
          internal_ingress_http_port: "'${internal_ingress_http_port}'"
          internal_ingress_health_port: "'${internal_ingress_health_port}'"
        cert_manager:
          helm_version: "${cert_manager_helm_version}"
        base_monitoring:
          grafana_crd_version_tag: "${grafana_crd_version_tag}"
          prometheus_crd_version: "${prometheus_crd_version}"
          grafana_operator_version: "${grafana_operator_version}"
        consul:
          helm_version: "${consul_helm_version}"
          replicas: "'${consul_replica_count}'"
          storage_size: "${consul_storage_size}"
        post_config:
          vault_crossplane_modules_version: "${vault_crossplane_modules_version}"
          terraform_crossplane_modules_version: "${terraform_crossplane_modules_version}"
          ansible_crossplane_modules_version: "${ansible_crossplane_modules_version}"
          aws_crossplane_module_version:  "${aws_crossplane_module_version}"          
          crossplane_func_pat_version: "${crossplane_func_pat_version}"
          k8s_crossplane_module_version: "${k8s_crossplane_module_version}"
          crossplane_func_go_templating_version: "${crossplane_func_go_templating_version}"
    maintenance:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        velero:
          app_name: "velero"
          helm_version: "${velero_helm_version}"
          object_storage_cloud_role: "${object_storage_cloud_role}"
          enable_object_storage_backend: "'${enable_object_storage_backend}'"
          object_storage_region: "${cloud_region}"
          object_storage_bucket: "${object_storage_bucket_name}"
          plugin_version: "${velero_plugin_version}"
    dns_utils:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        ext_dns:
          helm_version: "${external_dns_helm_version}"
        cr_config:
          internal_load_balancer_dns: "${internal_load_balancer_dns}"
          external_load_balancer_dns: "${external_load_balancer_dns}"
          dns_public_subdomain: "${dns_public_subdomain}"
          dns_private_subdomain: "${dns_private_subdomain}"
          external_dns_cloud_role: "${external_dns_cloud_role}"
          cert_manager_cloud_policy: "${cert_manager_cloud_policy}"
          letsencrypt_email: "${letsencrypt_email}"
          dns_cloud_api_region: "${cloud_region}"
    xplane_provider_config:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"

    k8s_config:
      k8s_cloud_region: "${cloud_region}"
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      terraform_modules_tag: "${iac_terraform_modules_tag}"
      k8s_cluster_type: "${k8s_cluster_type}"
      eks_name: "${eks_name}"
    vault:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        vault:
          helm_version: "${vault_helm_version}"
          public_ingress_access_domain: "${vault_public_access}"
          vault_tf_provider_version: "${vault_tf_provider_version}"
          vault_terraform_modules_tag: "${iac_terraform_modules_tag}"
          vault_log_level: "${vault_log_level}"
          cloud_platform_api_client_id: "${cloud_platform_api_client_id}"
          cloud_platform_api_client_secret: "${cloud_platform_api_client_secret}"
        vault_config_operator:
          helm_version: "${vault_config_operator_helm_version}"
    security:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        zitadel:
          replicas: "${zitadel_replicas}"
          public_ingress_access_domain: "${zitadel_public_access}"
          terraform_modules_tag: "${iac_terraform_modules_tag}"
          helm_version: "${zitadel_helm_version}"
          zitadel_tf_provider_version: "${zitadel_tf_provider_version}"
          vault_rbac_admin_group: "${vault_rbac_admin_group}"
          argocd_user_rbac_group: "${argocd_user_rbac_group}"
          argocd_admin_rbac_group: "${argocd_admin_rbac_group}"
          log_level: "${zitadel_log_level}"
          rdbms_provider: "${zitadel_rdbms_provider}"
        zitadel_percona_provider:
          postgres_replicas: "${zitadel_postgres_replicas}"
          postgres_proxy_replicas: "${zitadel_postgres_proxy_replicas}"
          postgres_storage_size: "${zitadel_postgres_storage_size}"
          pgdb_helm_version: "${zitadel_pgdb_helm_version}"          
        zitadel_rds_provider:
          engine: "${zitadel_rds_engine}"
          engine_version: "${zitadel_rds_engine_version}"
          replica_count: "${zitadel_rds_replica_count}"
          postgres_instance_class: "${zitadel_rds_instance_class}"
          storage_encrypted: "${zitadel_rds_storage_encrypted}"
          skip_final_snapshot: "${zitadel_rds_skip_final_snapshot}"
          rdbms_subnet_list: "${join(",", rdbms_subnet_list)}"
          db_provider_cloud_region: "${cloud_region}"
          rdbms_vpc_id: "${rdbms_vpc_id}"
          vpc_cidr: "${vpc_cidr}"
          postgres_instance_size: "${zitadel_postgres_instance_size}"
          postgres_storage_size: "${zitadel_rds_postgres_storage_size}"
          backup_retention_period: "${zitadel_db_backup_retention_period}"
          preferred_backup_window: "${zitadel_db_preferred_backup_window}"
          storage_type: "${zitadel_db_storage_type}"
          storage_iops: "${zitadel_db_storage_iops}"       
        zitadel_cockroachdb_provider:                    
          helm_version: "${cockroachdb_helm_version}"
          pvc_size: "${zitadel_db_storage_size}"
        netbird:
          stunner_nodeport_port: "'${wireguard_ingress_port}'"
          terraform_modules_tag: "${iac_terraform_modules_tag}"
          public_ingress_access_domain: "${netbird_public_access}"
          helm_version: "${netbird_helm_version}"
          image_version: "${netbird_image_version}"
          client_version: "${netbird_client_version}"
          dashboard_image_version: "${netbird_dashboard_image_version}"
          stunner_gateway_operator_helm_version: "${stunner_gateway_operator_helm_version}"
          log_level: "${netbird_log_level}"
          cc_vpc_cidr: "${vpc_cidr}"
          ansible_collection_tag: ${netbird_ansible_collection_tag}
          netbird_tf_provider_version: "${netbird_tf_provider_version}"
    nexus:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        nexus:
          helm_version: "${nexus_helm_version}"
          public_ingress_access_domain: "${nexus_public_access}"
          storage_size: "${nexus_storage_size}"
        post_config:
          ansible_collection_tag: "${nexus_ansible_collection_tag}"

    gitlab:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        gitlab:
          helm_version: "${gitlab_helm_version}"
          public_ingress_access_domain: "${gitlab_public_access}"
          terraform_modules_tag: "${iac_terraform_modules_tag}"
          gitaly_storage_size: "${gitaly_storage_size}"
        pre:
          #  object storage bucket configuration
          gitlab_artifacts_max_objects: "${gitlab_artifacts_max_objects}"
          gitlab_artifacts_storage_size: "${gitlab_artifacts_storage_size}"
          git_lfs_max_objects: "${git_lfs_max_objects}"
          git_lfs_storage_size: "${git_lfs_storage_size}"
          gitlab_artifacts_storage_size: "${gitlab_artifacts_storage_size}"
          gitlab_uploads_max_objects: "${gitlab_uploads_max_objects}"
          gitlab_uploads_storage_size: "${gitlab_uploads_storage_size}"
          gitlab_packages_max_objects: "${gitlab_packages_max_objects}"
          gitlab_packages_storage_size: "${gitlab_packages_storage_size}"
          gitlab_mrdiffs_max_objects: "${gitlab_mrdiffs_max_objects}"
          gitlab_mrdiffs_storage_size: "${gitlab_mrdiffs_storage_size}"
          gitlab_tfstate_max_objects: "${gitlab_tfstate_max_objects}"
          gitlab_tfstate_storage_size: "${gitlab_tfstate_storage_size}"
          gitlab_cisecurefiles_max_objects: "${gitlab_cisecurefiles_max_objects}"
          gitlab_cisecurefiles_storage_size: "${gitlab_cisecurefiles_storage_size}"
          gitlab_dep_proxy_max_objects: "${gitlab_dep_proxy_max_objects}"
          gitlab_dep_proxy_storage_size: "${gitlab_dep_proxy_storage_size}"
          gitlab_registry_max_objects: "${gitlab_registry_max_objects}"
          gitlab_registry_storage_size: "${gitlab_registry_storage_size}"
          gitlab_runner_cache_max_objects: "${gitlab_runner_cache_max_objects}"
          gitlab_runner_cache_storage_size: "${gitlab_runner_cache_storage_size}"
          # redis
          redis_cluster_size: "${gitlab_redis_cluster_size}"
          redis_storage_size: "${gitlab_redis_storage_size}"
          rdbms_provider: "${gitlab_postgres_rdbms_provider}"
        webdb_percona_provider:            
          postgres_replicas: "${gitlab_postgres_replicas}"
          postgres_proxy_replicas: "${gitlab_postgres_proxy_replicas}"
          postgres_storage_size: "${gitlab_postgres_storage_size}"
          pgdb_helm_version: "${gitlab_pgdb_helm_version}"
        praefectdb_percona_provider:
          postgres_replicas: "${gitlab_praefect_postgres_replicas}"
          postgres_proxy_replicas: "${gitlab_praefect_postgres_proxy_replicas}"          
          postgres_storage_size: "${gitlab_praefect_postgres_storage_size}"
          pgdb_helm_version: "${gitlab_praefect_pgdb_helm_version}"
        webdb_rds_provider:
          engine: "${gitlab_rds_engine}"
          engine_version: "${gitlab_rds_engine_version}"
          replica_count: "${gitlab_rds_replica_count}"          
          postgres_instance_class: "${gitlab_rds_instance_class}"
          storage_encrypted: "${gitlab_rds_storage_encrypted}"
          skip_final_snapshot: "${gitlab_rds_skip_final_snapshot}"        
          rdbms_subnet_list: "${join(",", rdbms_subnet_list)}"
          db_provider_cloud_region: "${cloud_region}"
          rdbms_vpc_id: "${rdbms_vpc_id}"
          vpc_cidr: "${vpc_cidr}"
          postgres_instance_size: "${gitlab_postgres_instance_size}"
          postgres_storage_size: "${gitlab_rds_postgres_storage_size}"
          backup_retention_period: "${gitlab_db_backup_retention_period}"
          preferred_backup_window: "${gitlab_db_preferred_backup_window}"
          storage_type: "${gitlab_db_storage_type}"
          storage_iops: "${gitlab_db_storage_iops}"
        praefectdb_rds_provider:
          engine: "${praefect_rds_engine}"
          engine_version: "${praefect_rds_engine_version}"
          replica_count: "${praefect_rds_replica_count}"                     
          postgres_instance_class: "${praefect_rds_instance_class}"
          storage_encrypted: "${praefect_rds_storage_encrypted}"
          skip_final_snapshot: "${praefect_rds_skip_final_snapshot}"        
          rdbms_subnet_list: "${join(",", rdbms_subnet_list)}"
          db_provider_cloud_region: "${cloud_region}"
          rdbms_vpc_id: "${rdbms_vpc_id}"
          vpc_cidr: "${vpc_cidr}"
          postgres_instance_size: "${gitlab_postgres_instance_size}"
          postgres_storage_size: "${gitlab_praefect_rds_postgres_storage_size}"         
          backup_retention_period: "${praefect_db_backup_retention_period}"
          preferred_backup_window: "${praefect_db_preferred_backup_window}"
          storage_type: "${praefect_db_storage_type}"
          storage_iops: "${praefect_db_storage_iops}"

          
    deploy_env:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        config:
          environment_list:  "${join(",", environment_list)}"
          terraform_modules_tag: "${iac_terraform_modules_tag}"
          ceph_bucket_max_objects: "${ceph_bucket_max_objects}"
          ceph_bucket_max_size:  "${ceph_bucket_max_size}"
          env_token_ttl: "${env_token_ttl}"
        onboard:
          terraform_modules_tag: "${iac_terraform_modules_tag}"          


    monitoring:
      application_gitrepo_tag: "${iac_terraform_modules_tag}"
      sub_apps:
        pre:
          mimir_bucket_name: "${mimir_bucket_name}"
          mimir_bucket_max_objects: "${mimir_bucket_max_objects}"
          mimir_bucket_storage_size: "${mimir_bucket_storage_size}"
        monitoring:
          kube_prometheus_helm_version: "${kube_prometheus_helm_version}"
          grafana_mimir_helm_version: "${grafana_mimir_helm_version}"
          prometheus_pvc_size: "${prometheus_pvc_size}"
          prometheus_retention_period: "${prometheus_retention_period}"
          alertmanager_enabled: "${alertmanager_enabled}"
        grafana:
          public_ingress_access_domain: "${grafana_public_access}"
          tf_provider_version: "${grafana_tf_provider_version}"
          image_version: "${grafana_image_version}"
        mimir:
          max_label_names_per_series: "${mimir_max_label_names_per_series}"
          max_global_series_per_user: "${mimir_max_global_series_per_user}"
          ingestion_rate: "${mimir_ingestion_rate}"
          ingestion_burst_size: "${mimir_ingestion_burst_size}"
          retention_period: "${mimir_retention_period}"
          compactor_deletion_delay: "${mimir_compactor_deletion_delay}"
          distributor_replica_count: "${mimir_distributor_replica_count}"
          ingester_replica_count: "${mimir_ingester_replica_count}"
          querier_replica_count: "${mimir_querier_replica_count}"
          query_frontend_replica_count: "${mimir_query_frontend_replica_count}"
          compactor_replica_count: "${mimir_compactor_replica_count}"
          store_gateway_replica_count: "${mimir_store_gateway_replica_count}"
          ingester_storage_size: "${mimir_ingester_storage_size}"
          compactor_storage_size: "${mimir_compactor_storage_size}"
          store_gateway_storage_size: "${mimir_store_gateway_storage_size}"
          distributor_limits_cpu: "${mimir_distributor_limits_cpu}"
          distributor_limits_memory: "${mimir_distributor_limits_memory}"
          ingester_limits_cpu: "${mimir_ingester_limits_cpu}"
          ingester_limits_memory: "${mimir_ingester_limits_memory}"
          querier_limits_cpu: "${mimir_querier_limits_cpu}"
          querier_limits_memory: "${mimir_querier_limits_memory}"
          query_frontend_limits_cpu: "${mimir_query_frontend_limits_cpu}"
          query_frontend_limits_memory: "${mimir_query_frontend_limits_memory}"
          compactor_limits_cpu: "${mimir_compactor_limits_cpu}"
          compactor_limits_memory: "${mimir_compactor_limits_memory}"
          store_gateway_limits_cpu: "${mimir_store_gateway_limits_cpu}"
          store_gateway_limits_memory: "${mimir_store_gateway_limits_memory}"
        post_config:
          terraform_modules_tag: "${iac_terraform_modules_tag}"
