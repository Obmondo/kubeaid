# Azure Provider

The `azure` provider is used to provision a KubeAid managed Kubernetes cluster in Azure, which has the following setup :

- [Cilium](https://cilium.io) CNI, running in [kube-proxyless mode](https://cilium.io/use-cases/kube-proxy/).

- [Azure Workload Identity](https://azure.github.io/azure-workload-identity/docs/).

- Autoscalable node-groups, with **scale to / from 0** and **labels and taints propagation** support.

- GitOps, using [ArgoCD](https://argoproj.github.io/cd/), [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets), [ClusterAPI](https://cluster-api.sigs.k8s.io) and [CrossPlane](https://www.crossplane.io).

- Monitoring, using [KubePrometheus](https://prometheus-operator.dev).

- Disaster Recovery, using [Velero](https://velero.io).

## Prerequisites

- Fork the [KubeAid Config](https://github.com/Obmondo/kubeaid-config) repository.

- Keep your Git provider credentials ready.
  > For GitHub, you can create a [Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token), which has the permission to write to your KubeAid Config fork.
  > That PAT will be used as the password.

- A Linux or MacOS computer, with atleast 16GB of RAM.
  > You can try with one having 8GB RAM, but some of the pods might get killed due to OOM issue.

- Have [Docker](https://www.docker.com/products/docker-desktop/) running locally.

- [Register an application (Service Principal) in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app).

- An OpenSSH type SSH keypair, whose private key you'll use to SSH into the VMs.

- A PEM type SSH keypair, which will be used for Azure Workload Identity setup.

## Installation

```bash
KUBEAID_CLI_VERSION=$(curl -s "https://api.github.com/repos/Obmondo/kubeaid-cli/releases/latest" | jq -r .tag_name)
OS=$([ "$(uname -s)" = "Linux" ] && echo "linux" || echo "darwin")
CPU_ARCHITECTURE=$([ "$(uname -m)" = "x86_64" ] && echo "amd64" || echo "arm64")

wget "https://github.com/Obmondo/kubeaid-cli/releases/download/${KUBEAID_CLI_VERSION}/kubeaid-cli-${KUBEAID_CLI_VERSION}-${OS}-${CPU_ARCHITECTURE}"
sudo mv kubeaid-cli-${KUBEAID_CLI_VERSION}-${OS}-${CPU_ARCHITECTURE} /usr/local/bin/kubeaid-cli
sudo chmod +x /usr/local/bin/kubeaid-cli
```

## Preparing the Configuration Files

You need to have 2 configuration files : `general.yaml` and `secrets.yaml` containing required credentials.

Run :
```shell script
kubeaid-cli config generate azure
```
and a sample of those 2 configuration files will be generated in `outputs/configs`.

Edit those 2 configuration files, based on your requirements.
> Let's assume that, you'll be using Kubernetes `v1.31.0`.

## Bootstrapping the Cluster

Run the following command, to bootstrap the cluster :
```shell script
kubeaid-cli cluster bootstrap
```

Aside from the logs getting streamed to your standard output, they'll be saved in `outputs/.log`.

Once the cluster gets bootstrapped, its kubeconfig gets saved in `outputs/kubeconfigs/clusters/main.yaml`.

You can access the cluster, by running :
```shell script
export KUBECONFIG=./outputs/kubeconfigs/main.yaml
kubectl cluster-info
```
Go ahead and explore it by accessing the [ArgoCD]() and [Grafana]() dashboards.

## Upgrading the Cluster

Let's upgrade the cluster from Kubernetes `v1.31.0` to `v1.32.0` :
```shell script
kubeaid-cli cluster upgrade \
  --new-k8s-version v1.32.0
```

> If you want to do an OS upgrade as well, you can specify the new Canonical Ubuntu image offer to be used, via the `--new-image-offer` flag.

## Deleting the Cluster

You can delete the cluster, by running :
```shell script
kubeaid-cli cluster delete main
kubeaid-cli cluster delete management
```
