## @section Global parameters
## Global Docker image parameters
## Please, note that this will override the image parameters, including dependencies, configured to use the global value
## Current available global Docker image parameters: imageRegistry, imagePullSecrets and storageClass
##

## @param global.imageRegistry Global Docker image registry
## @param global.imagePullSecrets Global Docker registry secret names as an array
## @param global.storageClass Global StorageClass for Persistent Volume(s)
## @param global.redis.password Global Redis&reg; password (overrides `auth.password`)
##
global:
  imageRegistry: ""
  ## E.g.
  ## imagePullSecrets:
  ##   - myRegistryKeySecretName
  ##
  imagePullSecrets: []
  storageClass: ${resource.local_helm_config.redis_data.storage_class_name}

## @section Common parameters
##

## @param kubeVersion Override Kubernetes version
##
kubeVersion: ""
## @param nameOverride String to partially override common.names.fullname
##
nameOverride: ${key}
## @param fullnameOverride String to fully override common.names.fullname
##
fullnameOverride: ""
## @param commonLabels Labels to add to all deployed objects
##
commonLabels: {}
## @param commonAnnotations Annotations to add to all deployed objects
##
commonAnnotations: {}
## @param secretAnnotations Annotations to add to secret
##
secretAnnotations: {}
## @param clusterDomain Kubernetes cluster domain name
##
clusterDomain: cluster.local
## @param extraDeploy Array of extra objects to deploy with the release
##
extraDeploy: []

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

## @section Redis&reg; Image parameters
##

## Bitnami Redis&reg; image
## ref: https://hub.docker.com/r/bitnami/redis/tags/
## @param image.registry Redis&reg; image registry
## @param image.repository Redis&reg; image repository
## @param image.tag Redis&reg; image tag (immutable tags are recommended)
## @param image.digest Redis&reg; image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
## @param image.pullPolicy Redis&reg; image pull policy
## @param image.pullSecrets Redis&reg; image pull secrets
## @param image.debug Enable image debug mode
##
image:
  registry: docker.io
  repository: bitnami/redis
  tag: 7.0.5-debian-11-r7
  digest: ""
  ## Specify a imagePullPolicy
  ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
  ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
  ##
  pullPolicy: IfNotPresent
  ## Optionally specify an array of imagePullSecrets.
  ## Secrets must be manually created in the namespace.
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
  ## e.g:
  ## pullSecrets:
  ##   - myRegistryKeySecretName
  ##
  pullSecrets: []
  ## Enable debug mode
  ##
  debug: false

## @section Redis&reg; common configuration parameters
## https://github.com/bitnami/containers/tree/main/bitnami/redis#configuration
##

## @param architecture Redis&reg; architecture. Allowed values: `standalone` or `replication`
##
architecture: ${resource.local_helm_config.redis_data.architecture}
## Redis&reg; Authentication parameters
## ref: https://github.com/bitnami/containers/tree/main/bitnami/redis#setting-the-server-password-on-first-run
##
auth:
  ## @param auth.enabled Enable password authentication
  ## set to false until 3rd party supports auth
  enabled: false
  ## @param auth.sentinel Enable password authentication on sentinels too
  ##
  sentinel: true

  ## @param auth.existingSecret The name of an existing secret with Redis&reg; credentials
  ## NOTE: When it's set, the previous `auth.password` parameter is ignored
  ##
  existingSecret: "${resource.local_helm_config.redis_data.existing_secret}"
  ## @param auth.existingSecretPasswordKey Password key to be retrieved from existing secret
  ## NOTE: ignored unless `auth.existingSecret` parameter is set
  ##
  existingSecretPasswordKey: "${resource.local_helm_config.redis_data.existing_secret_key}"
  ## @param auth.usePasswordFiles Mount credentials as files instead of using an environment variable
  ##
  usePasswordFiles: false

## @param commonConfiguration [string] Common configuration to be added into the ConfigMap
## ref: https://redis.io/topics/config
##
commonConfiguration: |-
  # Enable AOF https://redis.io/topics/persistence#append-only-file
  appendonly yes
  # Disable RDB persistence, AOF persistence already enabled.
  save ""
## @param existingConfigmap The name of an existing ConfigMap with your custom configuration for Redis&reg; nodes
##
existingConfigmap: ""

## @section Redis&reg; master configuration parameters
##

