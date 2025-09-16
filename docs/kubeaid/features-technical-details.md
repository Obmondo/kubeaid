# Technical details on the features

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