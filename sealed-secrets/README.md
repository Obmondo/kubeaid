# k8s-sealedsecrets-EnableIT
Sealed secrets for EnableIT clusters

# Important - verify
Look in `argocd -> applications -> secrets` and verify it shows your unsealed
secret as well as the sealed one.

If the unsealed one is not showing it is most likely because secret already
exists in an unmanaged version, in which case you must add an annotation to the
existing secret:

```yaml
sealedsecrets.bitnami.com/managed: "true"
```

Then restart sealed-secrets pod in kube-system to make it do its job (it has
already given up at this point).

# Create a json/yaml-encoded Secret somehow:
### note: use of `--dry-run` - this is just a local file!

```sh
echo -n bar | kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-file=foo=/dev/stdin -o json >mysecret.json
kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-literal=username=mydevuser -o json >mysecret.json
kubectl create secret tls mysecret -n target-namespace-in-k8s --dry-run=client --key="tls.key" --cert="tls.crt" -o json >mysecret.json
kubectl create secret generic alertmanagerconfig -n target-namespace --from-file=./alertmanager.yml --dry-run=client -o json >mysecret.json
```

## From stdin

Set `$username` and run this command:

```sh
kubectl create secret generic mysecret -n target-namespace-in-k8s --dry-run=client --from-file="${username}"=/dev/stdin -o json > mysecret.json
```

Enter the password and hit `^D` to send EOF.

Example:

~~~
kubectl create secret generic keycloak-admin -n keycloak --from-file=keycloak-admin=/dev/stdin -o json > secrets/keycloak/keycloak-secret.json
~~~

# This is the important bit:
**NOTE: default format is json!**

```sh
#for pulling public cert from service in cluster
$ kubeseal --controller-name sealed-secrets --controller-namespace system <mysecret.json >mysealedsecret.json

#for using local public cert (Does not work any more!)
#$ kubeseal --cert secret-certificate.pem <mysecret.json >mysealedsecret.json

```

And add `mysealedsecret.json` to repo under `secrets/$namespace/`
