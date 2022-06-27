# Sealed secrets

Sealed secrets are kubernetes secrets where the data is encrypted using the cluster controllers public key, so it can
only be read by the controller, so we can safely store them in repo.

## How to add a sealed secret

You generate a sealed secret manifest from a normal secret manifest and apply it. But you don't have to apply it, you
just add it to this repo and ArgoCD should find it automatically.

**Note: default format is JSON!**

```sh
# for using local public cert
kubeseal --cert secret-certificate.pem <mysecret.json >mysealedsecret.json

#for pulling public cert from service in cluster
kubeseal --controller-namespace system --controller-name sealed-secrets < mysecret.json > mysealedsecret.json
```

### Important - verify

Look in `argocd -> applications -> secrets` and verify it shows your unsealed secret as well as the sealed one.. if the
unsealed one is not showing it is most likely because secret already exists in an unmanaged version, in which case you
must add an annotation to the existing secret:

```yaml
sealedsecrets.bitnami.com/managed: "true"
```

and then restart sealed-secrets pod in kube-system to make it do its job (it has already given up at this point).

## Create a json/yaml-encoded secret somehow

You can turn any kubernetes secret into a sealed secret, so it doesnt matter how the normal secret was created, but here
are some examples of how to create a secret.

**note: use of `--dry-run` - this is just a local file!**

```sh
echo -n bar | kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-file=foo=/dev/stdin -o json >mysecret.json
kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-literal=username=mydevuser -o json >mysecret.json
kubectl create secret tls mysecret -n target-namespace-in-k8s --dry-run=client --key="tls.key" --cert="tls.crt" -o json >mysecret.json
kubectl create secret generic alertmanagerconfig -n target-namespace --from-file=./alertmanager.yml --dry-run=client -o json >mysecret.json
```

and add `mysealedsecret.json` to repo under `secrets/$namespace/`

### From stdin

Set `$username` and run this command:

```sh
kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-file="${username}"=/dev/stdin -o json > mysecret.json
```

Enter the password and hit `^D` to send EOF.

Example:

```sh
kubectl create secret generic keycloak-admin -n keycloak --from-file=keycloak-admin=/dev/stdin -o json > secrets/keycloak/keycloak-secret.json
```

## Add a secret to pull an image from a Private Registry

Some container images are a part of private registry. To pull images from those repos, we need to create a secret and specify the same in our pod under `imagePullSecrets`.

The secret can be generated using this command :

```sh
kubectl create secret --namespace system --dry-run=client docker-registry myDockerSecret --docker-server=<registry-url> --docker-username=xxx --docker-password=xxx -o yaml > myDockerSecret.yaml
```
Using kubeseal, the sealed secret can be generated as mentioned above.
