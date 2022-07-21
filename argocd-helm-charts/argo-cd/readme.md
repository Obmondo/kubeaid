# Argo CD

## replace admin password

Run our script to do this:
Source: https://github.com/argoproj/argo-cd/blob/master/docs/faq.md#i-forgot-the-admin-password-how-do-i-reset-it

NB. SPACE in front of 'bcrypt-tool' command IS IMPORTANT - as it ensures its NOT stored in your bash history

```sh
# sudo snap install bcrypt-tool

# <need-space> bcrypt-tool hash "lolyourpassword123" 10

# kubectl -n argocd patch secret argocd-secret -p '{"stringData": { "admin.password": "<insert-bcrypt-hash>", "admin.passwordMtime": "'$(date +%FT%T%Z)'" }}'
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

## Configure argocd with keycloak

source: https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/keycloak/

* To add any new user into argocd as an admin
  login to keycloak
  -> Users
  -> Select User
  -> Under `groups` tab
  -> Select the required group (which you have created from the above doc)
  -> done
