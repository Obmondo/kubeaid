# Puppet Server with Linuxaid

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

## Eyaml secret

* Create the private and public key.

```sh
# Run the following command to generate a private key:
docker run --rm  --name hiera-eyaml -it ubuntu:latest /bin/bash
root@b20b838ad0cb:/# apt update && apt install ruby
root@b20b838ad0cb:/# gem install hiera-eyaml
root@b20b838ad0cb:/# eyaml createkeys --pkcs7-private-key=/tmp/private_key.pkcs7.pem --pkcs7-public-key=/tmp/public_key.pkcs7.pem
```

* Create the k8s sealed secret with the above generated keys

```sh
sudo chmod 775  /tmp/private_key.pkcs7.pem
sudo chmod 775  /tmp/public_key.pkcs7.pem
kubectl create secret generic eyaml-keys --namespace puppetserver --dry-run=client --from-file=private_key.pkcs7.pem=/tmp/private_key.pkcs7.pem --from-file=public_key.pkcs7.pem=/tmp/public_key.pkcs7.pem -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml > eyaml-keys.yaml
```