master:
  ## @param master.count Number of Redis&reg; master instances to deploy (experimental, requires additional configuration)
  ##
  count: 1
  ## @param master.configuration Configuration for Redis&reg; master nodes
  ## ref: https://redis.io/topics/config
  ##
  configuration: ""
  ## @param master.disableCommands Array with Redis&reg; commands to disable on master nodes
  ## Commands will be completely disabled by renaming each to an empty string.
  ## ref: https://redis.io/topics/security#disabling-of-specific-commands
  ##
  disableCommands:
    - FLUSHDB
    - FLUSHALL
  ## @param master.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param master.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param master.preExecCmds Additional commands to run prior to starting Redis&reg; master
  ##
  preExecCmds: []
  ## @param master.extraFlags Array with additional command line flags for Redis&reg; master
  ## e.g:
  ## extraFlags:
  ##  - "--maxmemory-policy volatile-ttl"
  ##  - "--repl-backlog-size 1024mb"
  ##
  extraFlags: []
  ## @param master.extraEnvVars Array with extra environment variables to add to Redis&reg; master nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param master.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for Redis&reg; master nodes
  ##
  extraEnvVarsCM: ""
  ## @param master.extraEnvVarsSecret Name of existing Secret containing extra env vars for Redis&reg; master nodes
  ##
  extraEnvVarsSecret: ""
  ## @param master.containerPorts.redis Container port to open on Redis&reg; master nodes
  ##
  containerPorts:
    redis: 6379
  ## Configure extra options for Redis&reg; containers' liveness and readiness probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param master.startupProbe.enabled Enable startupProbe on Redis&reg; master nodes
  ## @param master.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param master.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param master.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param master.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param master.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: false
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param master.livenessProbe.enabled Enable livenessProbe on Redis&reg; master nodes
  ## @param master.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param master.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param master.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param master.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param master.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param master.readinessProbe.enabled Enable readinessProbe on Redis&reg; master nodes
  ## @param master.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param master.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param master.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param master.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param master.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 5
  ## @param master.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param master.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param master.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## Redis&reg; master resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param master.resources.limits The resources limits for the Redis&reg; master containers
  ## @param master.resources.requests The requested resources for the Redis&reg; master containers
  ##
  resources:
    limits: {}
    requests: {}
  ## Configure Pods Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param master.podSecurityContext.enabled Enabled Redis&reg; master pods' Security Context
  ## @param master.podSecurityContext.fsGroup Set Redis&reg; master pod's Security Context fsGroup
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param master.containerSecurityContext.enabled Enabled Redis&reg; master containers' Security Context
  ## @param master.containerSecurityContext.runAsUser Set Redis&reg; master containers' Security Context runAsUser
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## @param master.kind Use either Deployment or StatefulSet (default)
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
  ##
  kind: StatefulSet
  ## @param master.schedulerName Alternate scheduler for Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param master.updateStrategy.type Redis&reg; master statefulset strategy type
  ## @skip master.updateStrategy.rollingUpdate
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    ## StrategyType
    ## Can be set to RollingUpdate or OnDelete
    ##
    type: RollingUpdate
    rollingUpdate: {}
  ## @param master.priorityClassName Redis&reg; master pods' priorityClassName
  ##
  priorityClassName: ""
  ## @param master.hostAliases Redis&reg; master pods host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param master.podLabels Extra labels for Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  ##
  podLabels:
    sidecar.istio.io/inject: false
  ## @param master.podAnnotations Annotations for Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param master.shareProcessNamespace Share a single process namespace between all of the containers in Redis&reg; master pods
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/
  ##
  shareProcessNamespace: false
  ## @param master.podAffinityPreset Pod affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param master.podAntiAffinityPreset Pod anti-affinity preset. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## Node master.affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param master.nodeAffinityPreset.type Node affinity preset type. Ignored if `master.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param master.nodeAffinityPreset.key Node label key to match. Ignored if `master.affinity` is set
    ##
    key: ""
    ## @param master.nodeAffinityPreset.values Node label values to match. Ignored if `master.affinity` is set
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param master.affinity Affinity for Redis&reg; master pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## NOTE: `master.podAffinityPreset`, `master.podAntiAffinityPreset`, and `master.nodeAffinityPreset` will be ignored when it's set
  ##
  affinity: {}
  ## @param master.nodeSelector Node labels for Redis&reg; master pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param master.tolerations Tolerations for Redis&reg; master pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param master.topologySpreadConstraints Spread Constraints for Redis&reg; master pod assignment
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## E.g.
  ## topologySpreadConstraints:
  ##   - maxSkew: 1
  ##     topologyKey: node
  ##     whenUnsatisfiable: DoNotSchedule
  ##
  topologySpreadConstraints: []
  ## @param master.dnsPolicy DNS Policy for Redis&reg; master pod
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsPolicy: ClusterFirst
  dnsPolicy: ""
  ## @param master.dnsConfig DNS Configuration for Redis&reg; master pod
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsConfig:
  ##   options:
  ##   - name: ndots
  ##     value: "4"
  ##   - name: single-request-reopen
  dnsConfig: {}
  ## @param master.lifecycleHooks for the Redis&reg; master container(s) to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## @param master.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; master pod(s)
  ##
  extraVolumes: []
  ## @param master.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; master container(s)
  ##
  extraVolumeMounts: []
  ## @param master.sidecars Add additional sidecar containers to the Redis&reg; master pod(s)
  ## e.g:
  ## sidecars:
  ##   - name: your-image-name
  ##     image: your-image
  ##     imagePullPolicy: Always
  ##     ports:
  ##       - name: portname
  ##         containerPort: 1234
  ##
  sidecars: []
  ## @param master.initContainers Add additional init containers to the Redis&reg; master pod(s)
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
  ## e.g:
  ## initContainers:
  ##  - name: your-image-name
  ##    image: your-image
  ##    imagePullPolicy: Always
  ##    command: ['sh', '-c', 'echo "hello world"']
  ##
  initContainers: []
  ## Persistence parameters
  ## ref: https://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence:
    ## @param master.persistence.enabled Enable persistence on Redis&reg; master nodes using Persistent Volume Claims
    ##
    enabled: true
    ## @param master.persistence.medium Provide a medium for `emptyDir` volumes.
    ##
    medium: ""
    ## @param master.persistence.sizeLimit Set this to enable a size limit for `emptyDir` volumes.
    ##
    sizeLimit: ""
    ## @param master.persistence.path The path the volume will be mounted at on Redis&reg; master containers
    ## NOTE: Useful when using different Redis&reg; images
    ##
    path: /data
    ## @param master.persistence.subPath The subdirectory of the volume to mount on Redis&reg; master containers
    ## NOTE: Useful in dev environments
    ##
    subPath: ""
    ## @param master.persistence.storageClass Persistent Volume storage class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner
    ##
    storageClass: ""
    ## @param master.persistence.accessModes Persistent Volume access modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param master.persistence.size Persistent Volume size
    ##
    size: ${resource.local_helm_config.redis_data.storage_size}
    ## @param master.persistence.annotations Additional custom annotations for the PVC
    ##
    annotations: {}
    ## @param master.persistence.selector Additional labels to match for the PVC
    ## e.g:
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param master.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}
    ## @param master.persistence.existingClaim Use a existing PVC which must be created manually before bound
    ## NOTE: requires master.persistence.enabled: true
    ##
    existingClaim: ""
  ## Redis&reg; master service parameters
  ##
  service:
    ## @param master.service.type Redis&reg; master service type
    ##
    type: ClusterIP
    ## @param master.service.ports.redis Redis&reg; master service port
    ##
    ports:
      redis: ${resource.local_helm_config.redis_data.service_port}
    ## @param master.service.nodePorts.redis Node port for Redis&reg; master
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ## NOTE: choose port between <30000-32767>
    ##
    nodePorts:
      redis: ""
    ## @param master.service.externalTrafficPolicy Redis&reg; master service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param master.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param master.service.internalTrafficPolicy Redis&reg; master service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service-traffic-policy/
    ##
    internalTrafficPolicy: Cluster
    ## @param master.service.clusterIP Redis&reg; master service Cluster IP
    ##
    clusterIP: ""
    ## @param master.service.loadBalancerIP Redis&reg; master service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param master.service.loadBalancerSourceRanges Redis&reg; master service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param master.service.annotations Additional custom annotations for Redis&reg; master service
    ##
    annotations: {}
    ## @param master.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param master.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
  ## @param master.terminationGracePeriodSeconds Integer setting the termination grace period for the redis-master pods
  ##
  terminationGracePeriodSeconds: 30
  ## ServiceAccount configuration
  ##
  serviceAccount:
    ## @param master.serviceAccount.create Specifies whether a ServiceAccount should be created
    ##
    create: false
    ## @param master.serviceAccount.name The name of the ServiceAccount to use.
    ## If not set and create is true, a name is generated using the common.names.fullname template
    ##
    name: ""
    ## @param master.serviceAccount.automountServiceAccountToken Whether to auto mount the service account token
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server
    ##
    automountServiceAccountToken: true
    ## @param master.serviceAccount.annotations Additional custom annotations for the ServiceAccount
    ##
    annotations: {}

