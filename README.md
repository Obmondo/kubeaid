Welcome to K8id.io

K8id is a Kubernetes management suite, offering a way to setup and operate K8s clusters, following gitops and automation principles.

K8id offers:
- Setup of k8s clusters on physical servers (on-prem or @hetzner) and in cloud providers like Azure AKS, AWS or GCE 
- Autoscaling for all cloud k8s clusters and easy manual scaleup for physical servers.
- Manage an evergrowing list of Open Source k8s applications (see argocd-helm-charts/ folder for a list)
- Build advanced, customized Prometheus monitoring - using just a per-cluster config file
- regular appiication updates, with security and bugfixes - ready to be issued to your cluster(s) at your will
- Air-gapped operation of your clusters, to ensure operational stabilty
- Backup, Recovery and live-migration of applications or entire clusters
- Major cluster upgrades, via a shadow k8s setup - utilizing the recovery and live-migration features
- Supply chain attack protection and discovery

# Setup of k8s clusters

Mirror this repo and kubernetes-config repo into a GIT host of your choice, and follow the readme in kubernetes-config repo, to write the config for your k8s cluster(s).
You must NEVER alter your copy of this mirror, as we deliver updates to you - by you simply doing 'git pull' on your copy of this repo.

All customizations happens in your kubernets-config repo.

# Technical details of how this works

If you want to know HOW k8id currently does its magic - read this section

## setup of k8s clusters

We manage AWS and GCP clusters, using kOPS - which spins up ec2/gce or instances.
We manage Azure AKS, using Terraform 

# License

K8id is licensed under the GPLv3 license, as we believe this is the best way to protect against the patent attacks we see, where companies submit code that uses technology they have patented, and then turn and litigate companies that use the software. GPL has always been focused on ensuring everyone gets the same priviliges, protecting against methods like tivoization - which means its very much aligned with the goals of this project - to allow everyone to work on a level playing ground.
