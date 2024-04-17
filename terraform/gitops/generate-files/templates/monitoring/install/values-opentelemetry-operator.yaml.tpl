# Default values for opentelemetry-operator.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

## Provide a name in place of opentelemetry-operator (includes the chart's release name).
##
nameOverride: ""

## Fully override the name (excludes the chart's release name).
##
fullnameOverride: ""

## Reference one or more secrets to be used when pulling images from authenticated repositories.
imagePullSecrets: []

## Kubernetes cluster domain suffix
clusterDomain: cluster.local

# Common labels to add to all otel-operator resources. Evaluated as a template.
additionalLabels: {}

## Pod Disruption Budget configuration
##
pdb:
  ## Enable/disable a Pod Disruption Budget creation
  ##
  create: false
  ## Minimum number/percentage of pods that should remain scheduled
  ##
  minAvailable: 1
  ## Maximum number/percentage of pods that may be made unavailable
  ##
  maxUnavailable: ""

## Provide OpenTelemetry Operator manager container image and resources.
##
manager:
  image:
    repository: ghcr.io/open-telemetry/opentelemetry-operator/opentelemetry-operator
    tag: ""
  collectorImage:
    repository: otel/opentelemetry-collector-contrib
    tag: 0.98.0
  opampBridgeImage:
    repository: ""
    tag: ""
  targetAllocatorImage:
    repository: ""
    tag: ""
  autoInstrumentationImage:
    java:
      repository: ""
      tag: ""
    nodejs:
      repository: ""
      tag: ""
    python:
      repository: ""
      tag: ""
    dotnet:
      repository: ""
      tag: ""
    # The Go instrumentaiton support in the operator is disabled by default.
    # To enable it, use the operator.autoinstrumentation.go feature gate.
    go:
      repository: ""
      tag: ""
  # Feature Gates are a a comma-delimited list of feature gate identifiers.
  # Prefix a gate with '-' to disable support.
  # Prefixing a gate with '+' or no prefix will enable support.
  # A full list of valud identifiers can be found here: https://github.com/open-telemetry/opentelemetry-operator/blob/main/pkg/featuregate/featuregate.go
  featureGates: ""
  ports:
    metricsPort: 8080
    webhookPort: 9443
    healthzPort: 8081
  resources:
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 64Mi
  ## Adds additional environment variables
  ## e.g ENV_VAR: env_value
  env:
    ENABLE_WEBHOOKS: "true"

  # -- Create the manager ServiceAccount
  serviceAccount:
    create: true
    annotations: {}
    # name: nameOverride

  ## Enable ServiceMonitor for Prometheus metrics scrape
  serviceMonitor:
    enabled: false
    # additional labels on the ServiceMonitor
    extraLabels: {}
    # add annotations on the ServiceMonitor
    annotations: {}
    metricsEndpoints:
      - port: metrics

  # Adds additional annotations to the manager Deployment
  deploymentAnnotations: {}
  # Adds additional annotations to the manager Service
  serviceAnnotations: {}

  podAnnotations: {}
  podLabels: {}

  prometheusRule:
    enabled: false
    groups: []
    # Create default rules for monitoring the manager
    defaultRules:
      enabled: false
    # additional labels on the PrometheusRule
    extraLabels: {}
    # add annotations on the PrometheusRule
    annotations: {}

  # Whether the operator should create RBAC permissions for collectors
  createRbacPermissions: false
  ## List of additional cli arguments to configure the manager
  ## for example: --labels, etc.
  extraArgs: []

  ## Enable leader election mechanism for protecting against split brain if multiple operator pods/replicas are started.
  ## See more at https://docs.openshift.com/container-platform/4.10/operators/operator_sdk/osdk-leader-election.html
  leaderElection:
    enabled: true

  # Enable vertical pod autoscaler support for the manager
  verticalPodAutoscaler:
    enabled: false
    # List of resources that the vertical pod autoscaler can control. Defaults to cpu and memory
    controlledResources: []

    # Define the max allowed resources for the pod
    maxAllowed: {}
    # cpu: 200m
    # memory: 100Mi
    # Define the min allowed resources for the pod
    minAllowed: {}
    # cpu: 200m
    # memory: 100Mi

    updatePolicy:
      # Specifies whether recommended updates are applied when a Pod is started and whether recommended updates
      # are applied during the life of a Pod. Possible values are "Off", "Initial", "Recreate", and "Auto".
      updateMode: Auto
      # Minimal number of replicas which need to be alive for Updater to attempt pod eviction.
      # Only positive values are allowed. The default is 2.
      minReplicas: 2
  # Enable manager pod automatically rolling
  rolling: false

  ## Container specific securityContext
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  securityContext: {}
  # allowPrivilegeEscalation: false
  # capabilities:
  #   drop:
  #   - ALL