## @section Redis&reg; replicas configuration parameters
##

replica:
  ## @param replica.replicaCount Number of Redis&reg; replicas to deploy
  ##
  replicaCount: ${resource.local_helm_config.redis_data.replica_count}
  ## @param replica.configuration Configuration for Redis&reg; replicas nodes
  ## ref: https://redis.io/topics/config
  ##
  configuration: ""
  ## @param replica.disableCommands Array with Redis&reg; commands to disable on replicas nodes
  ## Commands will be completely disabled by renaming each to an empty string.
  ## ref: https://redis.io/topics/security#disabling-of-specific-commands
  ##
  disableCommands:
    - FLUSHDB
    - FLUSHALL
  ## @param replica.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param replica.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param replica.preExecCmds Additional commands to run prior to starting Redis&reg; replicas
  ##
  preExecCmds: []
  ## @param replica.extraFlags Array with additional command line flags for Redis&reg; replicas
  ## e.g:
  ## extraFlags:
  ##  - "--maxmemory-policy volatile-ttl"
  ##  - "--repl-backlog-size 1024mb"
  ##
  extraFlags: []
  ## @param replica.extraEnvVars Array with extra environment variables to add to Redis&reg; replicas nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param replica.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for Redis&reg; replicas nodes
  ##
  extraEnvVarsCM: ""
  ## @param replica.extraEnvVarsSecret Name of existing Secret containing extra env vars for Redis&reg; replicas nodes
  ##
  extraEnvVarsSecret: ""
  ## @param replica.externalMaster.enabled Use external master for bootstrapping
  ## @param replica.externalMaster.host External master host to bootstrap from
  ## @param replica.externalMaster.port Port for Redis service external master host
  ##
  externalMaster:
    enabled: false
    host: ""
    port: 6379
  ## @param replica.containerPorts.redis Container port to open on Redis&reg; replicas nodes
  ##
  containerPorts:
    redis: 6379
  ## Configure extra options for Redis&reg; containers' liveness and readiness probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param replica.startupProbe.enabled Enable startupProbe on Redis&reg; replicas nodes
  ## @param replica.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param replica.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param replica.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param replica.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param replica.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: true
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 22
  ## @param replica.livenessProbe.enabled Enable livenessProbe on Redis&reg; replicas nodes
  ## @param replica.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param replica.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param replica.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param replica.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param replica.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param replica.readinessProbe.enabled Enable readinessProbe on Redis&reg; replicas nodes
  ## @param replica.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param replica.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param replica.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param replica.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param replica.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 5
  ## @param replica.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param replica.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param replica.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## Redis&reg; replicas resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param replica.resources.limits The resources limits for the Redis&reg; replicas containers
  ## @param replica.resources.requests The requested resources for the Redis&reg; replicas containers
  ##
  resources:
    # We usually recommend not to specify default resources and to leave this as a conscious
    # choice for the user. This also increases chances charts run on environments with little
    # resources, such as Minikube. If you do want to specify resources, uncomment the following
    # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
    limits: {}
    #   cpu: 250m
    #   memory: 256Mi
    requests: {}
    #   cpu: 250m
    #   memory: 256Mi
  ## Configure Pods Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param replica.podSecurityContext.enabled Enabled Redis&reg; replicas pods' Security Context
  ## @param replica.podSecurityContext.fsGroup Set Redis&reg; replicas pod's Security Context fsGroup
  ##
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param replica.containerSecurityContext.enabled Enabled Redis&reg; replicas containers' Security Context
  ## @param replica.containerSecurityContext.runAsUser Set Redis&reg; replicas containers' Security Context runAsUser
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## @param replica.schedulerName Alternate scheduler for Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/
  ##
  schedulerName: ""
  ## @param replica.updateStrategy.type Redis&reg; replicas statefulset strategy type
  ## @skip replica.updateStrategy.rollingUpdate
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies
  ##
  updateStrategy:
    ## StrategyType
    ## Can be set to RollingUpdate or OnDelete
    ##
    type: RollingUpdate
    rollingUpdate: {}
  ## @param replica.priorityClassName Redis&reg; replicas pods' priorityClassName
  ##
  priorityClassName: ""
  ## @param replica.podManagementPolicy podManagementPolicy to manage scaling operation of %%MAIN_CONTAINER_NAME%% pods
  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-management-policies
  ##
  podManagementPolicy: ""
  ## @param replica.hostAliases Redis&reg; replicas pods host aliases
  ## https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/
  ##
  hostAliases: []
  ## @param replica.podLabels Extra labels for Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  ##
  podLabels: {}
  ## @param replica.podAnnotations Annotations for Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations: {}
  ## @param replica.shareProcessNamespace Share a single process namespace between all of the containers in Redis&reg; replicas pods
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/share-process-namespace/
  ##
  shareProcessNamespace: false
  ## @param replica.podAffinityPreset Pod affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAffinityPreset: ""
  ## @param replica.podAntiAffinityPreset Pod anti-affinity preset. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
  ##
  podAntiAffinityPreset: soft
  ## Node affinity preset
  ## ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
  ##
  nodeAffinityPreset:
    ## @param replica.nodeAffinityPreset.type Node affinity preset type. Ignored if `replica.affinity` is set. Allowed values: `soft` or `hard`
    ##
    type: ""
    ## @param replica.nodeAffinityPreset.key Node label key to match. Ignored if `replica.affinity` is set
    ##
    key: ""
    ## @param replica.nodeAffinityPreset.values Node label values to match. Ignored if `replica.affinity` is set
    ## E.g.
    ## values:
    ##   - e2e-az1
    ##   - e2e-az2
    ##
    values: []
  ## @param replica.affinity Affinity for Redis&reg; replicas pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  ## NOTE: `replica.podAffinityPreset`, `replica.podAntiAffinityPreset`, and `replica.nodeAffinityPreset` will be ignored when it's set
  ##
  affinity: {}
  ## @param replica.nodeSelector Node labels for Redis&reg; replicas pods assignment
  ## ref: https://kubernetes.io/docs/user-guide/node-selection/
  ##
  nodeSelector: {}
  ## @param replica.tolerations Tolerations for Redis&reg; replicas pods assignment
  ## ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  ##
  tolerations: []
  ## @param replica.topologySpreadConstraints Spread Constraints for Redis&reg; replicas pod assignment
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/
  ## E.g.
  ## topologySpreadConstraints:
  ##   - maxSkew: 1
  ##     topologyKey: node
  ##     whenUnsatisfiable: DoNotSchedule
  ##
  topologySpreadConstraints: []
  ## @param replica.dnsPolicy DNS Policy for Redis&reg; replica pods
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsPolicy: ClusterFirst
  dnsPolicy: ""
  ## @param replica.dnsConfig DNS Configuration for Redis&reg; replica pods
  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
  ## E.g.
  ## dnsConfig:
  ##   options:
  ##   - name: ndots
  ##     value: "4"
  ##   - name: single-request-reopen
  dnsConfig: {}
  ## @param replica.lifecycleHooks for the Redis&reg; replica container(s) to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## @param replica.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; replicas pod(s)
  ##
  extraVolumes: []
  ## @param replica.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; replicas container(s)
  ##
  extraVolumeMounts: []
  ## @param replica.sidecars Add additional sidecar containers to the Redis&reg; replicas pod(s)
  ## e.g:
  ## sidecars:
  ##   - name: your-image-name
  ##     image: your-image
  ##     imagePullPolicy: Always
  ##     ports:
  ##       - name: portname
  ##         containerPort: 1234
  ##
  sidecars: []
  ## @param replica.initContainers Add additional init containers to the Redis&reg; replicas pod(s)
  ## ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
  ## e.g:
  ## initContainers:
  ##  - name: your-image-name
  ##    image: your-image
  ##    imagePullPolicy: Always
  ##    command: ['sh', '-c', 'echo "hello world"']
  ##
  initContainers: []
  ## Persistence Parameters
  ## ref: https://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence:
    ## @param replica.persistence.enabled Enable persistence on Redis&reg; replicas nodes using Persistent Volume Claims
    ##
    enabled: true
    ## @param replica.persistence.medium Provide a medium for `emptyDir` volumes.
    ##
    medium: ""
    ## @param replica.persistence.sizeLimit Set this to enable a size limit for `emptyDir` volumes.
    ##
    sizeLimit: ""
    ##  @param replica.persistence.path The path the volume will be mounted at on Redis&reg; replicas containers
    ## NOTE: Useful when using different Redis&reg; images
    ##
    path: /data
    ## @param replica.persistence.subPath The subdirectory of the volume to mount on Redis&reg; replicas containers
    ## NOTE: Useful in dev environments
    ##
    subPath: ""
    ## @param replica.persistence.storageClass Persistent Volume storage class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner
    ##
    storageClass: ""
    ## @param replica.persistence.accessModes Persistent Volume access modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param replica.persistence.size Persistent Volume size
    ##
    size: 8Gi
    ## @param replica.persistence.annotations Additional custom annotations for the PVC
    ##
    annotations: {}
    ## @param replica.persistence.selector Additional labels to match for the PVC
    ## e.g:
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param replica.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}
    ## @param replica.persistence.existingClaim Use a existing PVC which must be created manually before bound
    ## NOTE: requires replica.persistence.enabled: true
    ##
    existingClaim: ""
  ## Redis&reg; replicas service parameters
  ##
  service:
    ## @param replica.service.type Redis&reg; replicas service type
    ##
    type: ClusterIP
    ## @param replica.service.ports.redis Redis&reg; replicas service port
    ##
    ports:
      redis: 6379
    ## @param replica.service.nodePorts.redis Node port for Redis&reg; replicas
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ## NOTE: choose port between <30000-32767>
    ##
    nodePorts:
      redis: ""
    ## @param replica.service.externalTrafficPolicy Redis&reg; replicas service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param replica.service.internalTrafficPolicy Redis&reg; replicas service internal traffic policy (requires Kubernetes v1.22 or greater to be usable)
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service-traffic-policy/
    ##
    internalTrafficPolicy: Cluster
    ## @param replica.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param replica.service.clusterIP Redis&reg; replicas service Cluster IP
    ##
    clusterIP: ""
    ## @param replica.service.loadBalancerIP Redis&reg; replicas service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param replica.service.loadBalancerSourceRanges Redis&reg; replicas service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param replica.service.annotations Additional custom annotations for Redis&reg; replicas service
    ##
    annotations: {}
    ## @param replica.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param replica.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
  ## @param replica.terminationGracePeriodSeconds Integer setting the termination grace period for the redis-replicas pods
  ##
  terminationGracePeriodSeconds: 30
  ## Autoscaling configuration
  ##
  autoscaling:
    ## @param replica.autoscaling.enabled Enable replica autoscaling settings
    ##
    enabled: false
    ## @param replica.autoscaling.minReplicas Minimum replicas for the pod autoscaling
    ##
    minReplicas: 1
    ## @param replica.autoscaling.maxReplicas Maximum replicas for the pod autoscaling
    ##
    maxReplicas: 11
    ## @param replica.autoscaling.targetCPU Percentage of CPU to consider when autoscaling
    ##
    targetCPU: ""
    ## @param replica.autoscaling.targetMemory Percentage of Memory to consider when autoscaling
    ##
    targetMemory: ""
  ## ServiceAccount configuration
  ##
  serviceAccount:
    ## @param replica.serviceAccount.create Specifies whether a ServiceAccount should be created
    ##
    create: false
    ## @param replica.serviceAccount.name The name of the ServiceAccount to use.
    ## If not set and create is true, a name is generated using the common.names.fullname template
    ##
    name: ""
    ## @param replica.serviceAccount.automountServiceAccountToken Whether to auto mount the service account token
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server
    ##
    automountServiceAccountToken: true
    ## @param replica.serviceAccount.annotations Additional custom annotations for the ServiceAccount
    ##
    annotations: {}
