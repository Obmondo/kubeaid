# Welcome to **K8id.io** — Kubernetes Aid

**K8id.io** is a Kubernetes management suite, offering a way to setup and operate K8s clusters, following gitops and
automation principles.

K8id offers:

- Setup of k8s clusters on physical servers (on-premise or at e.g. [Hetzner.com](https://hetzner.com)) and in cloud
  providers like Azure AKS, Amazon AWS or Google GCE
- Auto-scaling for all cloud k8s clusters and easy manual scale-up for physical servers
- Manage an ever-growing list of Open Source k8s applications (see `argocd-helm-charts/` folder for a list)
- Build advanced, customized Prometheus monitoring, using just a per-cluster config file
- Gitops setup - ALL changes in cluster, is done via Git AND we detect if anyone adds anything in cluster or modifies existing resources, without doing it through Git.
- Regular application updates with security and bug fixes, ready to be issued to your cluster(s) at will
- Air-gapped operation of your clusters, to ensure operational stability
- Backup, recovery and live-migration of applications or entire clusters
- Major cluster upgrades, via a shadow Kubernetes setup utilizing the recovery and live-migration features
- Supply chain attack protection and discovery - and security scans of all software used in cluster

## Setup of Kubernetes clusters

Mirror this repo and the `kubernetes-config` repo into a Git platform of your choice, and follow the `README` file in
the `kubernetes-config` repository on how to write the config for your Kubernetes cluster.

You must NEVER alter your copy of this mirror as we use this to deliver updates to you. This means that your cluster can
be updated simply by running `git pull` on your copy of this repository.

All customizations happens in your `kubernetes-config` repo.

## support

Besides the community support, the primary developers of this project offers support via services on https://obmondo.com - where you can opt to have us react to your alerts, and/or help you with developing new features or other tasks on clusters, setup using this project.

There are ZERO vendor lockin - so any subscription you sign - can be cancelled at any time - you only pay for 1 month at a time.

## License

**K8id.io** is licensed under the GPLv3 license, as we believe this is the best way to protect against the patent
attacks we see hurting the industry; where companies submit code that uses technology they have patented, and then turn
and litigate companies that use the software.

The GNU Public License has always been focused on ensuring everyone gets the same privileges, protecting against methods
like [TiVoization](https://en.wikipedia.org/wiki/Tivoization), which means it's very much aligned with the goals of this
project, namely to allow everyone to work on a level playing ground.

# Technical details on the features

Read here for current status on all features of k8id

## Setup of k8s clusters on physical servers (on-premise or at e.g. [Hetzner.com](https://hetzner.com)) and in cloud providers like Azure AKS, Amazon AWS or Google GCE

We currently integrate Terraform, for setting up AKS cluster in Azure, and use kOPS for k8s in AWS and GCP

## Gitops setup - ALL changes in cluster, is done via Git AND we detect if anyone adds anything in cluster or modifies existing resources, without doing it through Git.

We use ArgoCD to do this, which means we are able to alert on anything being out of sync (or unmanaged) with Git.

TODO: Implement the alerting, when Argocd detects these situations
TODO: Enable Argocd unmanaged resources detection - improve if necessary.

## Auto-scaling for all cloud k8s clusters and easy manual scale-up for physical servers

We currently have working autoscale for AWS.

TODO: Get autoscaling working for AKS and GCP.

## Manage an ever-growing list of Open Source k8s applications (see `argocd-helm-charts/` folder for a list)

We use upstream Helm charts preferrably - and use the Helm Umbrella pattern in ArgoCD - so the 'root' application, manages the rest of the applications in a cluster.

## Build advanced, customized Prometheus monitoring, using just a per-cluster config file

We use kube=prometheus, and CI in repo automaticly builds a new setup for all managed k8s clusters, and submits PR to your 'kubernetes-config' repo - when changes are made (by doing git pull on repo - so you get our latest improvements).

You can also adjust your settings for Prometheus per-cluster - in your kubernetes-config repo, and trigger a CI rebuild in this repo, to get an updated build PR generated - which can then be sync'ed to production.

We currently have CI support for Gitlab and Github actions.

## Regular application updates with security and bug fixes, ready to be issued to your cluster(s) at will

We update this repository with updated versions of the applications, and improvements - which if you have a subscription with https://Obmondo.com you will get automaticly, or you can just git pull, to get.

Once your copy of this repo is updated, argocd will notice and register which applications have updates waiting, and you can go view exact diff this update will cause on your cluster (app diff) or just sync it into production.

## Air-gapped operation of your clusters, to ensure operational stability

We maintain a copy of everything needed to setup your cluster (or do full recovery) in this repo, and run regular backups of PVCs.

TODO: maintain copy of all used docker images and override images on all charts used to use that instead.

## Backup, recovery and live-migration of applications or entire clusters

We use Velero to do regular backups of cluster and PVC data.

On AWS we have snapshot scripts, to regular and quick PVC backups.

TODO: get live cluster migration working - hopefully calico team will soon enable multi-cluster mesh - so we can get start writing it.

## Major cluster upgrades, via a shadow Kubernetes setup utilizing the recovery and live-migration features

TODO: get live cluster migration working - hopefully calico team will soon enable multi-cluster mesh - so we can get start writing it.

## Supply chain attack protection and discovery - and security scans of all software used in cluster

We currently store all helm charts from upstreams in this repository, and upon updates to never versions, generate a git diff - we review for any ODD changes. This means that we are ONLY vulnerable to supply chain attacks when downloading chart, and we have CI comparing OUR copy of the chart in the version we run - to upstream chart repo version (download and diff regularly) - that way we will detect if anyone has changed upstream chart code for the version we run - which would indicate a supply chain attack on the Chart.

TODO: Add something like Threadmapper - to scan clusters for security issues
TODO: Add detection of in-use docker images in cluster and cache all in local registry
TODO: Add vulnerability scanning of docker images used