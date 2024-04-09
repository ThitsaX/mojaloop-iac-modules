apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard-cert-external
  namespace: ${istio_namespace}
  annotations:
    argocd.argoproj.io/sync-wave: "${wildcare_certificate_wave}"
spec:
  secretName: ${default_ssl_certificate}
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
  commonName: ${public_subdomain}
  dnsNames:
    - "${public_subdomain}"
    - "*.${public_subdomain}"
  secretTemplate:
    annotations:
      reflector.v1.k8s.emberstack.com/reflection-allowed: "true"
      reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces: "keycloak, ${istio_external_gateway_namespace}, ${istio_internal_gateway_namespace}"  # Control destination namespaces
      reflector.v1.k8s.emberstack.com/reflection-auto-enabled: "true" # Auto create reflection for matching namespaces
      reflector.v1.k8s.emberstack.com/reflection-auto-namespaces: "keycloak, ${istio_external_gateway_namespace}, ${istio_internal_gateway_namespace}" # Control auto-reflection namespaces