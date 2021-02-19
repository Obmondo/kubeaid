Install argo-cd:
```
helm install -n argocd argo-cd init/charts/argo-cd

```
Add secret with a username and a password (a personal-access-token) that is valid and has access to that repo.
```
kubectl create secret generic argo-cd-blackwoodseven-github --from-literal=username=KlavsKlavsen --from-literal=password='234dfaf23rf2323232323232323xxxxxxxxxxxxx'
```

init contains argo-cd-root-app - which is installed using:
```
helm template init/argo-cd-root-app | kubectl apply -f -
```

And its Chart.yaml points to this repo argo-cd-helm-apps - so once Root app is installed - it'll pick up the apps in there and start setting them up.

Now we can remove helm management of argo-cd - as argo-cd manages itself (as argo-cd is one of the apps in above apps folder).

```
kubectl delete secret -l owner=helm,name=argo-cd

```
