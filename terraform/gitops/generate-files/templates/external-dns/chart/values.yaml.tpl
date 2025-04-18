external-dns:
%{ if dns_provider == "aws" ~}
  provider: aws
  aws:
    credentials:
      secretName: ${external_dns_credentials_secret}
    region: ${dns_cloud_region}
%{ endif ~}
%{ if dns_provider == "cloudflare" ~}
  provider: cloudflare
  cloudflare:
    secretName: ${external_dns_credentials_secret}
    proxied: false  # ← Disable proxying globally (override per-record via annotations)
    # Optional: If you want some records proxied (public IPs), use annotations in Services/Ingresses
%{ endif ~}
  domainFilters:
    - ${public_subdomain}
    - ${private_subdomain}
  txtOwnerId: ${text_owner_id}
  policy: sync
  dryRun: false
  interval: 1m
  triggerLoopOnEvent: true
  txtPrefix: extdns
  sources:
    - service
    - ingress
    - istio-virtualservice