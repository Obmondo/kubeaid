# Why Sealed Secrets?

As we know Secrets are used to store sensitive data like password, keys, certificates and token
In Secrets these values are encoded by base64.
But the actual problem is these encoded values can be easily decoded,
which means if hacker or normal guy get access to your Secrets then
can easily get access to your sensitive data like passwords, token, etc.
To know [more](https://docs.bitnami.com/tutorials/sealed-secrets)

## What is the Solution?

Concept of `private-public` keys. The Secret(or any data) will be encrypted
using Public keys and those encrypted values can only be decrypted using
private key only. So, neither hacker(or normal guy) is having those prvate keys.
Therefore, it can't be decoded. So, it is safely secured.

## Sealed secrets

Sealed Secrets is a solution to encrypt your Kubernetes Secret into a SealedSecret,
which is safe to store – even to a public repository.
The SealedSecret can be decrypted only by the controller running in
the target cluster and nobody else.
Sealed secrets are build on the top of kubernetes secrets where the
data is encrypted using the cluster controllers `public key`, so it can
only be read by the controller. Because the target cluster controller
keeps the `private key` with itself. So no one else other than target
cluster controller could have access to Secrets sesitive data.
To know more, [refer](https://blog.knoldus.com/how-to-encrypt-kubernetes-secrets-with-sealed-secrets/#:~:text=Sealed%20Secrets%20is%20a%20solution,target%20cluster%20and%20nobody%20else)

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

## Templating Sealed Secrets

Sealed secrets have an interesting feature which can use config files
where only a part of the file needs to be encrypted. To use templates in sealed secrets,
create a secret using the examples provided above, and add the `template:` part as
given in the example below:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  creationTimestamp: null
  name: example
spec:
  encryptedData:
    password: AgC2==
    access-token: AgDE==
  template:
    data:
      k8id-pushupdate.yaml: |
        repo-url: https://gitlab.com/example/repo.git
        username: smart_user
        password: "{{ index . "password" }}"
        repo-token: "{{ index . "access-token" }}"
    metadata:
      creationTimestamp: null
      namespace: test
```

The `encryptedData` field can store some random data for the start. All the referenced
fields in the `data` section, need to be present in the `encryptedData` before you attempt to seal the secret.
Then seal and merge the secret using the below command:

```sh
kubectl create secret generic example\
 --dry-run=client \
 --namespace test \
 --from-literal=password="super_secret_pass" \
 --from-literal=access-token="0123abcDEF" -o yaml | \
 kubeseal \
 --controller-namespace system \
 --controller-name sealed-secrets \
 --namespace test -o yaml \
 --merge-into sealedSecret.yaml
```

The `--merge-into` option only changes the encrypted data without changing the whole SealedSecret.
[Original Example](https://github.com/bitnami-labs/sealed-secrets/tree/main/docs/examples/config-template)

## How to backup and restore sealed secrets

### Manual way

We are basically backing up all the tls.crt & tls.key files of the cluster locally, so we can restore them later.

```sh
# This would get all the tls secrets in the cluster from all the name spaces.
kubectl get secrets -n system -l sealedsecrets.bitnami.com/sealed-secrets-key=active -o yaml > backup_key.yml
```

This would backup the ``tls.crt`` & ``tls.key`` in a yaml file locally.

For restoring the secrets, in a cluster use .

```sh
# This would restore the tls secrets in the cluster from the backup file.
kubectl apply -f backup_key.yml
```

### Automated way (velero)

Run the commands from the velero pod in the cluster .

We are backing up the system namespace which contains the sealed secrets if there is no shedule backup already present.
If there is sheduled backup already present skip this command.

```sh
# This would create backup of the sealesecret pod in system namespace.
velero backup create <backup-name> --include-namespaces system --include-resources pods --selector sealedsecrets.bitnami.com/sealed-secrets-key=active
```

Assuming we already have scheduled backup .
Check the backup status using the following command.

```sh
velero get backups
```

Restore the backup with the name that is created/exists.

```sh
velero restore create <restore-name> --include-namespaces system --include-resources pods --selector sealedsecrets.bitnami.com/sealed-secrets-key=active --from-backup <backup-name>
```

### Backup Setup on aws

Create the s3 bucket

```sh
aws s3api create-bucket --bucket kbm-sealed-secrets-backups --region eu-west-1 --endpoint-url=https://s3.obmondo.com
```

## How to access secrets in applications

There are two ways to access secrets in applications.

* In the deployment file, you can use syntax like this when specifying environment variables:

  ```yaml

  - name: CHAT_TOKEN
              valueFrom:
                secretKeyRef:
                  name: {{ .Values.goapi.chat.token }}
                  key: chat

  ```

  In the `values.yaml` file, the value of `goapi.chat.token` can now be specified as, say, `go-tokens`. Now, if there is a sealed secret called `go-tokens` that's already created and accessible and that secret has a key `chat`, then the value of the key `chat` will be assigned to the environment variable `CHAT_TOKEN`.

* Another way to access secrets is by adding a volume mount. In the deployment file, we can add something like this:

  ```yaml
  volumeMounts:
              - name: jwt-tokens
                mountPath: /etc/api/jwt
                readOnly: true
  ```

  Here 'jwt-tokens' refers to a volume that's mounted and contains our secret. The deployment file must also contain details of the volume being mounted like so:

  ```yaml
  volumes:
          - name: jwt-tokens
            secret:
              secretName: jwt-{{ include "api.fullname" . }}

  ```

  The secret name here refers to the name of the sealed secret that should already be created and accessible.

  In this case, we're essentially accessing the secret from a mounted file path instead of directly accessing its value. So, the deployment file could contain an environment variable like so:

  ```yaml
   - name: JWT_RSA_PUBLIC_KEY_PATH
     value: {{ .Values.goapi.jwt.key_path | quote}}

  ```

  `values.yaml` can then contain something like this:

  ```yaml
      key_path: '/etc/api/jwt/publickey'
  ```

  Notice that `/etc/api/jwt` here is the same path as the `mountPath` specified earlier. So, the secret will be accessed from the value of the key `publickey` from a file mounted at `/etc/api/jwt`.
