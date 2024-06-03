apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "${vault_config_operator_sync_wave}"
  name: vault-config-operator
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  source:
    path: ${find_in_parent_folders("kustomization/vault/charts/vault-config-operator", "apps/vault/charts/vault-config-operator")}
    repoURL: "${gitlab_project_url}"
    targetRevision: HEAD
    plugin:
      name: argocd-lovely-plugin-v1.0
  destination:
    namespace: ${vault_config_operator_namespace}
    server: https://kubernetes.default.svc
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    retry:
      limit: 5
      backoff:
        duration: 5s
        maxDuration: 3m0s
        factor: 2
    syncOptions:
      - CreateNamespace=true
      - PrunePropagationPolicy=background
      - PruneLast=true