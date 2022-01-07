# Updating argocd-helm-charts applications

- All the concerned applications to be updated are located in https://gitlab.enableit.dk/kubernetes/argocd-apps/-/tree/master/argocd-helm-charts

- Update apps on git one after the other 

- Save a template file before the update:

```bash
  helm dep up /path/to/repo
  helm template /path/to/repo --values /path/to/values.yaml > before.yaml

```

- Update the umbrella and Upstream chart versions in ```Chart.yaml```

- Save the template file after update again

```bash
  helm dep up /path/to/repo
  helm template /path/to/repo --values /path/to/values.yaml > after.yaml
```

- Make an MR per helm chart 

- Then when merged, it should be out of sync. Sync it on argo-cd

- Confirm the version has been updated

- updating charts.yaml for the 2 versions and helm dep up will update Chart.lock

- if it doesn't automatiically, CI will fail and it will then inform you what exactly should be included in the Chart.lock file - for it to succed.
