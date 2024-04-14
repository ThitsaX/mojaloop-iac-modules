%{ if istio_create_ingress_gateways ~}
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: grafana-vs
spec:
  gateways:
%{ if grafana_wildcard_gateway == "external" ~}
  - ${istio_external_gateway_namespace}/${istio_external_wildcard_gateway_name}
%{ else ~}
  - ${istio_internal_gateway_namespace}/${istio_internal_wildcard_gateway_name}
%{ endif ~}
  hosts:
%{ if grafana_wildcard_gateway == "external" ~}
    - ${grafana_public_fqdn}
%{ else ~}
    - ${grafana_private_fqdn}
%{ endif ~}
  http:
    - match:
        - uri:
            prefix: /
      route:
        - destination:
            host: grafana-service
            port:
              number: 3000
%{ endif ~}