## @section Redis&reg; Sentinel configuration parameters
##

sentinel:
  ## @param sentinel.enabled Use Redis&reg; Sentinel on Redis&reg; pods.
  ## IMPORTANT: this will disable the master and replicas services and
  ## create a single Redis&reg; service exposing both the Redis and Sentinel ports
  ##
  enabled: false
  ## Bitnami Redis&reg; Sentinel image version
  ## ref: https://hub.docker.com/r/bitnami/redis-sentinel/tags/
  ## @param sentinel.image.registry Redis&reg; Sentinel image registry
  ## @param sentinel.image.repository Redis&reg; Sentinel image repository
  ## @param sentinel.image.tag Redis&reg; Sentinel image tag (immutable tags are recommended)
  ## @param sentinel.image.digest Redis&reg; Sentinel image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param sentinel.image.pullPolicy Redis&reg; Sentinel image pull policy
  ## @param sentinel.image.pullSecrets Redis&reg; Sentinel image pull secrets
  ## @param sentinel.image.debug Enable image debug mode
  ##
  image:
    registry: docker.io
    repository: bitnami/redis-sentinel
    tag: 7.0.5-debian-11-r6
    digest: ""
    ## Specify a imagePullPolicy
    ## Defaults to 'Always' if image tag is 'latest', else set to 'IfNotPresent'
    ## ref: https://kubernetes.io/docs/user-guide/images/#pre-pulling-images
    ##
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
    ## Enable debug mode
    ##
    debug: false
  ## @param sentinel.masterSet Master set name
  ##
  masterSet: mymaster
  ## @param sentinel.quorum Sentinel Quorum
  ##
  quorum: 2
  ## @param sentinel.getMasterTimeout Amount of time to allow before get_sentinel_master_info() times out.
  ## NOTE: This is directly related to the startupProbes which are configured to run every 10 seconds for a total of 22 failures. If adjusting this value, also adjust the startupProbes.
  getMasterTimeout: 220
  ## @param sentinel.automateClusterRecovery Automate cluster recovery in cases where the last replica is not considered a good replica and Sentinel won't automatically failover to it.
  ## This also prevents any new replica from starting until the last remaining replica is elected as master to guarantee that it is the one to be elected by Sentinel, and not a newly started replica with no data.
  ## NOTE: This feature requires a "downAfterMilliseconds" value less or equal to 2000.
  ##
  automateClusterRecovery: false
  ## Sentinel timing restrictions
  ## @param sentinel.downAfterMilliseconds Timeout for detecting a Redis&reg; node is down
  ## @param sentinel.failoverTimeout Timeout for performing a election failover
  ##
  downAfterMilliseconds: 60000
  failoverTimeout: 180000
  ## @param sentinel.parallelSyncs Number of replicas that can be reconfigured in parallel to use the new master after a failover
  ##
  parallelSyncs: 1
  ## @param sentinel.configuration Configuration for Redis&reg; Sentinel nodes
  ## ref: https://redis.io/topics/sentinel
  ##
  configuration: ""
  ## @param sentinel.command Override default container command (useful when using custom images)
  ##
  command: []
  ## @param sentinel.args Override default container args (useful when using custom images)
  ##
  args: []
  ## @param sentinel.preExecCmds Additional commands to run prior to starting Redis&reg; Sentinel
  ##
  preExecCmds: []
  ## @param sentinel.extraEnvVars Array with extra environment variables to add to Redis&reg; Sentinel nodes
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## @param sentinel.extraEnvVarsCM Name of existing ConfigMap containing extra env vars for Redis&reg; Sentinel nodes
  ##
  extraEnvVarsCM: ""
  ## @param sentinel.extraEnvVarsSecret Name of existing Secret containing extra env vars for Redis&reg; Sentinel nodes
  ##
  extraEnvVarsSecret: ""
  ## @param sentinel.externalMaster.enabled Use external master for bootstrapping
  ## @param sentinel.externalMaster.host External master host to bootstrap from
  ## @param sentinel.externalMaster.port Port for Redis service external master host
  ##
  externalMaster:
    enabled: false
    host: ""
    port: 6379
  ## @param sentinel.containerPorts.sentinel Container port to open on Redis&reg; Sentinel nodes
  ##
  containerPorts:
    sentinel: 26379
  ## Configure extra options for Redis&reg; containers' liveness and readiness probes
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#configure-probes
  ## @param sentinel.startupProbe.enabled Enable startupProbe on Redis&reg; Sentinel nodes
  ## @param sentinel.startupProbe.initialDelaySeconds Initial delay seconds for startupProbe
  ## @param sentinel.startupProbe.periodSeconds Period seconds for startupProbe
  ## @param sentinel.startupProbe.timeoutSeconds Timeout seconds for startupProbe
  ## @param sentinel.startupProbe.failureThreshold Failure threshold for startupProbe
  ## @param sentinel.startupProbe.successThreshold Success threshold for startupProbe
  ##
  startupProbe:
    enabled: true
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 22
  ## @param sentinel.livenessProbe.enabled Enable livenessProbe on Redis&reg; Sentinel nodes
  ## @param sentinel.livenessProbe.initialDelaySeconds Initial delay seconds for livenessProbe
  ## @param sentinel.livenessProbe.periodSeconds Period seconds for livenessProbe
  ## @param sentinel.livenessProbe.timeoutSeconds Timeout seconds for livenessProbe
  ## @param sentinel.livenessProbe.failureThreshold Failure threshold for livenessProbe
  ## @param sentinel.livenessProbe.successThreshold Success threshold for livenessProbe
  ##
  livenessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 5
  ## @param sentinel.readinessProbe.enabled Enable readinessProbe on Redis&reg; Sentinel nodes
  ## @param sentinel.readinessProbe.initialDelaySeconds Initial delay seconds for readinessProbe
  ## @param sentinel.readinessProbe.periodSeconds Period seconds for readinessProbe
  ## @param sentinel.readinessProbe.timeoutSeconds Timeout seconds for readinessProbe
  ## @param sentinel.readinessProbe.failureThreshold Failure threshold for readinessProbe
  ## @param sentinel.readinessProbe.successThreshold Success threshold for readinessProbe
  ##
  readinessProbe:
    enabled: true
    initialDelaySeconds: 20
    periodSeconds: 5
    timeoutSeconds: 1
    successThreshold: 1
    failureThreshold: 5
  ## @param sentinel.customStartupProbe Custom startupProbe that overrides the default one
  ##
  customStartupProbe: {}
  ## @param sentinel.customLivenessProbe Custom livenessProbe that overrides the default one
  ##
  customLivenessProbe: {}
  ## @param sentinel.customReadinessProbe Custom readinessProbe that overrides the default one
  ##
  customReadinessProbe: {}
  ## Persistence parameters
  ## ref: https://kubernetes.io/docs/user-guide/persistent-volumes/
  ##
  persistence:
    ## @param sentinel.persistence.enabled Enable persistence on Redis&reg; sentinel nodes using Persistent Volume Claims (Experimental)
    ##
    enabled: false
    ## @param sentinel.persistence.storageClass Persistent Volume storage class
    ## If defined, storageClassName: <storageClass>
    ## If set to "-", storageClassName: "", which disables dynamic provisioning
    ## If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner
    ##
    storageClass: ""
    ## @param sentinel.persistence.accessModes Persistent Volume access modes
    ##
    accessModes:
      - ReadWriteOnce
    ## @param sentinel.persistence.size Persistent Volume size
    ##
    size: 100Mi
    ## @param sentinel.persistence.annotations Additional custom annotations for the PVC
    ##
    annotations: {}
    ## @param sentinel.persistence.selector Additional labels to match for the PVC
    ## e.g:
    ## selector:
    ##   matchLabels:
    ##     app: my-app
    ##
    selector: {}
    ## @param sentinel.persistence.dataSource Custom PVC data source
    ##
    dataSource: {}
    ## @param sentinel.persistence.medium Provide a medium for `emptyDir` volumes.
    ##
    medium: ""
  ## Redis&reg; Sentinel resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param sentinel.resources.limits The resources limits for the Redis&reg; Sentinel containers
  ## @param sentinel.resources.requests The requested resources for the Redis&reg; Sentinel containers
  ##
  resources:
    limits: {}
    requests: {}
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param sentinel.containerSecurityContext.enabled Enabled Redis&reg; Sentinel containers' Security Context
  ## @param sentinel.containerSecurityContext.runAsUser Set Redis&reg; Sentinel containers' Security Context runAsUser
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## @param sentinel.lifecycleHooks for the Redis&reg; sentinel container(s) to automate configuration before or after startup
  ##
  lifecycleHooks: {}
  ## @param sentinel.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; Sentinel
  ##
  extraVolumes: []
  ## @param sentinel.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; Sentinel container(s)
  ##
  extraVolumeMounts: []
  ## Redis&reg; Sentinel service parameters
  ##
  service:
    ## @param sentinel.service.type Redis&reg; Sentinel service type
    ##
    type: ClusterIP
    ## @param sentinel.service.ports.redis Redis&reg; service port for Redis&reg;
    ## @param sentinel.service.ports.sentinel Redis&reg; service port for Redis&reg; Sentinel
    ##
    ports:
      redis: 6379
      sentinel: 26379
    ## @param sentinel.service.nodePorts.redis Node port for Redis&reg;
    ## @param sentinel.service.nodePorts.sentinel Node port for Sentinel
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
    ## NOTE: choose port between <30000-32767>
    ## NOTE: By leaving these values blank, they will be generated by ports-configmap
    ##       If setting manually, please leave at least replica.replicaCount + 1 in between sentinel.service.nodePorts.redis and sentinel.service.nodePorts.sentinel to take into account the ports that will be created while incrementing that base port
    ##
    nodePorts:
      redis: ""
      sentinel: ""
    ## @param sentinel.service.externalTrafficPolicy Redis&reg; Sentinel service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param sentinel.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param sentinel.service.clusterIP Redis&reg; Sentinel service Cluster IP
    ##
    clusterIP: ""
    ## @param sentinel.service.loadBalancerIP Redis&reg; Sentinel service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param sentinel.service.loadBalancerSourceRanges Redis&reg; Sentinel service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param sentinel.service.annotations Additional custom annotations for Redis&reg; Sentinel service
    ##
    annotations: {}
    ## @param sentinel.service.sessionAffinity Session Affinity for Kubernetes service, can be "None" or "ClientIP"
    ## If "ClientIP", consecutive client requests will be directed to the same Pod
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies
    ##
    sessionAffinity: None
    ## @param sentinel.service.sessionAffinityConfig Additional settings for the sessionAffinity
    ## sessionAffinityConfig:
    ##   clientIP:
    ##     timeoutSeconds: 300
    ##
    sessionAffinityConfig: {}
  ## @param sentinel.terminationGracePeriodSeconds Integer setting the termination grace period for the redis-node pods
  ##
  terminationGracePeriodSeconds: 30

