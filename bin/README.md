# Updating helm repository

- Go to k8id repo and check for the script `/bin/helm-repo-update.sh`.
- This script will help to update the latest code from the github repository.

```txt
# Updating argo-cd helm repository 
./bin/helm-repo-update.sh --update-helm-chart argo-cd
```

- This script will remove the old helm and download the latest in targz format from github repository.
- It will also untar the downloaded files.
- After the untar is done you can check the difference with `git diff` and push your changes to the repository.

Note:-

- For mongodb-operator helm update need to be done manually.

```bash
# Updating mongodb-operator helm repository#  
 helm dependency update argocd-helm-charts/mongodb-operator

cd argocd-helm-charts/mongodb-operator/charts

rm -rf community-operator

tar -xvf community-operator-0.8.0.tgz

vim argocd-helm-charts/mongodb-operator/Charts.yaml 

# update the versiom to "0.8.0" and save the file 
```
