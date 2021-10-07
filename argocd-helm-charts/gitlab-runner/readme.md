Installs gitlab-runner

# installation - connecting to existing gitlab installation

create secret - with runner token from gitlab installation.
```
kubectl create secret generic gitlab-runner -n gitlab --from-literal=runner-registration-token=xxxgitlab-runnertoken  --from-literal=runner-token=""
```
(or create via sealedsecrets)

Set values file for your cluster with:
```
gitlab-runner:
  gitlabUrl: https://gitlab.yourdomain.tld/
```

Let argocd do the rest