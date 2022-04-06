# Welcome to **K8id.io** — Kubernetes Aid

**K8id.io** is a Kubernetes management suite, offering a way to setup and operate K8s clusters, following gitops and
automation principles.

K8id offers:

- Setup of k8s clusters on physical servers (on-premise or at e.g. [Hetzner.com](https://hetzner.com)) and in cloud
  providers like Azure AKS, Amazon AWS or Google GCE
- Auto-scaling for all cloud k8s clusters and easy manual scale-up for physical servers
- Manage an ever-growing list of Open Source k8s applications (see `argocd-helm-charts/` folder for a list)
- Build advanced, customized Prometheus monitoring, using just a per-cluster config file
- Regular application updates with security and bug fixes, ready to be issued to your cluster(s) at will
- Air-gapped operation of your clusters, to ensure operational stability
- Backup, recovery and live-migration of applications or entire clusters
- Major cluster upgrades, via a shadow Kubernetes setup utilizing the recovery and live-migration features
- Supply chain attack protection and discovery

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
