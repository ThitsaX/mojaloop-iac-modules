## @section Global parameters
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry, imagePullSecrets and storageClass
##

## @param global.imageRegistry Global Docker image registry
## @param global.imagePullSecrets Global Docker registry secret names as an array
## @param global.storageClass Global StorageClass for Persistent Volume(s)
##
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  storageClass: ""

## @section Common parameters
##

## @param kubeVersion Force target Kubernetes version (using Helm capabilities if not set)
##
kubeVersion: ""
## @param nameOverride String to partially override common.names.fullname template (will maintain the release name)
##
nameOverride: ${key}
## @param fullnameOverride String to fully override common.names.fullname template
##
fullnameOverride: ""

## @param serviceBindings.enabled Create secret for service binding (Experimental)
## Ref: https://servicebinding.io/service-provider/


## Enable diagnostic mode in the deployment
##
diagnosticMode:
  ## @param diagnosticMode.enabled Enable diagnostic mode (all probes will be disabled and the command will be overridden)
  ##
  enabled: false
  ## @param diagnosticMode.command Command to override all containers in the deployment
  ##
  command:
    - sleep
  ## @param diagnosticMode.args Args to override all containers in the deployment
  ##
  args:
    - infinity

## @section MySQL common parameters
##

## Bitnami MySQL image
## ref: https://hub.docker.com/r/bitnami/mysql/tags/
## @param image.registry MySQL image registry
## @param image.repository MySQL image repository
## @param image.tag MySQL image tag (immutable tags are recommended)
## @param image.digest MySQL image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
## @param image.pullPolicy MySQL image pull policy
## @param image.pullSecrets Specify docker-registry secret names as an array
## @param image.debug Specify if debug logs should be enabled
##
image:
  ## Specify a imagePullPolicy
  ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
  ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  pullPolicy: IfNotPresent
  ## Optionally specify an array of imagePullSecrets (secrets must be manually created in the namespace)
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
  ## Example:
  ## pullSecrets:
  ##   - myRegistryKeySecretName
  ##
  pullSecrets: []
  ## Set to true if you would like to see extra information on logs
  ## It turns BASH and/or NAMI debugging in the image
  ##
  debug: false
## @param architecture MySQL architecture (`standalone` or `replication`)
##
architecture: ${resource.local_helm_config.mysql_data.architecture}
## MySQL Authentication parameters
##
auth:
  ## @param auth.rootPassword Password for the `root` user. Ignored if existing secret is provided
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/mysql#setting-the-root-password-on-first-run
  ##
  rootPassword: "${resource.local_helm_config.mysql_data.root_password}"
  ## @param auth.database Name for a custom database to create
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/mysql#creating-a-database-on-first-run
  ##
  database: ${resource.local_helm_config.mysql_data.database_name}
  ## @param auth.username Name for a custom user to create
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/mysql#creating-a-database-user-on-first-run
  ##
  username: ${resource.local_helm_config.mysql_data.user}
  ## @param auth.replicationUser MySQL replication user
  ## ref: https://github.com/bitnami/bitnami-docker-mysql#setting-up-a-replication-cluster
  ##
  password: "${resource.local_helm_config.mysql_data.user_password}"
  ## @param auth.replicationUser MySQL replication user
  ## ref: https://github.com/bitnami/containers/tree/main/bitnami/mysql#setting-up-a-replication-cluster
  ##
  replicationUser: replicator
  ## @param auth.replicationPassword MySQL replication user password. Ignored if existing secret is provided
  ##
  replicationPassword: "${resource.local_helm_config.mysql_data.root_password}"

  existingSecret: "${resource.local_helm_config.mysql_data.existing_secret}"

## @section MySQL Primary parameters
##

