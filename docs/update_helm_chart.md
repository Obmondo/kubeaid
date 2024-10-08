# Adding new charts to argocd-helm-charts

To add an upstream chart :

- create a new folder under kubeaid/argocd-helm-charts/

```bash
  mkdir <chart name>
```

- Add a Chart.yaml inside the folder with version and repo URL of the upstream Helm chart.
It should be similar to the example argocd chart below.

```yaml
apiVersion: v1
name: argo-cd
version: 2.2.2
dependencies:
  - name: argo-cd
    version: 3.29.5
    repository: https://argoproj.github.io/argo-helm
```

Use [this script](../bin/helm-repo-update.sh)
to get the upstream chart and dependencies

```sh
./bin/helm-repo-update.sh --update-helm-chart <name-of-chart>
```

Note:

- Remove the database dependency charts coming with upstream chart.
- We use `db-operators` to manage the databases.
For example `postgres-operator` for postgres for postgresql database and so on.
<!-- markdownlint-disable -->
- Check
[doc](postgres-operator/README.md) about postgres operator and how that works.
<!-- markdownlint-enable -->
