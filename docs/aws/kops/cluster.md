# Setup Kubernetes cluster on AWS with Kops

## Prerequisite

  ```text
  kops
  awscli
  ```

## Setup

* Configure your AWS profile

   ```sh
   export AWS_PROFILE=default
   ```

* Create a [values.yaml](./samples/values.yaml) and export the values.yaml file

   ```sh
   export OBMONDO_VARS_FILE=/path/to/yaml/values/file
   ```

* Setup wireguard instance for [vpn setup](./wireguard.md) if you want one. This is optional

* Deploy the cluster

    ```sh
    cd terragrunt/kops

    terragrunt run-all plan
    terragrunt run-all apply
    INFO[0000] The stack at /home/ashish/k8id-all/k8id/terragrunt/kops will be processed in the following order for command apply:
    Group 1
    - Module /home/ashish/k8id-all/k8id/terragrunt/kops/kops_bucket
    - Module /home/ashish/k8id-all/k8id/terragrunt/kops/vpc

    Group 2
    - Module /home/ashish/k8id-all/k8id/terragrunt/kops/peering

    Group 3
    - Module /home/ashish/k8id-all/k8id/terragrunt/kops/cluster

    Group 4
    - Module /home/ashish/k8id-all/k8id/terragrunt/kops/iam

    Group 5
    - Module /home/ashish/k8id-all/k8id/terragrunt/kops/helm

    Are you sure you want to run 'terragrunt apply' in each folder of the stack described above? (y/n) y
    ```

* Argocd Setup

  * Arogcd `root` app Setup [docs](../../../argocd-helm-charts/argo-cd/Readme.md/#setup-root-argocd-application)
  * Arogcd repo Setup [docs](../../../argocd-helm-charts/argo-cd/Readme.md/#add-argocd-repos)