primary:
  ## @param primary.name Name of the primary database (eg primary, master, leader, ...)
  ##
  name: primary
  ## @param primary.command Override default container command on MySQL Primary container(s) (useful when using custom images)
  ##
  command: []
  ## @param primary.args Override default container args on MySQL Primary container(s) (useful when using custom images)
  ##
  args: []
  ## @param primary.lifecycleHooks for the MySQL Primary container(s) to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## @param primary.hostAliases Deployment pod host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param primary.configuration [string] Configure MySQL Primary with a custom my.cnf file
  ## ref: https://mysql.com/kb/en/mysql/configuring-mysql-with-mycnf/#example-of-configuration-file
  ##
  configuration: |-
    [mysqld]
    default_authentication_plugin=${resource.local_helm_config.mysql_data.default_authentication_plugin}
    skip-name-resolve
    explicit_defaults_for_timestamp
    basedir=${resource.local_helm_config.mysql_data.basedir}
    plugin_dir=${resource.local_helm_config.mysql_data.plugin_dir}
    port=${resource.local_helm_config.mysql_data.port}
    socket=${resource.local_helm_config.mysql_data.socket}
    datadir=${resource.local_helm_config.mysql_data.datadir}
    tmpdir=${resource.local_helm_config.mysql_data.tmpdir}
    max_allowed_packet=${resource.local_helm_config.mysql_data.max_allowed_packet}
    bind-address=${resource.local_helm_config.mysql_data.bind-address}
    pid-file=${resource.local_helm_config.mysql_data.pid-file}
    log-error=${resource.local_helm_config.mysql_data.log-error}
    character-set-server=${resource.local_helm_config.mysql_data.character-set-server}
    collation-server=${resource.local_helm_config.mysql_data.collation-server}
    general_log=${resource.local_helm_config.mysql_data.general_log}
    slow_query_log=${resource.local_helm_config.mysql_data.slow_query_log}
    slow_query_log_file=/opt/bitnami/mysql/logs/mysqld.log
    long_query_time=${resource.local_helm_config.mysql_data.long_query_time}
    innodb_use_native_aio=${resource.local_helm_config.mysql_data.innodb_use_native_aio}
    max_connections=${resource.local_helm_config.mysql_data.max_connections}
    innodb_buffer_pool_size=${resource.local_helm_config.mysql_data.innodb_buffer_pool_size}

    [client]
    port=${resource.local_helm_config.mysql_data.port}
    socket=${resource.local_helm_config.mysql_data.socket}
    default-character-set=UTF8
    plugin_dir=${resource.local_helm_config.mysql_data.plugin_dir}

    [manager]
    port=${resource.local_helm_config.mysql_data.port}
    socket=${resource.local_helm_config.mysql_data.socket}
    pid-file=${resource.local_helm_config.mysql_data.pid-file}
  ## @param primary.existingConfigmap Name of existing ConfigMap with MySQL Primary configuration.
  ## NOTE: When it's set the 'configuration' parameter is ignored
  ##
  existingConfigmap: ""
  ## @param primary.updateStrategy.type Update strategy type for the MySQL primary statefulset
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    type: RollingUpdate
  ## @param primary.podAnnotations Additional pod annotations for MySQL primary pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param primary.podAffinityPreset MySQL primary pod affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podLabels:
    sidecar.istio.io/inject: "false"
  podAffinityPreset: ""
  ## @param primary.podAntiAffinityPreset MySQL primary pod anti-affinity preset. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## MySQL Primary node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param primary.nodeAffinityPreset.type MySQL primary node affinity preset type. Ignored if `primary.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param primary.nodeAffinityPreset.key MySQL primary node label key to match Ignored if `primary.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param primary.nodeAffinityPreset.values MySQL primary node label values to match. Ignored if `primary.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param primary.affinity Affinity for MySQL primary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: podAffinityPreset, podAntiAffinityPreset, and  nodeAffinityPreset will be ignored when it's set
  ##
%{ if resource.local_helm_config.mysql_data.affinity_definition != null ~}
  affinity:
    ${indent(4, yamlencode(resource.local_helm_config.mysql_data.affinity_definition))}
%{ else ~}
  affinity: {}
