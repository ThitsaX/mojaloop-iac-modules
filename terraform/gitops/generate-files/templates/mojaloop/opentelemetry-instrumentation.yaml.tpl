%{ if opentelemetry_enabled ~}
apiVersion: opentelemetry.io/v1alpha1
kind: Instrumentation
metadata:
  name: mojaloop-instrumentation
spec:
  exporter:
    endpoint: http://tempo-grafana-tempo-distributor.monitoring.svc.cluster.local:4317
  propagators:
    - tracecontext
    - baggage
  sampler:
    type: parentbased_traceidratio
    argument: "0.001"
%{ endif ~}
