# Updating helm repository

- Go to kubeaid repo and check for the script `/bin/helm-repo-update.sh`.
- This script will help to update the latest code from the github repository.

```txt
# Updating argo-cd helm repository 
./bin/helm-repo-update.sh --update-helm-chart argo-cd
```

- This script will remove the old helm and download the latest in targz format from github repository.
- It will also untar the downloaded files.
- After the untar is done you can check the difference with `git diff` and push your changes to the repository.
