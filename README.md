# Repository structure

|argocd-clusters-managed | Primary folder - containing applications and configs for each managed cluster, which MAY make use of common resources, such as argocd-helm-charts and argocd-k8s-config. Each clusterfolder is actually a Helm chart - hence applications are put as yaml in ```templates``` folder. |
| --- | --- |
|argocd-helm-charts | Contains ArgoCD helm charts, that points to the actual helm charts (as a dependency listed in Charts.yaml) - and with the default values we want. Each cluster can add override/extra values by listing an extra valuesfile in their argocd-clusters-managed/$clustername folder. |
|argocd-k8sconfig | Kubernetes config objects. Used by all in ```common``` and per-cluster in their indidivual $clustername folder. |
|argocd-application-templates | collection of applications, to be optionally modified and copied into ```argocd-clusters-managed/$clustername/templates``` to be installed on that cluster. |

# Add a new cluster to be managed by this repository/argocd

## Create namespace for argocd installation
```
kubectl create namespace argocd
kubectl config set-context --current --namespace=argocd
```

## Create secret for git repo access

### for https access to git repos 

Add secret with a username and a password (a personal-access-token) that is valid and has access to that repo.

```
kubectl create secret generic argo-cd-blackwoodseven-github --from-literal=username=KlavsKlavsen --from-literal=password='234dfaf23rf2323232323232323xxxxxxxxxxxxx'
```

### for SSH access to git repos

Setup gitlab user and generate SSH keyset (and add public part to that gitlab user).
Grant that user ONLY developer access to the projects it needs. Make sure those have master branch and tags protected in config.

add secret with ssh keys for gitlab argocd SSH access:
```
kubectl create secret generic argocd-sshkey --from-file=ssh-privatekey=/path/to/.ssh/id_rsa --from-file=ssh-publickey=/path/to/.ssh/id_rsa.pub
```

and make sure `sshPrivateKeySecret.name` for repositories in 
`argo-cd-helm-apps/charts/argo-cd/values.yaml` matches above secretname.

## Install argo-cd
```
helm dep update argo-cd-helm-apps/charts/argo-cd
helm install -n argocd argo-cd argo-cd-helm-apps/charts/argo-cd
```

Login to the UI. To get the credentials refer
[argocd admin credentials](pttps://argoproj.github.io/argo-cd/getting_started/#4-login-using-the-cli).

## Install root argocd application - that manages the rest
Install argo-cd root app using:
```
helm template argo-cd-helm-apps/your-cluster-name --show-only templates/root.yaml | kubectl apply -f -
```

And its Chart.yaml points to this repo argo-cd-helm-apps - so once Root app is installed - it'll pick up the apps in there and start setting them up.

Now we can remove helm management of argo-cd - as argo-cd manages itself (as argo-cd is one of the apps in above apps folder).

```
kubectl delete secret -l owner=helm,name=argo-cd
```

## Debugging
Please refer: [Wiki for kubernetes](https://gitlab.enableit.dk/obmondo/wiki/-/tree/master/internal/kubernetes)
