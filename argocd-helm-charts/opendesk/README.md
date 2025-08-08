# Opendesk setup


## Installation

1. Basic requirements are - https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/develop/docs/requirements.md#tldr

2. We need to have the helm version less than `3.18.0`. We have done our testing with helm version as `3.17.4`

3. In your cluster the Storage class you are using MUST have sticky bit set. Its the limitation of `openproject`.
Ref - https://github.com/opf/helm-charts/blob/main/charts/openproject/templates/_helpers.tpl#L90

NOTE: We can't provide the SC name right now in opendesk via values file. So, it will always pick up the default one.

4. Using https://easydmarc.com/tools/dkim-record-generator - create a key pair for domain using which you will be sending the mail with selector as default and key length as 4096.
There you will see:

```
Publish the following DNS TXT record on default ._domainkey.$domain subdomain
```
add that in your DNS config tool.

Copy the private key and create a secret named `opendesk-dkimpy-milter` from that.

## Run the build script

The build script needs two variables - values file and kubeaid-config repo path.
Sample values [file](./values.yaml)

NOTE: both the paths must be absolute paths which means you need to provide the entire path.

```bash
./build.sh $values.file $kubaid-config-path
```

The kubeaid-config repo path should be such that the opendesk.yaml file get added in opendesk app.
For eg - the kubeaid-config repo path can be like `kubeaid-config/k8s/$clustername/opendesk` 

Once the script runs it will generate a opendesk.yaml file inside the `$kubaid-config-path` provided which you can apply in your cluster.

You can look into a sample opendesk.yaml file [here](./examples/opendesk.yaml)

NOTE: you need to have `opendesk` namespace created in the cluster