%{ endif ~}
  ## @param primary.nodeSelector Node labels for MySQL primary pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param primary.tolerations Tolerations for MySQL primary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param primary.priorityClassName MySQL primary pods' priorityClassName
  ##
  priorityClassName: ""
  ## @param primary.runtimeClassName MySQL primary pods' runtimeClassName
  ##
  runtimeClassName: ""
  ## @param primary.schedulerName Name of the k8s scheduler (other than default)
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param primary.terminationGracePeriodSeconds In seconds, time the given to the MySQL primary pod needs to terminate gracefully
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
  ##
  terminationGracePeriodSeconds: ""
  ## @param primary.topologySpreadConstraints Topology Spread Constraints for pod assignment
  ## https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## The value is evaluated as a template
  ##
  topologySpreadConstraints: []
  ## @param primary.podManagementPolicy podManagementPolicy to manage scaling operation of MySQL primary pods
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-management-policies
  ##
  podManagementPolicy: ""
  ## MySQL primary Pod security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param primary.podSecurityContext.enabled Enable security context for MySQL primary pods
  ## @param primary.podSecurityContext.fsGroup Group ID for the mounted volumes' filesystem
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## MySQL primary container security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param primary.containerSecurityContext.enabled MySQL primary container securityContext
  ## @param primary.containerSecurityContext.runAsUser User ID for the MySQL primary container
  ## @param primary.containerSecurityContext.runAsNonRoot Set MySQL primary container's Security Context runAsNonRoot
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsNonRoot: true
  ## MySQL primary container's resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param primary.resources.limits The resources limits for MySQL primary containers
  ## @param primary.resources.requests The requested resources for MySQL primary containers
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    requests: {}
  ## Configure extra options for liveness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param primary.livenessProbe.enabled Enable livenessProbe
  ## @param primary.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param primary.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param primary.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param primary.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param primary.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## Configure extra options for readiness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param primary.readinessProbe.enabled Enable readinessProbe
  ## @param primary.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param primary.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param primary.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param primary.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param primary.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## Configure extra options for startupProbe probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param primary.startupProbe.enabled Enable startupProbe
  ## @param primary.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param primary.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param primary.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param primary.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param primary.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: true
    initialDelaySeconds: 15
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 10
    successThreshold: 1
  ## @param primary.customLivenessProbe Override default liveness probe for MySQL primary containers
  ##
  customLivenessProbe: {}
  ## @param primary.customReadinessProbe Override default readiness probe for MySQL primary containers
  ##
  customReadinessProbe: {}
  ## @param primary.customStartupProbe Override default startup probe for MySQL primary containers
  ##
  customStartupProbe: {}
  ## @param primary.extraFlags MySQL primary additional command line flags
  ## Can be used to specify command line flags, for example:
  ## E.g.
  ## extraFlags: "--max-connect-errors=1000 --max_connections=155"
  ##
  extraFlags: ""
  ## @param primary.extraEnvVars Extra environment variables to be set on MySQL primary containers
  ## E.g.
  ## extraEnvVars:
  ##  - name: TZ
  ##    value: "Europe/Paris"
  ##
  extraEnvVars: []
  ## @param primary.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for MySQL primary containers
  ##
  extraEnvVarsCM: ""
  ## @param primary.extraEnvVarsSecret Name of existing Secret containing extra env vars for MySQL primary containers
  ##
  extraEnvVarsSecret: ""
  ## @param primary.extraPorts Extra ports to expose
  ##
  extraPorts: []
  ## Enable persistence using Persistent Volume Claims
  ## ref: https://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence:
    ## @param primary.persistence.enabled Enable persistence on MySQL primary replicas using a `PersistentVolumeClaim`. If false, use emptyDir
    ##
    enabled: true
    ## @param primary.persistence.existingClaim Name of an existing `PersistentVolumeClaim` for MySQL primary replicas
    ## NOTE: When it's set the rest of persistence parameters are ignored
    ##
    existingClaim: ""
    ## @param primary.persistence.subPath The name of a volume's sub path to mount for persistence
    ##
    subPath: ""
    ## @param primary.persistence.storageClass MySQL primary persistent volume storage Class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is
    ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
    ##   GKE, AWS & OpenStack)
    ##
    storageClass: ${resource.local_helm_config.mysql_data.storage_class_name}
    ## @param primary.persistence.annotations [object] MySQL primary persistent volume claim annotations
    ##
    annotations: {}
    ## @param primary.persistence.accessModes MySQL primary persistent volume access Modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param primary.persistence.size MySQL primary persistent volume size
    ##
    size: ${resource.local_helm_config.mysql_data.storage_size}
    ## @param primary.persistence.selector [object] Selector to match an existing Persistent Volume
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
  ## @param primary.extraVolumes Optionally specify extra list of additional volumes to the MySQL Primary pod(s)
  ##
  extraVolumes: []
  ## @param primary.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the MySQL Primary container(s)
  ##
  extraVolumeMounts: []
  ## @param primary.initContainers Add additional init containers for the MySQL Primary pod(s)
  ##
  initContainers: []
  ## @param primary.sidecars Add additional sidecar containers for the MySQL Primary pod(s)
  ##
  sidecars: []
  ## MySQL Primary Service parameters
  ##
  service:
    ## @param primary.service.type MySQL Primary K8s service type
    ##
    type: ClusterIP
    ## @param primary.service.ports.mysql MySQL Primary K8s service port
    ##
    ports:
      mysql: ${resource.local_helm_config.mysql_data.service_port}
