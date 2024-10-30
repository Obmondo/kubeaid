# Demonstrating KubeAid (part 1) - Bootstrapping and upgrading a self-managed K8s cluster in AWS, effortlessly, using ClusterAPI

KubeAid is a comprehensive Kubernetes management suite designed to simplify cluster setup, management and monitoring through GitOps and automation principles. Recently, we’ve introduced support for provisioning and managing the lifecycle of Kubernetes clusters efforlessly using [ClusterAPI](https://cluster-api.sigs.k8s.io).

In this blog post, we’ll walk through the process of setting up a self-managed Kubernetes v1.30 cluster on AWS using ClusterAPI. The cluster will run on ARM-based EC2 instances powered by the latest Ubuntu 24.04 LTS version. We'll then upgrade the cluster to Kubernetes version v1.31.

## The KubeAid Bootstrap Script

- Provisioning a self-managed Kubernetes v1.30 cluster running on custom ARM-based AMI, using ClusterAPI
- Installing Cilium in kube-proxyless mode
- Installig Sealed Secrets, ArgoCD and KubePrometheus

Doing all this manually, is a tedious and complex process! To make life simpler, we've developed a GoLang script, named `KubeAid Bootstrap Script`, which automates the necessary steps for you.

The KubeAid Bootstrap Script currently **only supports Linux** and requires quite a few prerequisite tools (like clusterawsadm, gojsontoyaml, kubeseal, clusterctl etc.) installed in your system. This is why we'll be using it's [containerized version](https://github.com/Obmondo/kubeaid-bootstrap-script/pkgs/container/kubeaid-bootstrap-script) in this tutorial. The container image has all the pre-requisite tools already installed.

Run this command to pull the container image to your local machine :
```sh
docker pull ghcr.io/obmondo/kubeaid-bootstrap-script:v0.1
```

## Custom AMI targetting Kubernetes v1.30.0 and Ubuntu 24.04

ClusterAPI requires custom AMIs for the VMs that host the Kubernetes cluster. These AMIs must include essential tools like `kubeadm`, `kubelet`, `containerd` etc. pre-installed.

These custom AMIs are built using the the [image-builder](https://github.com/kubernetes-sigs/image-builder) project. While the Kubernetes SIG team provides [pre-built AMIs](https://cluster-api-aws.sigs.k8s.io/topics/images/built-amis), they currently **lack support for ARM CPU architecture and the recent versions of Kubernetes and Ubuntu**.

To address this, we have [forked](https://github.com/Obmondo/image-builder) the image-builder project, added support for the above and published ARM based custom AMIs targetting Kubernetes [v1.30.0]() / [v1.31.0]() and Ubuntu 24.04.

## Bootstrapping the cluster using ClusterAPI

First, fork the [KubeAid Config](http://github.com/Obmondo/kubeaid-config) repo.

KubeAid Bootstrap script requires a config file, which it'll use to prepare your [KubeAid Config](https://github.com/Obmondo/kubeaid-config) fork. You can generate a sample config file, by running :
```sh
docker run --name kubeaid-bootstrap-script --rm \
  -v ./outputs:/outputs \
  ghcr.io/obmondo/kubeaid-bootstrap-script:v0.1 \
  kubeaid-bootstrap-script generate-sample-config \
    --cloud aws \
    --k8s-version v1.30.0
```

Open the sample YAML configuration file generated at `./outputs/kubeaid-bootstrap-script.config.yaml` and update the following fields with your specific values :
- git.username and git.password
- forks.kubeaidConfig
- cloud.aws.accessKey, cloud.aws.secretKey and cloud.aws.sessionToken (if you're using SSO)
- cloud.aws.sshKeyName and machinePools.*.sshKeyName

	If you don't have an existing SSH KeyPair in the corresponding AWS region, you can generate one using this command :
	```sh
	aws ec2 create-key-pair --key-name kubeaid-demo --query 'KeyMaterial' --output text --region <aws-region> \
		> ./outputs/kubeaid-demo.pem
	```

Now to bootstrap the Kubernetes (v1.30.0) cluster with 1 control plane node and worker nodes `autoscaled` between 2 to 5 replicas, you can simply run :
```sh
docker run --name kubeaid-bootstrap-script \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ./outputs:/outputs \
  ghcr.io/obmondo/kubeaid-bootstrap-script:v0.1 \
	kubeaid-bootstrap-script bootstrap-cluster \
    --config-file /outputs/kubeaid-bootstrap-script.config.yaml
```
> [!NOTE] You'll notice we're mounting the Docker socket to the container. This allows the container to spinup a K3D cluster on your host system. That K3D cluster is what we call the `temporary management cluster`. The main cluster will be bootstrapped using that temporary management cluster. The KubeAid Bootstrap Script will then make the main cluster manage itself. There will then be no need for the temporary management cluster anymore.

Once the cluster is bootstrapped, you can find it's kubeconfig at `./outputs/provisioned-cluster.kubeconfig.yaml`.

Run :
```sh
export KUBECONFIG=./outputs/provisioned-cluster.kubeconfig.yaml
kubectl get pods --all-namespaces
```
and you'll see Cilium, AWS CCM (Cloud Controller Manager), CertManager, Sealed Secrets, ArgoCD and KubePrometheus pods running :).

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

## Upgrading the cluster to Kubernetes v1.31

Doing Kubernetes version upgrade for a cluster, manually, is a hastle! You can read about it in [Kubernetes' official docs](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/). ClusterAPI automates this whole process for you.

Go to `k8s/<cluster-name>/argocd-apps/capi-cluster.values.yaml` file in your KubeAid config fork, and change `global.kubernetes.version` from `v1.30.0` to `v1.31.0`. Update the AMI IDs to **ami-05ec083b8943c8487** as well. Then push those changes to upstream.

Visit the ArgoCD admin dashboard and sync the `CAPI Cluster` App. Wait for some time....once the CAPI Cluster app is successfully synced, the Kubernetes version upgrade will be complete!

Now that we have bootstrapped a Kubernetes cluster and effortlessly upgraded it, let's move to [Part 2]() where we'll demonstrate, how you can **easily install open-source apps** (like `Keycloak.X`) in your cluster, using KubeAid.

