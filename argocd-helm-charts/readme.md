# Updating argocd-helm-charts applications

- All the concerned applications to be updated are located in https://gitlab.enableit.dk/kubernetes/argocd-apps/-/tree/master/argocd-helm-charts

## Test update - with current values files

- generate current helm yaml output

```bash
  helm dep up ./<application-folder-name>
  helm template ./<application-folder-name> --values ./<application-folder-name>/values.yaml --values /path/to/cluster-specific-values.yaml > before.yaml

```

- Update the umbrella and Upstream chart versions in ```Chart.yaml```
  - set this chart (the umbrealla chart) to same as AppVersion in upstream chart
  - Update dependency chart version to match the one you want to update to (see link to upstream source in Chart.yaml)


- generate helm yaml output for new version

```bash
  helm dep up ./<application-folder-name>
  helm template ./<application-folder-name> --values ./<application-folder-name>/values.yaml --values /path/to/cluster-specific-values.yaml > after.yaml
```

- push changes to MR 

- Then when merged, it should be out of sync. Sync it on argo-cd

- Confirm the version has been updated

- updating charts.yaml for the 2 versions and helm dep up will update Chart.lock

- if it doesn't automatiically, CI will fail and it will then inform you what exactly should be included in the Chart.lock file - for it to succed.