## @section MySQL Secondary parameters
##

secondary:
  ## @param secondary.name Name of the secondary database (eg secondary, slave, ...)
  ##
  name: secondary
  ## @param secondary.replicaCount Number of MySQL secondary replicas
  ##
  replicaCount: ${resource.local_helm_config.mysql_data.replica_count}

  ## @param secondary.configuration [string] Configure MySQL Secondary with a custom my.cnf file
  ## ref: https://mysql.com/kb/en/mysql/configuring-mysql-with-mycnf/#example-of-configuration-file
  ##
  configuration: |-
    [mysqld]
    default_authentication_plugin=${resource.local_helm_config.mysql_data.default_authentication_plugin}
    skip-name-resolve
    explicit_defaults_for_timestamp
    basedir=/opt/bitnami/mysql
    plugin_dir=${resource.local_helm_config.mysql_data.plugin_dir}
    port=${resource.local_helm_config.mysql_data.port}
    socket=${resource.local_helm_config.mysql_data.socket}
    datadir=${resource.local_helm_config.mysql_data.datadir}
    tmpdir=${resource.local_helm_config.mysql_data.tmpdir}
    max_allowed_packet=${resource.local_helm_config.mysql_data.max_allowed_packet}
    bind-address=${resource.local_helm_config.mysql_data.bind-address}
    pid-file=${resource.local_helm_config.mysql_data.pid-file}
    log-error=/opt/bitnami/mysql/logs/mysqld.log
    character-set-server=UTF8
    collation-server=utf8_general_ci
    general_log=${resource.local_helm_config.mysql_data.general_log}
    slow_query_log=${resource.local_helm_config.mysql_data.slow_query_log}
    slow_query_log_file=/opt/bitnami/mysql/logs/mysqld.log
    long_query_time=10.0
    innodb_use_native_aio=0

    [client]
    port=${resource.local_helm_config.mysql_data.port}
    socket=${resource.local_helm_config.mysql_data.socket}
    default-character-set=UTF8
    plugin_dir=${resource.local_helm_config.mysql_data.plugin_dir}

    [manager]
    port=${resource.local_helm_config.mysql_data.port}
    socket=${resource.local_helm_config.mysql_data.socket}
    pid-file=${resource.local_helm_config.mysql_data.pid-file}
  ## @param secondary.existingConfigmap Name of existing ConfigMap with MySQL Secondary configuration.
  ## NOTE: When it's set the 'configuration' parameter is ignored
  ##
  existingConfigmap: ""
  ## @param secondary.updateStrategy.type Update strategy type for the MySQL secondary statefulset
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    type: RollingUpdate
  ## @param secondary.podAnnotations Additional pod annotations for MySQL secondary pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param secondary.podAffinityPreset MySQL secondary pod affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podLabels:
    sidecar.istio.io/inject: "false"
  podAffinityPreset: ""
  ## @param secondary.podAntiAffinityPreset MySQL secondary pod anti-affinity preset. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ## Allowed values: soft, hard
  ##
  podAntiAffinityPreset: soft
  ## MySQL Secondary node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param secondary.nodeAffinityPreset.type MySQL secondary node affinity preset type. Ignored if `secondary.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param secondary.nodeAffinityPreset.key MySQL secondary node label key to match Ignored if `secondary.affinity` is set.
    ## E.g.
    ## key: "kubernetes.io/e2e-az-name"
    ##
    key: ""
    ## @param secondary.nodeAffinityPreset.values MySQL secondary node label values to match. Ignored if `secondary.affinity` is set.
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param secondary.affinity Affinity for MySQL secondary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## Note: podAffinityPreset, podAntiAffinityPreset, and  nodeAffinityPreset will be ignored when it's set
  ##
%{ if resource.local_helm_config.mysql_data.affinity_definition != null ~}
  affinity:
    ${indent(4, yamlencode(resource.local_helm_config.mysql_data.affinity_definition))}
%{ else ~}
  affinity: {}
