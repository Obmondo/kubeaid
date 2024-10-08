# Cert-Manager Setup

Get started guide:

1. Fill out values file -  see [examples/](examples/) dir for examples NB
Helm chart supports multiple ACME challenge solvers per ClusterIssuer.
Look at `values-multiple-solvers.yaml` for example.
NB. Depending on cloud provider (for dns solvers), values might differ,
currently only `route53` & `cloudflare` are supported by chart.
[Full list of DNS](https://cert-manager.io/docs/configuration/acme/dns01/)
2. Place values file in your `kubeaid-config` repository under 'k8s/{clustername}/argocd-apps/values-cert-manager.yaml'
3. Place [examples/cert-manager.yaml](examples/cert-manager.yaml)
in your `kubeaid-config` repository under 'k8s/{clustername}/argocd-apps/templates' -
be sure to adjust paths to match your kubeaid and kubeaid-config repositories.

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
Check how to [complete backup Cert-Manager resources](https://cert-manager.io/docs/tutorials/backup/).
- For multiple DNS solvers you must provide `dnsNames` field. That will hold dns names cloud provider is handling.

## Secrets

- Create cloudflare api token secret

```sh
kubectl create secret generic cloudflare-api-token-secret -n cert-manager --dry-run=client --from-literal=api-token=1234567890123 -o yaml | kubeseal --controller-name sealed-secrets --controller-namespace system -o yaml - > cloudflare-api-token-secret.yaml
```

## Backup and recovery

- Cert-manager setup involves creation of secrets, i.e. ACME server account credentials, cloud provider creds, etc.
<!-- markdownlint-disable -->
- We suggest you backup the ACME server account secret, f.ex. by enabling Velero application (see below) - as this secret is created by cert-manager and is needed to cancel an issued certificate ahead of time.
[read](../sealed-secrets/README.md#how-to-backup-and-restore-sealed-secrets)
this guide.
<!-- markdownlint-enable -->