## @section Other Parameters
##

## Network Policy configuration
## ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/
##
networkPolicy:
  ## @param networkPolicy.enabled Enable creation of NetworkPolicy resources
  ##
  enabled: false
  ## @param networkPolicy.allowExternal Don't require client label for connections
  ## When set to false, only pods with the correct client label will have network access to the ports
  ## Redis&reg; is listening on. When true, Redis&reg; will accept connections from any source
  ## (with the correct destination port).
  ##
  allowExternal: true
  ## @param networkPolicy.extraIngress Add extra ingress rules to the NetworkPolicy
  ## e.g:
  ## extraIngress:
  ##   - ports:
  ##       - port: 1234
  ##     from:
  ##       - podSelector:
  ##           - matchLabels:
  ##               - role: frontend
  ##       - podSelector:
  ##           - matchExpressions:
  ##               - key: role
  ##                 operator: In
  ##                 values:
  ##                   - frontend
  ##
  extraIngress: []
  ## @param networkPolicy.extraEgress Add extra egress rules to the NetworkPolicy
  ## e.g:
  ## extraEgress:
  ##   - ports:
  ##       - port: 1234
  ##     to:
  ##       - podSelector:
  ##           - matchLabels:
  ##               - role: frontend
  ##       - podSelector:
  ##           - matchExpressions:
  ##               - key: role
  ##                 operator: In
  ##                 values:
  ##                   - frontend
  ##
  extraEgress: []
  ## @param networkPolicy.ingressNSMatchLabels Labels to match to allow traffic from other namespaces
  ## @param networkPolicy.ingressNSPodMatchLabels Pod labels to match to allow traffic from other namespaces
  ##
  ingressNSMatchLabels: {}
  ingressNSPodMatchLabels: {}