%{ endif ~}
  ## @param secondary.nodeSelector Node labels for MySQL secondary pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param secondary.tolerations Tolerations for MySQL secondary pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param secondary.priorityClassName MySQL secondary pods' priorityClassName
  ##
  priorityClassName: ""
  ## @param secondary.runtimeClassName MySQL secondary pods' runtimeClassName
  ##
  runtimeClassName: ""
  ## @param secondary.schedulerName Name of the k8s scheduler (other than default)
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param secondary.terminationGracePeriodSeconds In seconds, time the given to the MySQL secondary pod needs to terminate gracefully
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods
  ##
  terminationGracePeriodSeconds: ""
  ## @param secondary.topologySpreadConstraints Topology Spread Constraints for pod assignment
  ## https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## The value is evaluated as a template
  ##
  topologySpreadConstraints: []
  ## @param secondary.podManagementPolicy podManagementPolicy to manage scaling operation of MySQL secondary pods
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-management-policies
  ##
  podManagementPolicy: ""
  ## MySQL secondary Pod security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param secondary.podSecurityContext.enabled Enable security context for MySQL secondary pods
  ## @param secondary.podSecurityContext.fsGroup Group ID for the mounted volumes' filesystem
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## MySQL secondary container security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param secondary.containerSecurityContext.enabled MySQL secondary container securityContext
  ## @param secondary.containerSecurityContext.runAsUser User ID for the MySQL secondary container
  ## @param secondary.containerSecurityContext.runAsNonRoot Set MySQL secondary container's Security Context runAsNonRoot
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsNonRoot: true
  ## MySQL secondary container's resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param secondary.resources.limits The resources limits for MySQL secondary containers
  ## @param secondary.resources.requests The requested resources for MySQL secondary containers
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 250m
    ##    memory: 256Mi
    ##
    requests: {}
  ## Configure extra options for liveness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param secondary.livenessProbe.enabled Enable livenessProbe
  ## @param secondary.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param secondary.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param secondary.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param secondary.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param secondary.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## Configure extra options for readiness probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param secondary.readinessProbe.enabled Enable readinessProbe
  ## @param secondary.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param secondary.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param secondary.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param secondary.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param secondary.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 3
    successThreshold: 1
  ## Configure extra options for startupProbe probe
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param secondary.startupProbe.enabled Enable startupProbe
  ## @param secondary.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param secondary.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param secondary.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param secondary.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param secondary.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: true
    initialDelaySeconds: 15
    periodSeconds: 10
    timeoutSeconds: 1
    failureThreshold: 15
    successThreshold: 1
  ## @param secondary.customLivenessProbe Override default liveness probe for MySQL secondary containers
  ##
  customLivenessProbe: {}
  ## @param secondary.customReadinessProbe Override default readiness probe for MySQL secondary containers
  ##
  customReadinessProbe: {}
  ## @param secondary.customStartupProbe Override default startup probe for MySQL secondary containers
  ##
  customStartupProbe: {}
  ## @param secondary.extraFlags MySQL secondary additional command line flags
  ## Can be used to specify command line flags, for example:
  ## E.g.
  ## extraFlags: "--max-connect-errors=1000 --max_connections=155"
  ##
  extraFlags: ""
  ## @param secondary.extraEnvVars An array to add extra environment variables on MySQL secondary containers
  ## E.g.
  ## extraEnvVars:
  ##  - name: TZ
  ##    value: "Europe/Paris"
  ##
  extraEnvVars: []
  ## @param secondary.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for MySQL secondary containers
  ##
  extraEnvVarsCM: ""
  ## @param secondary.extraEnvVarsSecret Name of existing Secret containing extra env vars for MySQL secondary containers
  ##
  extraEnvVarsSecret: ""
  ## @param secondary.extraPorts Extra ports to expose
  ##
  extraPorts: []
  ## Enable persistence using Persistent Volume Claims
  ## ref: https://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence:
    ## @param secondary.persistence.enabled Enable persistence on MySQL secondary replicas using a `PersistentVolumeClaim`
    ##
    enabled: true
    ## @param secondary.persistence.existingClaim Name of an existing `PersistentVolumeClaim` for MySQL secondary replicas
    ## NOTE: When it's set the rest of persistence parameters are ignored
    ##
    existingClaim: ""
    ## @param secondary.persistence.subPath The name of a volume's sub path to mount for persistence
    ##
    subPath: ""
    ## @param secondary.persistence.storageClass MySQL secondary persistent volume storage Class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is
    ##   set, choosing the default provisioner.  (gp2 on AWS, standard on
    ##   GKE, AWS & OpenStack)
    ##
    storageClass: ${resource.local_helm_config.mysql_data.storage_class_name}
    ## @param secondary.persistence.annotations [object] MySQL secondary persistent volume claim annotations
    ##
    annotations: {}
    ## @param secondary.persistence.accessModes MySQL secondary persistent volume access Modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param secondary.persistence.size MySQL secondary persistent volume size
    ##
    size: ${resource.local_helm_config.mysql_data.storage_size}
    ## @param secondary.persistence.selector [object] Selector to match an existing Persistent Volume
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
  ## @param secondary.extraVolumes Optionally specify extra list of additional volumes to the MySQL secondary pod(s)
  ##
  extraVolumes: []
  ## @param secondary.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the MySQL secondary container(s)
  ##
  extraVolumeMounts: []
  ## @param secondary.initContainers Add additional init containers for the MySQL secondary pod(s)
  ##
  initContainers: []
  ## @param secondary.sidecars Add additional sidecar containers for the MySQL secondary pod(s)
  ##
  sidecars: []
  ## MySQL Secondary Service parameters
  ##
  service:
    ## @param secondary.service.type MySQL secondary Kubernetes service type
    ##
    type: ClusterIP
    ## @param secondary.service.ports.mysql MySQL secondary Kubernetes service port
    ##
    ports:
      mysql: 3306
    ## @param secondary.service.nodePorts.mysql MySQL secondary Kubernetes service node port
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ##
    nodePorts:
      mysql: ""
    ## @param secondary.service.clusterIP MySQL secondary Kubernetes service clusterIP IP
    ## e.g:
    ## clusterIP: None
    ##
    clusterIP: ""
    ## @param secondary.service.loadBalancerIP MySQL secondary loadBalancerIP if service type is `LoadBalancer`
    ## Set the LoadBalancer service type to internal only
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param secondary.service.externalTrafficPolicy Enable client source IP preservation
    ## ref https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param secondary.service.loadBalancerSourceRanges Addresses that are allowed when MySQL secondary service is LoadBalancer
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## E.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param secondary.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param secondary.service.annotations Additional custom annotations for MySQL secondary service
    ##
    annotations: {}
    ## @param secondary.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param secondary.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
    ## Headless service properties
    ##
    headless:
      ## @param secondary.service.headless.annotations Additional custom annotations for headless MySQL secondary service.
      ##
      annotations: {}

  ## MySQL secondary Pod Disruption Budget configuration
  ## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
  ##
  pdb:
    ## @param secondary.pdb.create Enable/disable a Pod Disruption Budget creation for MySQL secondary pods
    ##
    create: false
    ## @param secondary.pdb.minAvailable Minimum number/percentage of MySQL secondary pods that should remain scheduled
    ##
    minAvailable: 1
    ## @param secondary.pdb.maxUnavailable Maximum number/percentage of MySQL secondary pods that may be made unavailable
    ##
    maxUnavailable: ""
  ## @param secondary.podLabels Additional pod labels for MySQL secondary pods
  ##
  podLabels:
    sidecar.istio.io/inject: "false"

