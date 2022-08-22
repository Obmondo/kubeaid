# Cert-Manager Setup

Get started guide:

1. Fill out values file -  see
[examples/](https://gitlab.enableit.dk/kubernetes/k8id/-/tree/master/argocd-helm-charts/cert-manager/examples)
dir for examples NB
Helm chart supports multiple ACME challenge solvers per ClusterIssuer.
Look at `values-multiple-solvers.yaml` for example.
NB. Depending on cloud provider (for dns solvers), values might differ,
currently only `route53` & `cloudflare` are supported by chart.
[Full list of DNS](https://cert-manager.io/docs/configuration/acme/dns01/)
2. Place values file in your `k8id-config` repository under 'k8s/{clustername}/argocd-apps/values-cert-manager.yaml'
3. Place
<https://gitlab.enableit.dk/kubernetes/k8id/-/tree/master/argocd-helm-charts/cert-manager/examples/cert-manager.yaml>
in your `k8id-config` repository under 'k8s/{clustername}/argocd-apps/templates' -
be sure to adjust paths to match your k8id and k8id-config repositories.

## Details to help fill out values file correctly

- `issuerEmail` is set in the values file.
(It will be used to contact you in case of issues with your account
or certificates, including expiry notification emails)
- For DNS challenge solvers, try to use different credentials per cluster (depending on cloud provider settings).
This will help with future rate limiting problems.
- This process may require you to create
[secrets](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/)
(in case of cloudflare DNS challenge solvers),
please make sure you backup them.
Check how to [backup Cert-Manager resources](https://cert-manager.io/docs/tutorials/backup/).
(Backup may help in case of reinstalling, transferring to another cluster or deleting the cert-manager).
- For multiple DNS solvers you must provide `dnsNames` field. That will hold dns names cloud provider is handling.