## PodSecurityPolicy configuration
## ref: https://kubernetes.io/docs/concepts/policy/pod-security-policy/
##
podSecurityPolicy:
  ## @param podSecurityPolicy.create Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later
  ##
  create: false
  ## @param podSecurityPolicy.enabled Enable PodSecurityPolicy's RBAC rules
  ##
  enabled: false
## RBAC configuration
##
rbac:
  ## @param rbac.create Specifies whether RBAC resources should be created
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
## ServiceAccount configuration
##
serviceAccount:
  ## @param serviceAccount.create Specifies whether a ServiceAccount should be created
  ##
  create: true
  ## @param serviceAccount.name The name of the ServiceAccount to use.
  ## If not set and create is true, a name is generated using the common.names.fullname template
  ##
  name: ""
  ## @param serviceAccount.automountServiceAccountToken Whether to auto mount the service account token
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server
  ##
  automountServiceAccountToken: true
  ## @param serviceAccount.annotations Additional custom annotations for the ServiceAccount
  ##
  annotations: {}
## Redis&reg; Pod Disruption Budget configuration
## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
##
pdb:
  ## @param pdb.create Specifies whether a PodDisruptionBudget should be created
  ##
  create: false
  ## @param pdb.minAvailable Min number of pods that must still be available after the eviction
  ##
  minAvailable: 1
  ## @param pdb.maxUnavailable Max number of pods that can be unavailable after the eviction
  ##
  maxUnavailable: ""