## @section RBAC parameters
##

## MySQL pods ServiceAccount
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
##
serviceAccount:
  ## @param serviceAccount.create Enable the creation of a ServiceAccount for MySQL pods
  ##
  create: true
  ## @param serviceAccount.name Name of the created ServiceAccount
  ## If not set and create is true, a name is generated using the mysql.fullname template
  ##
  name: ""
  ## @param serviceAccount.annotations Annotations for MySQL Service Account
  ##
  annotations: {}
  ## @param serviceAccount.automountServiceAccountToken Automount service account token for the server service account
  ##
  automountServiceAccountToken: true

## Role Based Access
## ref: https://kubernetes.io/docs/admin/authorization/rbac/
##
rbac:
  ## @param rbac.create Whether to create & use RBAC resources or not
  ##
  create: false
  ## @param rbac.rules Custom RBAC rules to set
  ## e.g:
  ## rules:
  ##   - apiGroups:
  ##       - ""
  ##     resources:
  ##       - pods
  ##     verbs:
  ##       - get
  ##       - list
  ##
  rules: []

## @section Network Policy
##

## MySQL Nework Policy configuration
##
networkPolicy:
  ## @param networkPolicy.enabled Enable creation of NetworkPolicy resources
  ##
  enabled: false
  ## @param networkPolicy.allowExternal The Policy model to apply.
  ## When set to false, only pods with the correct
  ## client label will have network access to the port MySQL is listening
  ## on. When true, MySQL will accept connections from any source
  ## (with the correct destination port).
  ##
  allowExternal: true
  ## @param networkPolicy.explicitNamespacesSelector A Kubernetes LabelSelector to explicitly select namespaces from which ingress traffic could be allowed to MySQL
  ## If explicitNamespacesSelector is missing or set to {}, only client Pods that are in the networkPolicy's namespace
  ## and that match other criteria, the ones that have the good label, can reach the DB.
  ## But sometimes, we want the DB to be accessible to clients from other namespaces, in this case, we can use this
  ## LabelSelector to select these namespaces, note that the networkPolicy's namespace should also be explicitly added.
  ##
  ## Example:
  ## explicitNamespacesSelector:
  ##   matchLabels:
  ##     role: frontend
  ##   matchExpressions:
  ##    - {key: role, operator: In, values: [frontend]}
  ##
  explicitNamespacesSelector: {}

