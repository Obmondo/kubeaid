# Welcome to **KubeAid.io** - The home of Kubernetes Aid

**KubeAid** is a Kubernetes management suite, offering a way to setup and operate K8s clusters, following gitops and
automation principles.

KubeAid feature goals:

- Setup of k8s clusters on physical servers (on-premise or at e.g. [Hetzner.com](https://hetzner.com)) and in cloud
  providers like Azure AKS, Amazon AWS or Google GCE
- Auto-scaling for all cloud k8s clusters and easy manual scale-up for physical servers
- Manage an ever-growing list of Open Source k8s applications (see `argocd-helm-charts/` folder for a list)
- Build advanced, customized Prometheus monitoring, using just a per-cluster config file, with automated handling of
  trivial alerts, like disk filling.
- Gitops setup - ALL changes in cluster, is done via Git AND we detect if anyone adds anything in cluster or modifies
  existing resources, without doing it through Git.
- Regular application updates with security and bug fixes, ready to be issued to your cluster(s) at will
- Air-gapped operation of your clusters, to ensure operational stability
- Cluster security - ensuring least priviledge between applications in your clusters, via resource limits and
  per-namespace/pod firewalling.
- Backup, recovery and live-migration of applications or entire clusters
- Major cluster upgrades, via a shadow Kubernetes setup utilizing the recovery and live-migration features
- Supply chain attack protection and discovery - and security scans of all software used in cluster

An operations team, typicly has 2 hugely important tasks:

1. Developing a setup that enables as high availability for the companies applications as possible.
   This is a very difficult task, and it constantly evolves, as the software used in the setup, evolves.

2. Increasing the velocity of the application teams, by assisting them with improving how their application operates in production.

Even with Kubernetes, there is a lot of work to be done, to pick the right solutions for each feature you need - and it
is our experience that 95% of what one team needs, is the EXACT same most of the other teams need.

**KubeAid** aims to be a constantly evolving solution for 1. - enabling the collaboration of operations teams across the
world, to increase the velocity of every operations team, so they can focus on 2. - while everyone gets to enjoy a
highly available and secure operations setup.

Quite often its very difficult to find enough who can to do this work, and especially since EVERY other company, is
building a replica of what you are building to solve 1. This is even WHY Kubernetes was started, to help enable
collaboration between companies on a shared goal.

**KubeAid** is being developed by [Obmondo.com](https://obmondo.com) - where we build the solutions our customers need, and
share the work with everyone, via this project. We feel this is the only way, We ever have a chance of actually
delivering the features that every operations team should have - without needing to have a subject matter expert at hand
for everything.

The fact that we help many customers operate their k8s clusters, also enables us to hire more k8s experts than is
normally available - and we can offer them a job where they get time to work on the challenges that interest them, to a
much higher degree - because we focus on one thing - furthering this project and delivering value to the customers that
sponsor it, via their subscriptions and development tasks they ask of us.

[Obmondo.com](https://obmondo.com) offers low cost subscriptions, where we monitor your clusters and handle your alerts
24/7/365 - enabling teams to not have to worry about who is on vacation, or sick - as we are there to back them up if
they need it.

## Setup of Kubernetes clusters

Mirror this repo and the [kubeaid-config](https://github.com/Obmondo/kubeaid-config) repo into a Git platform of your choice,
and follow the `README` file in the `kubeaid-config` repository on how to write the config for your Kubernetes cluster.

You must NEVER make any changes on the master/main branch of you mirror of the kubeaid repository, as we use this to
deliver updates to you. This means that your cluster can be updated simply by running `git pull` on your copy of
this repository.

All customizations happens in your `kubeaid-config` repo.

## support

Besides the community support, the primary developers of this project offers support via services on
[Obmondo.com](https://obmondo.com) - where you can opt to have us observe your world - and react to your alerts, and/or
help you with developing new features or other tasks on clusters, setup using this project.

There are ZERO vendor lockin - so any subscription you sign - can be cancelled at any time - you only pay for 1 month at
a time.

With a subscription we will be there, to ensure your smooth operations, in times of sickness and employee shortages -
and able to scale your development efforts on kubeaid if needed.

## Secrets

We use [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets/) which means secrets are encrypted locally (by
the developer who knows them) and committed to your kubeaid config repo under the path
`k8s/<cluster-name>/sealed-secrets/<namespace>/<name-of-secret>.json`. See documentation in
[./argocd-helm-charts/sealed-secrets/README.md](./argocd-helm-charts/sealed-secrets/README.md)

## License

**KubeAid** is licensed under the Affero GPLv3 license, as we believe this is the best way to protect against the patent
attacks we see hurting the industry; where companies submit code that uses technology they have patented, and then turn
and litigate companies that use the software.

The Affero GNU Public License has always been focused on ensuring everyone gets the same privileges, protecting against methods
like [TiVoization](https://en.wikipedia.org/wiki/Tivoization), which means it's very much aligned with the goals of this
project, namely to allow everyone to work on a level playing ground.

## Technical details on the features

Read here for current status on all features of kubeaid

### Setup of k8s clusters on physical servers and in cloud providers

KubeAid support both physical server (on-premise or at e.g. [Hetzner.com](https://hetzner.com)) and cloud providers like
Azure AKS, Amazon AWS or Google GCE.

We currently integrate Terraform, for setting up AKS cluster in Azure, and use kOPS for k8s in AWS and GCP

### GitOps setup and change detection

**All** changes in cluster is done via Git AND we detect if anyone adds anything in cluster or modifies existing
resources without doing it through Git.

We use ArgoCD to do this, which means we are able to alert on anything being out of sync (or unmanaged) with Git.

TODO: Implement the alerting, when Argocd detects these situations
TODO: Enable Argocd unmanaged resources detection - improve if necessary.

### Auto-scaling for all cloud k8s clusters and easy manual scale-up for physical servers

We currently have working autoscale for AWS.

TODO: Get autoscaling working for AKS and GCP.

### Manage an ever-growing list of Open Source k8s applications (see `argocd-helm-charts/` folder for a list)

We use upstream Helm charts preferrably - and use the Helm Umbrella pattern in ArgoCD - so the 'root' application,
manages the rest of the applications in a cluster.
**TODO:** Link to documentation describing the "Helm Umbrella patters"

### Build advanced, customized Prometheus monitoring, using just a per-cluster config file

We use `kube-prometheus`, and CI in repo automaticly builds a new setup for all managed k8s clusters, and submits PR to
your 'kubernetes-config' repo - when changes are made (by doing git pull on repo - so you get our latest improvements).

You can also adjust your settings for Prometheus per-cluster - in your `kubernetes-config` repo, and trigger a CI
rebuild in this repo, to get an updated build PR generated - which can then be sync'ed to production.

**TODO:** Link to documentation describing how to configure this

We currently have CI support for Gitlab and Github actions.

TODO: Implement Robusta to automate handling of trivial tasks, like increasing size of a PVC (and running disk cleanup
scripts first to try and avoid it), or scaling up instead.

### Regular application updates with security and bug fixes, ready to be issued to your cluster(s) at will

We update this repository with updated versions of the applications, and improvements - which if you have a subscription
with https://Obmondo.com you will get automaticly, or you can just git pull, to get.

Once your copy of this repo is updated, argocd will notice and register which applications have updates waiting, and you
can go view exact diff this update will cause on your cluster (app diff) or just sync it into production.

### Air-gapped operation of your clusters, to ensure operational stability

We maintain a copy of everything needed to setup your cluster (or do full recovery) in this repo, and run regular
backups of PVCs.

TODO: maintain copy of all used docker images and override images on all charts used to use that instead.

### Cluster security

Ensuring least priviledge between applications in your clusters, via resource limits and per-namespace/pod firewalling.

We use Calico and NetworkPolicy objects, to firewall each pod, so they cannot access anything in the cluster, that they
do not need to.

This protects against a pod compromise and WHEN we block traffic from a pod, it triggers an event in the namespace, so
the application developers can see what happened AND it enables us to detect Pod compromises and alert.

### Backup, recovery and live-migration of applications or entire clusters

We use Velero to do regular backups of cluster and PVC data.

On AWS we have snapshot scripts, to regular and quick PVC backups.

TODO: get live cluster migration working - hopefully calico team will soon enable multi-cluster mesh - so we can get
start writing it.

### Major cluster upgrades, via a shadow Kubernetes setup utilizing the recovery and live-migration features

TODO: get live cluster migration working - hopefully calico team will soon enable multi-cluster mesh - so we can get
start writing it.

### Supply chain attack protection and discovery - and security scans of all software used in cluster

We currently store all helm charts from upstreams in this repository, and upon updates to never versions, generate a git
diff - we review for any ODD changes. This means that we are ONLY vulnerable to supply chain attacks when downloading
chart, and we have CI comparing OUR copy of the chart in the version we run - to upstream chart repo version (download
and diff regularly) - that way we will detect if anyone has changed upstream chart code for the version we run - which
would indicate a supply chain attack on the Chart.

TODO: Add something like Threadmapper - to scan clusters for security issues
TODO: Add detection of in-use docker images in cluster and cache all in local registry
TODO: Add vulnerability scanning of docker images used

## Create a VM with gitlab server setup and running

**TODO:** Add an introduction, describing what you are going to do here

Start with initializing your terraform providers

```sh
terraform -chdir=cluster-setup-files/terraform/gitlab-ci-server init
```

```sh
terraform -chdir=<dir location of main.tf file> plan -var-file=<config file location>
```

Check if everything looks good to you, when it does you can go ahead and apply

```sh
terraform -chdir=<dir location of main.tf file> apply -var-file=<config file location> -auto-approve
```

If you are in the same dir as `main.tf` file then you don't need to pass the `chdir` flag

Look at the `variables.tf` file to see what all variables your config file must have.

### Example

Sample config file `example.tfvars`
**TODO:** Describe what the configuration keys mean

```text
gitlab_vm_name = "obmondo-gitlab"
location = "North Europe"
resource_group_name = "obmondo-aks"
create_public_ip = true
vnet_name = "obmondo-vnet"
vnet_address_space = "10.240.0.0/16"
subnet_name = "obmondo-subnet"
subnet_prefixes = "10.240.0.0/16"
vm_size = "Standard_DS2_v2"
dns_label = ""
source_addresses = ["109.238.49.194", "95.216.10.96", "109.238.49.196"]
```

To get all the available locations run

```sh
az account list-locations -o table
```

The config file is present in your respective `kubeaid-config` repo. So, you must clone and provide that file. If I am
standing in the `kubeaid` repo then my commands will be

```sh
terraform -chdir=cluster-setup-files/terraform/gitlab-ci-server plan -var-file=../kubeaid-config/vms/gitlab.tfvars
```

```sh
terraform -chdir=cluster-setup-files/terraform/gitlab-ci-server apply -var-file=../kubeaid-config/vms/gitlab.tfvars -auto-approve
```

## Create an Azure AKS (Kubernetes) cluster

```sh
terraform -chdir=cluster-setup-files/terraform/aks init
```

Sample config file
**TODO:** Describe what the configuration keys mean, or link to documentation that does

```text
cluster_name = "k8s-prod"
location = "North Europe"
agent_count = 2
dns_prefix = "k8s"
resource_group = "obmondo-aks"
vm_size = "Standard_DS2_v2"
kubernetes_version = "1.22.6"
```

Sometimes the kube version you want to install may not availabe on the location and you may get error when thats the case.
You can check which kube versions are supported in your location by running -

```sh
az aks get-versions --location $location
```

```sh
terraform -chdir=cluster-setup-files/terraform/aks plan -var-file=../kubeaid-config/k8s/kube.tfvars
```

```sh
terraform -chdir=cluster-setup-files/terraform/aks apply -var-file=../kubeaid-config/k8s/kube.tfvars -auto-approve
```

## CI build and automatic pull requests

**TODO:** Add documentation describing what is actually going on here

To automatically build kubeaid in CI and create a pull request against your own config repository additional configuration
may be required.

### Secrets Required

The `kube-prometheus` needs two secrets thats needs to be present

1. alertmanager-main - It is the secret that contains the alertmanager config file.
   An example template for the alertmanager config can be found [here](build/kube-prometheus/examples/alertmanager-config/alertmanager-main.yaml)

2. obmondo-clientcert - This secret contains the `tls.crt` which is the certificate and `tls.key` which is the private key.
   This cert and key must be generated from the puppetserver. And then copied over to the secret
   **Comment:** Which puppetserver is that, and how is that used?

### GitHub

**TODO:** Start by documenting what these pull requests are actually all about....

kubeaid implements a GitHub Action that is used to automatically create pull requests. For this to work the following
variables should be set:

- `API_TOKEN_GITHUB`: GitHub PAT with permission `repo` (Full control of private repositories).
- `OBMONDO_DEPLOY_REPO_TARGET`: Target repository short name, e.g. `awesomecorp/kubeaid-config-awesomecorp`
- `OBMONDO_DEPLOY_REPO_TARGET_BRANCH`: Branch name of kubeaid-config against which you want to build, often `main` or `master`
- `OBMONDO_DEPLOY_PULL_REQUEST_REVIEWERS` (optional): A comma-separated list of usernames of the users that are added as
  reviewers for PRs

As GitHub does not have a concept of repository access tokens like GitLab it's considered best practice to instead
create a user account specifically for this purpose. The user account should only have access to this repository and the
repository referenced in `OBMONDO_DEPLOY_REPO_TARGET`.

In order to be able to create PRs the setting *"Automatically delete head branches"* must be enabled in the target
repository. This can be done by in repository settings under the heading "Pull Requests". Having this disabled will
result in the CI job not creating new PRs as long as a branch named `obmondo-deploy` exists.

### GitLab

**TODO:** Start by documenting what these pull requests are actually all about....

kubeaid requires two CI/CD secrets to be configured in order for GitLab CI to be able to create merge requests against a
config repository:

- `KUBERNETES_CONFIG_REPO_TOKEN`: GitLab access token with permissions `api` and `read_repository`
- `KUBERNETES_CONFIG_REPO_URL`: Complete URL to target git repo, e.g.
  `https://gitlab.example.org/it/kubeaid-config-awesomecorp.git`