## TLS configuration
##
tls:
  ## @param tls.enabled Enable TLS traffic
  ##
  enabled: false
  ## @param tls.authClients Require clients to authenticate
  ##
  authClients: true
  ## @param tls.autoGenerated Enable autogenerated certificates
  ##
  autoGenerated: false
  ## @param tls.existingSecret The name of the existing secret that contains the TLS certificates
  ##
  existingSecret: ""
  ## @param tls.certificatesSecret DEPRECATED. Use existingSecret instead.
  ##
  certificatesSecret: ""
  ## @param tls.certFilename Certificate filename
  ##
  certFilename: ""
  ## @param tls.certKeyFilename Certificate Key filename
  ##
  certKeyFilename: ""
  ## @param tls.certCAFilename CA Certificate filename
  ##
  certCAFilename: ""
  ## @param tls.dhParamsFilename File containing DH params (in order to support DH based ciphers)
  ##
  dhParamsFilename: ""

## @section Metrics Parameters
##

metrics:
  ## @param metrics.enabled Start a sidecar prometheus exporter to expose Redis&reg; metrics
  ##
  enabled: true
  ## Bitnami Redis&reg; Exporter image
  ## ref: https://hub.docker.com/r/bitnami/redis-exporter/tags/
  ## @param metrics.image.registry Redis&reg; Exporter image registry
  ## @param metrics.image.repository Redis&reg; Exporter image repository
  ## @param metrics.image.tag Redis&reg; Exporter image tag (immutable tags are recommended)
  ## @param metrics.image.digest Redis&reg; Exporter image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param metrics.image.pullPolicy Redis&reg; Exporter image pull policy
  ## @param metrics.image.pullSecrets Redis&reg; Exporter image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/redis-exporter
    tag: 1.44.0-debian-11-r16
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param metrics.command Override default metrics container init command (useful when using custom images)
  ##
  command: []
  ## @param metrics.redisTargetHost A way to specify an alternative Redis&reg; hostname
  ## Useful for certificate CN/SAN matching
  ##
  redisTargetHost: "localhost"
  ## @param metrics.extraArgs Extra arguments for Redis&reg; exporter, for example:
  ## e.g.:
  ## extraArgs:
  ##   check-keys: myKey,myOtherKey
  ##
  extraArgs: {}
  ## @param metrics.extraEnvVars Array with extra environment variables to add to Redis&reg; exporter
  ## e.g:
  ## extraEnvVars:
  ##   - name: FOO
  ##     value: "bar"
  ##
  extraEnvVars: []
  ## Configure Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
  ## @param metrics.containerSecurityContext.enabled Enabled Redis&reg; exporter containers' Security Context
  ## @param metrics.containerSecurityContext.runAsUser Set Redis&reg; exporter containers' Security Context runAsUser
  ##
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  ## @param metrics.extraVolumes Optionally specify extra list of additional volumes for the Redis&reg; metrics sidecar
  ##
  extraVolumes: []
  ## @param metrics.extraVolumeMounts Optionally specify extra list of additional volumeMounts for the Redis&reg; metrics sidecar
  ##
  extraVolumeMounts: []
  ## Redis&reg; exporter resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param metrics.resources.limits The resources limits for the Redis&reg; exporter container
  ## @param metrics.resources.requests The requested resources for the Redis&reg; exporter container
  ##
  resources:
    limits: {}
    requests: {}
  ## @param metrics.podLabels Extra labels for Redis&reg; exporter pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
  ##
  podLabels: {}
  ## @param metrics.podAnnotations [object] Annotations for Redis&reg; exporter pods
  ## ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
  ##
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9121"
  ## Redis&reg; exporter service parameters
  ##
  service:
    ## @param metrics.service.type Redis&reg; exporter service type
    ##
    type: ClusterIP
    ## @param metrics.service.port Redis&reg; exporter service port
    ##
    port: 9121
    ## @param metrics.service.externalTrafficPolicy Redis&reg; exporter service external traffic policy
    ## ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
    ##
    externalTrafficPolicy: Cluster
    ## @param metrics.service.extraPorts Extra ports to expose (normally used with the `sidecar` value)
    ##
    extraPorts: []
    ## @param metrics.service.loadBalancerIP Redis&reg; exporter service Load Balancer IP
    ## ref: https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    ##
    loadBalancerIP: ""
    ## @param metrics.service.loadBalancerSourceRanges Redis&reg; exporter service Load Balancer sources
    ## https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/#restrict-access-for-loadbalancer-service
    ## e.g.
    ## loadBalancerSourceRanges:
    ##   - 10.10.10.0/24
    ##
    loadBalancerSourceRanges: []
    ## @param metrics.service.annotations Additional custom annotations for Redis&reg; exporter service
    ##
    annotations: {}
  ## Prometheus Service Monitor
  ## ref: https://github.com/coreos/prometheus-operator
  ##      https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint
  ##
  serviceMonitor:
    ## @param metrics.serviceMonitor.enabled Create ServiceMonitor resource(s) for scraping metrics using PrometheusOperator
    ##
    enabled: true
    ## @param metrics.serviceMonitor.namespace The namespace in which the ServiceMonitor will be created
    ##
    namespace: ""
    ## @param metrics.serviceMonitor.interval The interval at which metrics should be scraped
    ##
    interval: 30s
    ## @param metrics.serviceMonitor.scrapeTimeout The timeout after which the scrape is ended
    ##
    scrapeTimeout: ""
    ## @param metrics.serviceMonitor.relabellings Metrics RelabelConfigs to apply to samples before scraping.
    ##
    relabellings: []
    ## @param metrics.serviceMonitor.metricRelabelings Metrics RelabelConfigs to apply to samples before ingestion.
    ##
    metricRelabelings: []
    ## @param metrics.serviceMonitor.honorLabels Specify honorLabels parameter to add the scrape endpoint
    ##
    honorLabels: false
    ## @param metrics.serviceMonitor.additionalLabels Additional labels that can be used so ServiceMonitor resource(s) can be discovered by Prometheus
    ##
    additionalLabels: {}
    ## @param metrics.serviceMonitor.podTargetLabels Labels from the Kubernetes pod to be transferred to the created metrics
    ##
    podTargetLabels: []
  ## Custom PrometheusRule to be defined
  ## ref: https://github.com/coreos/prometheus-operator#customresourcedefinitions
  ##
  prometheusRule:
    ## @param metrics.prometheusRule.enabled Create a custom prometheusRule Resource for scraping metrics using PrometheusOperator
    ##
    enabled: false
    ## @param metrics.prometheusRule.namespace The namespace in which the prometheusRule will be created
    ##
    namespace: ""
    ## @param metrics.prometheusRule.additionalLabels Additional labels for the prometheusRule
    ##
    additionalLabels: {}
    ## @param metrics.prometheusRule.rules Custom Prometheus rules
    ## e.g:
    ## rules:
    ##   - alert: RedisDown
    ##     expr: redis_up{service="{{ template "common.names.fullname" . }}-metrics"} == 0
    ##     for: 2m
    ##     labels:
    ##       severity: error
    ##     annotations:
    ##       summary: Redis&reg; instance {{ "{{ $labels.instance }}" }} down
    ##       description: Redis&reg; instance {{ "{{ $labels.instance }}" }} is down
    ##    - alert: RedisMemoryHigh
    ##      expr: >
    ##        redis_memory_used_bytes{service="{{ template "common.names.fullname" . }}-metrics"} * 100
    ##        /
    ##        redis_memory_max_bytes{service="{{ template "common.names.fullname" . }}-metrics"}
    ##        > 90
    ##      for: 2m
    ##      labels:
    ##        severity: error
    ##      annotations:
    ##        summary: Redis&reg; instance {{ "{{ $labels.instance }}" }} is using too much memory
    ##        description: |
    ##          Redis&reg; instance {{ "{{ $labels.instance }}" }} is using {{ "{{ $value }}" }}% of its available memory.
    ##    - alert: RedisKeyEviction
    ##      expr: |
    ##        increase(redis_evicted_keys_total{service="{{ template "common.names.fullname" . }}-metrics"}[5m]) > 0
    ##      for: 1s
    ##      labels:
    ##        severity: error
    ##      annotations:
    ##        summary: Redis&reg; instance {{ "{{ $labels.instance }}" }} has evicted keys
    ##        description: |
    ##          Redis&reg; instance {{ "{{ $labels.instance }}" }} has evicted {{ "{{ $value }}" }} keys in the last 5 minutes.
    ##
    rules: []