## @section Volume Permissions parameters
##

volumePermissions:
  ## @param volumePermissions.enabled Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`
  ##
  enabled: true
  ## @param volumePermissions.image.registry Init container volume-permissions image registry
  ## @param volumePermissions.image.repository Init container volume-permissions image repository
  ## @param volumePermissions.image.tag Init container volume-permissions image tag (immutable tags are recommended)
  ## @param volumePermissions.image.digest Init container volume-permissions image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param volumePermissions.image.pullPolicy Init container volume-permissions image pull policy
  ## @param volumePermissions.image.pullSecrets Specify docker-registry secret names as an array
  ##
  image:
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param volumePermissions.resources Init container volume-permissions resources
  ##
  resources: {}

## @section Metrics parameters
##

## Mysqld Prometheus exporter parameters
##
metrics:
  ## @param metrics.enabled Start a side-car prometheus exporter
  ##
  enabled: true
  ## @param metrics.image.registry Exporter image registry
  ## @param metrics.image.repository Exporter image repository
  ## @param metrics.image.tag Exporter image tag (immutable tags are recommended)
  ## @param metrics.image.digest Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param metrics.image.pullPolicy Exporter image pull policy
  ## @param metrics.image.pullSecrets Specify docker-registry secret names as an array
  ##
  image:
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## MySQL metrics container security context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param metrics.containerSecurityContext.enabled MySQL metrics container securityContext
  ## @param metrics.containerSecurityContext.runAsUser User ID for the MySQL metrics container
  ## @param metrics.containerSecurityContext.runAsNonRoot Set MySQL metrics container's Security Context runAsNonRoot
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsNonRoot: true
  ## MySQL Prometheus exporter service parameters
  ## Mysqld Prometheus exporter liveness and readiness probes
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param metrics.service.type Kubernetes service type for MySQL Prometheus Exporter
  ## @param metrics.service.port MySQL Prometheus Exporter service port
  ## @param metrics.service.annotations [object] Prometheus exporter service annotations
  ##
  service:
    type: ClusterIP
    port: 9104
    annotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "{{ .Values.metrics.service.port }}"
  ## @param metrics.extraArgs.primary Extra args to be passed to mysqld_exporter on Primary pods
  ## @param metrics.extraArgs.secondary Extra args to be passed to mysqld_exporter on Secondary pods
  ## ref: https://github.com/prometheus/mysqld_exporter/
  ## E.g.
  ## - --collect.auto_increment.columns
  ## - --collect.binlog_size
  ## - --collect.engine_innodb_status
  ## - --collect.engine_tokudb_status
  ## - --collect.global_status
  ## - --collect.global_variables
  ## - --collect.info_schema.clientstats
  ## - --collect.info_schema.innodb_metrics
  ## - --collect.info_schema.innodb_tablespaces
  ## - --collect.info_schema.innodb_cmp
  ## - --collect.info_schema.innodb_cmpmem
  ## - --collect.info_schema.processlist
  ## - --collect.info_schema.processlist.min_time
  ## - --collect.info_schema.query_response_time
  ## - --collect.info_schema.tables
  ## - --collect.info_schema.tables.databases
  ## - --collect.info_schema.tablestats
  ## - --collect.info_schema.userstats
  ## - --collect.perf_schema.eventsstatements
  ## - --collect.perf_schema.eventsstatements.digest_text_limit
  ## - --collect.perf_schema.eventsstatements.limit
  ## - --collect.perf_schema.eventsstatements.timelimit
  ## - --collect.perf_schema.eventswaits
  ## - --collect.perf_schema.file_events
  ## - --collect.perf_schema.file_instances
  ## - --collect.perf_schema.indexiowaits
  ## - --collect.perf_schema.tableiowaits
  ## - --collect.perf_schema.tablelocks
  ## - --collect.perf_schema.replication_group_member_stats
  ## - --collect.slave_status
  ## - --collect.slave_hosts
  ## - --collect.heartbeat
  ## - --collect.heartbeat.database
  ## - --collect.heartbeat.table
  ##
  extraArgs:
    primary: []
    secondary: []
  ## Mysqld Prometheus exporter resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## We usually recommend not to specify default resources and to leave this as a conscious
  ## choice for the user. This also increases chances charts run on environments with little
  ## resources, such as Minikube. If you do want to specify resources, uncomment the following
  ## lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  ## @param metrics.resources.limits The resources limits for MySQL prometheus exporter containers
  ## @param metrics.resources.requests The requested resources for MySQL prometheus exporter containers
  ##
  resources:
    ## Example:
    ## limits:
    ##    cpu: 100m
    ##    memory: 256Mi
    ##
    limits: {}
    ## Examples:
    ## requests:
    ##    cpu: 100m
    ##    memory: 256Mi
    ##
    requests: {}
  ## Mysqld Prometheus exporter liveness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param metrics.livenessProbe.enabled Enable livenessProbe
  ## @param metrics.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param metrics.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param metrics.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param metrics.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param metrics.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 120
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 3
  ## Mysqld Prometheus exporter readiness probe
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
  ## @param metrics.readinessProbe.enabled Enable readinessProbe
  ## @param metrics.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param metrics.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param metrics.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param metrics.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param metrics.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 3
  ## Prometheus Service Monitor
  ## ref: https://github.com/coreos/prometheus-operator
  ##
  serviceMonitor:
    ## @param metrics.serviceMonitor.enabled Create ServiceMonitor Resource for scraping metrics using PrometheusOperator
    ##
    enabled: true
    ## @param metrics.serviceMonitor.namespace Specify the namespace in which the serviceMonitor resource will be created
    ##
    namespace: ""
    ## @param metrics.serviceMonitor.jobLabel The name of the label on the target service to use as the job name in prometheus.
    ##
    jobLabel: ""
    ## @param metrics.serviceMonitor.interval Specify the interval at which metrics should be scraped
    ##
    interval: 30s
    ## @param metrics.serviceMonitor.scrapeTimeout Specify the timeout after which the scrape is ended
    ## e.g:
    ## scrapeTimeout: 30s
    ##
    scrapeTimeout: ""
    ## @param metrics.serviceMonitor.relabelings RelabelConfigs to apply to samples before scraping
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#relabelconfig
    ##
    relabelings: []
    ## @param metrics.serviceMonitor.metricRelabelings MetricRelabelConfigs to apply to samples before ingestion
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#relabelconfig
    ##
    metricRelabelings: []
    ## @param metrics.serviceMonitor.selector ServiceMonitor selector labels
    ## ref: https://github.com/bitnami/charts/tree/main/bitnami/prometheus-operator#prometheus-configuration
    ##
    ## selector:
    ##   prometheus: my-prometheus
    ##
    selector: {}
    ## @param metrics.serviceMonitor.honorLabels Specify honorLabels parameter to add the scrape endpoint
    ##
    honorLabels: false
    ## @param metrics.serviceMonitor.labels Used to pass Labels that are used by the Prometheus installed in your cluster to select Service Monitors to work with
    ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
    ##
    labels: {}
    ## @param metrics.serviceMonitor.annotations ServiceMonitor annotations
    ##
    annotations: {}

  ## Prometheus Operator prometheusRule configuration
  ##
  prometheusRule:
    ## @param metrics.prometheusRule.enabled Creates a Prometheus Operator prometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`)
    ##
    enabled: false
    ## @param metrics.prometheusRule.namespace Namespace for the prometheusRule Resource (defaults to the Release Namespace)
    ##
    namespace: ""
    ## @param metrics.prometheusRule.additionalLabels Additional labels that can be used so prometheusRule will be discovered by Prometheus
    ##
    additionalLabels: {}
    ## @param metrics.prometheusRule.rules Prometheus Rule definitions
    ##  - alert: Mysql-Down
    ##    expr: absent(up{job="mysql"} == 1)
    ##    for: 5m
    ##    labels:
    ##      severity: warning
    ##      service: mariadb
    ##    annotations:
    ##      message: 'MariaDB instance {{`{{`}} $labels.instance {{`}}`}}  is down'
    ##      summary: MariaDB instance is down
    ##
    rules: []