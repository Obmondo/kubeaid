# Puppet Server with Linuxaid

## Eyaml secret

* Secret name needs to be **eyaml-volume**

## Secret setup to access puppet and hieradata git repo

* Create hiera and puppet git repo secret
* Create a Bot user on github/gitea
* Create a PAT and give only **read** permission for the below two repo (on gitea there is no option to be repo specific)
* Create a file based on the example [file](./examples/netrc)

```sh
kubectl create secret generic hiera-git-secret --dry-run=client --from-file=netrc=./netrc.enableit -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml
```

* Create puppet repo secret

```sh
kubectl create secret generic puppet-git-secret --dry-run=client --from-file=netrc=./netrc.enableit -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml
```

## Environment name

* Env name gets changed, when using hyphen, so watch out for that

```
Environment "adding-users-in-computer10" contained non-word characters, correcting name to adding_users_in_computer10
```