## @section Init Container Parameters
##

## 'volumePermissions' init container parameters
## Changes the owner and group of the persistent volume mount point to runAsUser:fsGroup values
##   based on the *podSecurityContext/*containerSecurityContext parameters
##
volumePermissions:
  ## @param volumePermissions.enabled Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`
  ##
  enabled: false
  ## Bitnami Shell image
  ## ref: https://hub.docker.com/r/bitnami/bitnami-shell/tags/
  ## @param volumePermissions.image.registry Bitnami Shell image registry
  ## @param volumePermissions.image.repository Bitnami Shell image repository
  ## @param volumePermissions.image.tag Bitnami Shell image tag (immutable tags are recommended)
  ## @param volumePermissions.image.digest Bitnami Shell image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param volumePermissions.image.pullPolicy Bitnami Shell image pull policy
  ## @param volumePermissions.image.pullSecrets Bitnami Shell image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/bitnami-shell
    tag: 11-debian-11-r40
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## Init container's resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param volumePermissions.resources.limits The resources limits for the init container
  ## @param volumePermissions.resources.requests The requested resources for the init container
  ##
  resources:
    limits: {}
    requests: {}
  ## Init container Container Security Context
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  ## @param volumePermissions.containerSecurityContext.runAsUser Set init container's Security Context runAsUser
  ## NOTE: when runAsUser is set to special value "auto", init container will try to chown the
  ##   data folder to auto-determined user&group, using commands: `id -u`:`id -G | cut -d" " -f2`
  ##   "auto" is especially useful for OpenShift which has scc with dynamic user ids (and 0 is not allowed)
  ##
  containerSecurityContext:
    runAsUser: 0

## init-sysctl container parameters
## used to perform sysctl operation to modify Kernel settings (needed sometimes to avoid warnings)
##
sysctl:
  ## @param sysctl.enabled Enable init container to modify Kernel settings
  ##
  enabled: false
  ## Bitnami Shell image
  ## ref: https://hub.docker.com/r/bitnami/bitnami-shell/tags/
  ## @param sysctl.image.registry Bitnami Shell image registry
  ## @param sysctl.image.repository Bitnami Shell image repository
  ## @param sysctl.image.tag Bitnami Shell image tag (immutable tags are recommended)
  ## @param sysctl.image.digest Bitnami Shell image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag
  ## @param sysctl.image.pullPolicy Bitnami Shell image pull policy
  ## @param sysctl.image.pullSecrets Bitnami Shell image pull secrets
  ##
  image:
    registry: docker.io
    repository: bitnami/bitnami-shell
    tag: 11-debian-11-r40
    digest: ""
    pullPolicy: IfNotPresent
    ## Optionally specify an array of imagePullSecrets.
    ## Secrets must be manually created in the namespace.
    ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
    ## e.g:
    ## pullSecrets:
    ##   - myRegistryKeySecretName
    ##
    pullSecrets: []
  ## @param sysctl.command Override default init-sysctl container command (useful when using custom images)
  ##
  command: []
  ## @param sysctl.mountHostSys Mount the host `/sys` folder to `/host-sys`
  ##
  mountHostSys: false
  ## Init container's resource requests and limits
  ## ref: https://kubernetes.io/docs/user-guide/compute-resources/
  ## @param sysctl.resources.limits The resources limits for the init container
  ## @param sysctl.resources.requests The requested resources for the init container
  ##
  resources:
    limits: {}
    requests: {}

## @section useExternalDNS Parameters
##
## @param useExternalDNS.enabled Enable various syntax that would enable external-dns to work.  Note this requires a working installation of `external-dns` to be usable.
## @param useExternalDNS.additionalAnnotations Extra annotations to be utilized when `external-dns` is enabled.
## @param useExternalDNS.annotationKey The annotation key utilized when `external-dns` is enabled. Setting this to `false` will disable annotations.
## @param useExternalDNS.suffix The DNS suffix utilized when `external-dns` is enabled.  Note that we prepend the suffix with the full name of the release.
##
useExternalDNS:
  enabled: false
  suffix: ""
  annotationKey: external-dns.alpha.kubernetes.io/
  additionalAnnotations: {}

volumePermissions:
  ## @param volumePermissions.enabled Enable init container that changes the owner and group of the persistent volume(s) mountpoint to `runAsUser:fsGroup`
  ##
  enabled: true
