# Demonstrating KubeAid (part 1) - Bootstrapping and upgrading a self-managed K8s cluster in AWS, effortlessly, using ClusterAPI and KubeAid

KubeAid is a comprehensive Kubernetes management suite designed to simplify cluster setup, management and monitoring through GitOps and automation principles. Recently, we’ve introduced support for provisioning and managing the lifecycle of Kubernetes clusters efforlessly using [ClusterAPI](https://cluster-api.sigs.k8s.io).

In this blog post, we’ll walk through the process of setting up a self-managed Kubernetes v1.31.0 cluster on AWS using ClusterAPI. The cluster will run on ARM-based EC2 instances powered by the latest Ubuntu 24.04 LTS version. We'll then upgrade the cluster to Kubernetes version v1.32.0.

## The KubeAid Bootstrap Script

- Provisioning a self-managed Kubernetes v1.31.0 cluster running on custom ARM-based AMI, using ClusterAPI
- Installing Cilium in kube-proxyless mode
- Installig and setting up primitives like Sealed Secrets, ArgoCD, KubePrometheus etc.

Doing all this manually, is a tedious and complex process! To make life simpler, we've developed a GoLang script, named `KubeAid Bootstrap Script`, which automates the necessary steps for you.

The KubeAid Bootstrap Script currently **supports Linux and MacOS** and requires quite a few prerequisite tools (like clusterawsadm, gojsontoyaml, kubeseal, clusterctl etc.) installed in your system. This is why we'll be using it's [containerized version](https://github.com/Obmondo/kubeaid-bootstrap-script/pkgs/container/kubeaid-bootstrap-script) in this tutorial. The container image has all the pre-requisite tools already installed.

Run this command to pull the container image to your local machine :

```sh
docker pull ghcr.io/obmondo/kubeaid-bootstrap-script:v0.5
```

## Custom AMI targetting Kubernetes v1.31.0 and Ubuntu 24.04

ClusterAPI requires custom AMIs for the VMs that host the Kubernetes cluster. These AMIs must include essential tools like `kubeadm`, `kubelet`, `containerd` etc. pre-installed.

These custom AMIs are built using the the [image-builder](https://github.com/kubernetes-sigs/image-builder) project. While the Kubernetes SIG team provides [pre-built AMIs](https://cluster-api-aws.sigs.k8s.io/topics/images/built-amis), they currently **lack support for ARM CPU architecture and the recent versions of Kubernetes and Ubuntu**.

To address this, we have [forked](https://github.com/Obmondo/image-builder) the image-builder project, added support for the above and published ARM based custom AMIs targetting Kubernetes [v1.31.0]() / [v1.32.0]() and Ubuntu 24.04.

> If you wish to build the custom AMI yourself, you can refer to this [blog post](https://github.com/Obmondo/kubeaid/blob/master/docs/aws/capi/ami.md).

## Bootstrapping the cluster using ClusterAPI

First, fork the [KubeAid Config](http://github.com/Obmondo/kubeaid-config) repo.

Run and exec into the KubeAid Bootstrap Script container :

```sh
NETWORK_NAME=k3d-management-cluster
if ! docker network ls | grep -q $(NETWORK_NAME); then \
	docker network create $(NETWORK_NAME); \
fi

docker run --name kubeaid-bootstrap-script \
	--network $(NETWORK_NAME) \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ./outputs:/outputs \
	-d \
  ghcr.io/obmondo/kubeaid-bootstrap-script:v0.5

docker exec -it kubeaid-bootstrap-script /bin/bash
```

KubeAid Bootstrap Script requires a config file, which it'll use to prepare your [KubeAid Config](https://github.com/Obmondo/kubeaid-config) fork. Generate a sample config file, using :

```sh
kubeaid-bootstrap-script config generate aws \
	--config ./outputs/kubeaid-bootstrap-script.config.yaml
```

Open the sample YAML configuration file generated at `./outputs/kubeaid-bootstrap-script.config.yaml` and update the following fields with your specific values :

- **git.username** and **git.password**
- **forks.kubeaidConfig**
- **cloud.aws.controlPlane.ami.id** and **cloud.aws.nodeGroups.\*.ami.id**
- **cloud.aws.sshKeyName** and **cloud.aws.nodeGroups.\*.sshKeyName**

  If you don't have an existing SSH KeyPair in the corresponding AWS region, you can generate one using this command :

  ```sh
  aws ec2 create-key-pair \
  	--key-name kubeaid-demo \
  	--query 'KeyMaterial' --output text --region <aws-region> > ./outputs/kubeaid-demo.pem
  ```

Export your AWS credentials as environment variables :

```sh
export AWS_REGION="us-east-1"
export AWS_ACCESS_KEY_ID="xxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxxxxxxx"
export AWS_SESSION_TOKEN="xxxxxxxxxx"
```

Now to bootstrap the Kubernetes (v1.31.0) cluster with 3 control plane node and worker nodes `autoscaled` between 1 to 3 replicas, you can simply run :

```sh
kubeaid-bootstrap-script cluster bootstrap aws \
	--config /outputs/kubeaid-bootstrap-script.config.yaml
```

> [!NOTE]
>
> You'll notice we're mounting the Docker socket to the container. This allows the container to spinup a K3D cluster on your host system. That K3D cluster is what we call the `temporary management cluster` / `dev environment`. The main cluster will be bootstrapped using that temporary management cluster. KubeAid Bootstrap Script will then make the main cluster manage itself (this is called `pivoting`). There will then be no need for the temporary management cluster anymore.

> [!NOTE]
>
> If you later wish to spinup that temporary management cluster locally for some reason (updating / deleting the provisioned cluster), you can use the `kubeaid-bootstrap-script devenv create aws` command.

Once the cluster is bootstrapped, you can find it's kubeconfig at `./outputs/provisioned-cluster.kubeconfig.yaml`.

Run :

```sh
export KUBECONFIG=./outputs/provisioned-cluster.kubeconfig.yaml
kubectl get pods --all-namespaces
```

and you'll see Cilium, AWS CCM (Cloud Controller Manager), CertManager, Sealed Secrets, ArgoCD, KubePrometheus etc. pods running :).

> If you wish to access the K3D management cluster for some reason, then use `./outputs/management-cluster.host.kubeconfig.yaml` to access it from the host / `./outputs/management-cluster.container.kubeconfig.yaml` to access it from inside the container.

## Accessing ArgoCD dashboard

Get the password for accessing ArgoCD admin dashboard, by running this command :

```sh
kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Then run :

```sh
kubectl port-forward svc/argo-cd-argocd-server -n argo-cd 8080:443
```

and visit [https://localhost:8080](https://localhost:8080) to access the ArgoCD admin dashboard.

## Upgrading the cluster to Kubernetes v1.32.0

Doing Kubernetes version upgrade for a cluster, manually, is a hastle! You can read about it in [Kubernetes' official docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/). ClusterAPI automates this whole process for you.

First, make sure that you've execed inside the KubeAid Bootstrap Script container and exported your AWS credentials as environment variables.

In a real life scenario, you may have deleted the temporary management cluster / dev environment right after the cluster got bootstrapped. You can bring back the dev environment by doing :

```sh
kubeaid-bootstrap-script devenv create aws \
	--config /outputs/kubeaid-bootstrap-script.config.yaml
```

Now, to upgrade the cluster, run :

```sh
kubeaid-bootstrap-script cluster upgrade aws \
	--config /outputs/kubeaid-bootstrap-script.config.yaml \
	--k8s-version v1.32.0 \
	--ami-id ami-xxxxxxxxxx
```

It'll update your KubeAid config repository (specifically, the corresponding **capi-cluster.values.yaml** file) and trigger Kubernetes version upgrades for the Control Plane and each node-group.

Now that we have bootstrapped a Kubernetes cluster and effortlessly upgraded it, let's move to [Part 2]() where we'll demonstrate, how you can **easily install open-source apps** (like `Keycloak.X`) in your cluster, using KubeAid.

> If you wish to delete the provisioned cluster, then you can use the `kubeaid-bootstrap-script cluster delete` command.
