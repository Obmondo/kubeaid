# Argo CD

## replace admin password

Source: https://github.com/argoproj/argo-cd/blob/master/docs/faq.md#i-forgot-the-admin-password-how-do-i-reset-it

generate new becrypt string by:
NB. SPACE in front of 'python' command IS IMPORTANT - as it ensures its NOT stored in your bash history
```
sudo apt install python-bcrypt
 python -c 'import bcrypt; print(bcrypt.hashpw(b"PASSWORD", bcrypt.gensalt(rounds=15)).decode("ascii"))'
kubectl -n argocd patch secret argocd-secret -p '{"stringData": { "admin.password": "<insert-bcrypt-hash>", "admin.passwordMtime": "'$(date +%FT%T%Z)'" }}'

```
and KILL the pod(s) called `argo-cd-argocd-server-*`