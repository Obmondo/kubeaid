# Puppet Server with Linuxaid

## Eyaml secret

* Secret name needs to be **eyaml-volume**

## Secret setup to access puppet and hieradata git repo

* Create hiera repo secret

```sh
kubectl create secret generic hiera-repo-secret --dry-run=client --from-literal=known_hosts='|1|NHSERmAKuZlYI4g= ssh-ed25519 AAAAC3NzaC1lZDkHxUc' --from-file=id_rsa=/path/to/ssh_priv.key -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml
```

* Create puppet repo secret

```sh
kubectl create secret generic hiera-repo-secret --dry-run=client --from-literal=known_hosts='|1|NHSERmAKuZlYI4g= ssh-ed25519 AAAAC3NzaC1lZDkHxUc' --from-file=id_rsa=/path/to/ssh_priv.key -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml
```
