# Argo CD

## replace admin password

Run our script to do this:
Source: https://github.com/argoproj/argo-cd/blob/master/docs/faq.md#i-forgot-the-admin-password-how-do-i-reset-it

generate new becrypt string by:
NB. SPACE in front of 'python' command IS IMPORTANT - as it ensures its NOT stored in your bash history

```sh
sudo apt install python-bcrypt
 python -c 'import bcrypt; print(bcrypt.hashpw(b"PASSWORD", bcrypt.gensalt(rounds=15)).decode("ascii"))'
kubectl -n argocd patch secret argocd-secret -p '{"stringData": { "admin.password": "<insert-bcrypt-hash>", "admin.passwordMtime": "'$(date +%FT%T%Z)'" }}'
```

and KILL the pod(s) called `argo-cd-argocd-server-*`

## argocd status stuck in Progressing

The argocd application in ArgoCD UI remains stuck in Progressing state.

As per argocd faq, the issue is from Traefik and a few other ingress controllers.
https://github.com/traefik/traefik/issues/3377
https://argo-cd.readthedocs.io/en/stable/faq/

The `status.loadBalancer` field is empty for the argocd ingress, and it seems to be the core reason for this issue.

```sh
kubectl -n argocd get ing argo-cd-argocd-server -o jsonpath={.status}
```
