# Opendesk setup


## Installation

1. Basic requirements are - https://gitlab.opencode.de/bmi/opendesk/deployment/opendesk/-/blob/develop/docs/requirements.md#tldr

2. We need to have the helm version less than `3.18.0`. We have done our testing with helm version as `3.17.4`

3. In your cluster the Storage class you are using must have sticky bit set.

For our usecase we have used the [openebs-tmp-hostpath.yaml](./templates/openebs-tmp-hostpath.yaml)

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
