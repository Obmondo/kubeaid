# Sealed secrets

Sealed secrets are kubernetes secrets where the data is encrypted using the cluster controllers public key, so it can
only be read by the controller, so we can safely store them in repo.

## How to add a sealed secret

### Create a json/yaml-encoded secret somehow

You can turn any kubernetes secret into a sealed secret, so it doesnt matter how the normal secret was created, but here
are some examples of how to create a secret.

**note: use of `--dry-run` - this is just a local file!**

```sh
# create a generic secret foo=bar by using the STDIN
echo -n bar | kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-file=foo=/dev/stdin -o json >mysecret.json

# create a generic secret username=mydevuser passed as the literal value
kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-literal=username=mydevuser -o json >mysecret.json

# create a tls secret with specified tls.key and tls.crt files
kubectl create secret tls mysecret -n target-namespace-in-k8s --dry-run=client --key="tls.key" --cert="tls.crt" -o json >mysecret.json

# create a generic secret from a files contents (gets encoded as base64 and can be made available as file inside pod).
kubectl create secret generic alertmanagerconfig -n target-namespace --from-file=./alertmanager.yml --dry-run=client -o json >mysecret.json

# Create a dockerlogin secret which can be used f.ex. as image pullsecret
kubectl create secret --namespace system --dry-run=client docker-registry myDockerSecret --docker-server=<registry-url> --docker-username=xxx --docker-password=xxx -o json > mysecret.json
```

Using kubeseal, the secret can then be converted to a sealed secret.

```sh
# for using local public cert
kubeseal --cert secret-certificate.pem <mysecret.json >mysealedsecret.json

#for pulling public cert from service in cluster
kubeseal --controller-namespace system --controller-name sealed-secrets < mysecret.json > mysealedsecret.json
```

**mysecret.json** is your target secret file, which will generated to sealedsecret one (can be yaml format too)

**sealedsecret.json** is a new generated sealedsecret file (name can be changed also)

This can then be imported manually using kubectl apply for confirming.

### Important - verify

Look in `argocd -> applications -> secrets` and verify it shows your unsealed secret as well as the sealed one.. if the
unsealed one is not showing it is most likely because secret already exists in an unmanaged version, in which case you
must add an annotation to the existing secret:

```yaml
sealedsecrets.bitnami.com/managed: "true"
```

and then restart sealed-secrets pod in kube-system to make it do its job (it has already given up at this point).