## Provide OpenTelemetry Operator kube-rbac-proxy container image.
##
kubeRBACProxy:
  enabled: true
  image:
    repository: quay.io/brancz/kube-rbac-proxy
    tag: v0.15.0
  ports:
    proxyPort: 8443
  resources:
    limits:
      cpu: 500m
      memory: 128Mi
    requests:
      cpu: 5m
      memory: 64Mi

  ## List of additional cli arguments to configure the kube-rbac-proxy
  ## for example: --tls-cipher-suites, --tls-min-version, etc.
  extraArgs: []

  ## Container specific securityContext
  ## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container
  securityContext: {}
  # allowPrivilegeEscalation: false
  # capabilities:
  #   drop:
  #   - ALL

## Admission webhooks make sure only requests with correctly formatted rules will get into the Operator.
## They also enable the sidecar injection for OpenTelemetryCollector and Instrumentation CR's
admissionWebhooks:
  create: true
  servicePort: 443
  failurePolicy: Fail
  secretName: ""

  ## Defines the sidecar injection logic in Pods.
  ## - Ignore, the injection is fail-open. The pod will be created, but the sidecar won't be injected.
  ## - Fail, the injection is fail-close. If the webhook pod is not ready, pods cannot be created.
  pods:
    failurePolicy: Ignore

  ## Adds a prefix to the mutating webook name.
  ## This can be used to order this mutating webhook with all your cluster's mutating webhooks.
  namePrefix: ""

  ## Customize webhook timeout duration
  timeoutSeconds: 10

  ## Provide selectors for your objects
  namespaceSelector: {}
  objectSelector: {}

  ## https://github.com/open-telemetry/opentelemetry-helm-charts/blob/main/charts/opentelemetry-operator/README.md#tls-certificate-requirement
  ## TLS Certificate Option 1: Use certManager to generate self-signed certificate.
  ## certManager must be enabled. If enabled, always takes precendence over options 2 and 3.
  certManager:
    enabled: true
    ## Provide the issuer kind and name to do the cert auth job.
    ## By default, OpenTelemetry Operator will use self-signer issuer.
    issuerRef: {}
    # kind:
    # name:
    ## Annotations for the cert and issuer if cert-manager is enabled.
    certificateAnnotations: {}
    issuerAnnotations: {}

  ## TLS Certificate Option 2: Use Helm to automatically generate self-signed certificate.
  ## certManager must be disabled and autoGenerateCert must be enabled.
  ## If true and certManager.enabled is false, Helm will automatically create a self-signd cert and secret for you.
  autoGenerateCert:
    enabled: true
    # If set to true, new webhook key/certificate is generated on helm upgrade.
    recreate: true

  ## TLS Certificate Option 3: Use your own self-signed certificate.
  ## certManager and autoGenerateCert must be disabled and certFile, keyFile, and caFile must be set.
  ## The chart reads the contents of the file paths with the helm .Files.Get function.
  ## Refer to this doc https://helm.sh/docs/chart_template_guide/accessing_files/ to understand
  ## limitations of file paths accessible to the chart.
  ## Path to your own PEM-encoded certificate.
  certFile: ""
  ## Path to your own PEM-encoded private key.
  keyFile: ""
  ## Path to the CA cert.
  caFile: ""

  # Adds additional annotations to the admissionWebhook Service
  serviceAnnotations: {}

  ## Secret annotations
  secretAnnotations: {}
  ## Secret labels
  secretLabels: {}

## Create the provided Roles and RoleBindings
##
role:
  create: true

## Create the provided ClusterRoles and ClusterRoleBindings
##
clusterRole:
  create: true

affinity: {}
tolerations: []
nodeSelector: {}
topologySpreadConstraints: []
hostNetwork: false

# Allows for pod scheduler prioritisation
priorityClassName: ""

## SecurityContext holds pod-level security attributes and common container settings.
## ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
securityContext:
  runAsGroup: 65532
  runAsNonRoot: true
  runAsUser: 65532
  fsGroup: 65532

testFramework:
  image:
    repository: busybox
    tag: latest

