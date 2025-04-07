# Changelog

All releases and the changes included in them (pulled from git commits added since last release) will be detailed in this file.

### Improvements
- [`7127e98e`](../../commit/7127e98e) Add steps to setup keycloak with azure ad
- [`50bef534`](../../commit/50bef534) KubeAid release '10.3.0'
- [`28e32acf`](../../commit/28e32acf) Add commit since 10.2.0 tag to CHANGELOG.md
- [`fc1695d7`](../../commit/fc1695d7) feat: added kubeaid-agent user for argocd, so kubeaid-agent can talk to argocd

## 10.3.0
### Minor Version Upgrades
- Updated velero from version 8.5.0 to 8.7.0
- Updated traefik from version 34.4.1 to 34.5.0
- Updated teleport-kube-agent from version 17.3.3 to 17.4.1
- Updated teleport-cluster from version 17.3.3 to 17.4.1
- Updated sonarqube from version 2025.1.1 to 2025.2.0
- Updated opentelemetry-collector from version 0.117.0 to 0.120.0
- Updated opentelemetry-operator from version 0.83.0 to 0.84.1
- Updated opencost from version 1.43.2 to 2.0.1
- Updated metal3 from version 0.9.3 to 0.10.1
- Updated mariadb-operator from version 0.37.1 to 0.38.0
- Updated gitlab-runner from version 0.74.1 to 0.75.1
- Updated cluster-api-operator from version 0.17.1 to 0.18.0

### Patch Version Upgrades
- Updated tigera-operator from version v3.29.2 to v3.29.3
- Updated snapshot-controller from version 4.0.1 to 4.0.2
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated rook-ceph from version v1.16.5 to v1.16.6
- Added openobserve-collector from version 0.3.22 to 0.3.22
- Updated openobserve from version 0.14.31 to 0.14.40
- Updated gitea from version 11.0.0 to 11.0.1
- Updated external-dns from version 8.7.7 to 8.7.8
- Updated erpnext from version 7.0.176 to 7.0.182
- Updated crossplane from version 1.19.0 to 1.19.1
- Updated cluster-autoscaler from version 9.46.3 to 9.46.6
- Updated aws-efs-csi-driver from version 3.1.7 to 3.1.8
- Updated argo-cd from version 7.8.11 to 7.8.15

### Improvements
- [`165f0ea0`](../../commit/165f0ea0) revert argocd image updater file deletion
- [`9fee0318`](../../commit/9fee0318) fix: changed it to ttyS1 for ironic agent
- [`0a2fa253`](../../commit/0a2fa253) adding metal3 helm chart

## 10.2.0
### Minor Version Upgrades
- Updated whoami from version 5.2.1 to 5.3.0
- Updated opentelemetry-operator from version 0.82.0 to 0.83.0
- Updated aws-ebs-csi-driver from version 2.40.3 to 2.41.0

### Patch Version Upgrades
- Updated sonarqube from version 2025.1.0 to 2025.1.1
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Added opentelemetry-collector from version 0.117.0 to 0.117.0
- Added openobserve-collector from version 0.3.22 to 0.3.22
- Updated mattermost-team-edition from version 6.6.71 to 6.6.73
- Updated erpnext from version 7.0.175 to 7.0.176
- Updated cluster-autoscaler from version 9.46.2 to 9.46.3
- Updated cluster-api-operator from version 0.17.0 to 0.17.1
- Updated cilium from version 1.17.1 to 1.17.2
- Updated argo-cd from version 7.8.10 to 7.8.11

### Improvements
- [`0e60e5da`](../../commit/0e60e5da) Revert "add for clause for the domain status alert"
- [`a39e6426`](../../commit/a39e6426) add for clause for the domain status alert

## 10.1.0
### Minor Version Upgrades
- Updated velero from version 8.4.0 to 8.5.0
- Updated reloader from version 1.3.0 to 2.0.0
- Updated prometheus-adapter from version 4.11.0 to 4.13.0
- Updated opentelemetry-operator from version 0.81.0 to 0.82.0
- Updated kubernetes-dashboard from version 7.10.5 to 7.11.1

### Patch Version Upgrades
- Updated traefik from version 34.4.0 to 34.4.1
- Updated teleport-kube-agent from version 17.3.0 to 17.3.3
- Updated teleport-cluster from version 17.3.0 to 17.3.3
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated rook-ceph from version v1.16.4 to v1.16.5
- Updated redmine from version 32.1.5 to 32.1.6
- Updated rabbitmq-cluster-operator from version 4.4.5 to 4.4.6
- Added opentelemetry-collector from version 0.117.0 to 0.117.0
- Added openobserve-collector from version 0.3.22 to 0.3.22
- Updated oncall from version 1.15.0 to 1.15.2
- Updated metallb from version 6.4.7 to 6.4.8
- Updated gitlab-runner from version 0.74.0 to 0.74.1
- Updated fluent-bit from version 0.48.8 to 0.48.9
- Updated external-dns from version 8.7.5 to 8.7.7
- Updated erpnext from version 7.0.171 to 7.0.175
- Updated cloudnative-pg from version 0.23.0 to 0.23.2
- Updated aws-ebs-csi-driver from version 2.40.2 to 2.40.3
- Updated argo-cd from version 7.8.7 to 7.8.10

### Improvements
- [`29ddc747`](../../commit/29ddc747) fix(capi-cluster/aws) : user must specify subnet IDs when using an existing VPC
- [`5d41a062`](../../commit/5d41a062) fix: typo bug in jsonnet, which was causing kube build to fail when generating the config file

## 10.0.1
### Improvements
- [`b17fc1c7`](../../commit/b17fc1c7) fix(kube-prometheus) : setting ruleNamespaceSelector to {} instead of null
- [`8b6e0d95`](../../commit/8b6e0d95) fix(kube-prometheus) : check whether vars.prometheus.storage.classname exists or not
- [`fc86d47e`](../../commit/fc86d47e) traefik fix

## 10.0.0
### Major Version Upgrades
- Updated gitea from version 10.6.0 to 11.0.0

### Minor Version Upgrades
- Updated teleport-kube-agent from version 17.2.8 to 17.3.0
- Updated teleport-cluster from version 17.2.8 to 17.3.0
- Updated opentelemetry-operator from version 0.80.1 to 0.81.0
- Updated opensearch-dashboards from version 2.27.1 to 2.28.0
- Updated opensearch from version 2.31.0 to 2.32.0
- Updated cluster-api-operator from version 0.16.0 to 0.17.0

### Patch Version Upgrades
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated redmine from version 32.1.4 to 32.1.5
- Added opentelemetry-collector from version 0.117.0 to 0.117.0
- Added openobserve-collector from version 0.3.22 to 0.3.22
- Updated openobserve from version 0.14.20 to 0.14.31
- Updated kubernetes-dashboard from version 7.10.4 to 7.10.5
- Updated fluent-bit from version 0.48.6 to 0.48.8
- Updated erpnext from version 7.0.168 to 7.0.171
- Updated cluster-autoscaler from version 9.46.0 to 9.46.2
- Updated aws-ebs-csi-driver from version 2.40.0 to 2.40.2
- Updated argo-cd from version 7.8.5 to 7.8.7

### Improvements
- [`d97438bd`](../../commit/d97438bd) fix(blogs/capi/aws) : fixed a command
- [`cba37bb2`](../../commit/cba37bb2) chore(docs) : updating part 1 of the KubeAid demonstration blog series for AWS

## 9.4.0
### Minor Version Upgrades
- Updated velero from version 8.3.0 to 8.4.0
- Updated traefik from version 34.3.0 to 34.4.0
- Updated reloader from version 1.2.1 to 1.3.0
- Updated opentelemetry-collector from version 0.116.0 to 0.117.0
- Updated oncall from version 1.14.4 to 1.15.0
- Updated haproxy from version 1.23.0 to 1.24.0
- Updated gitlab-runner from version 0.73.3 to 0.74.0
- Updated aws-ebs-csi-driver from version 2.39.3 to 2.40.0

### Patch Version Upgrades
- Updated yetibot from version 1.0.107 to 1.0.108
- Updated teleport-kube-agent from version 17.2.7 to 17.2.8
- Updated teleport-cluster from version 17.2.7 to 17.2.8
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated rook-ceph from version v1.16.3 to v1.16.4
- Added opentelemetry-operator from version 0.80.1 to 0.80.1
- Updated opensearch-dashboards from version 2.27.0 to 2.27.1
- Added openobserve-collector from version 0.3.22 to 0.3.22
- Updated metallb from version 6.4.6 to 6.4.7
- Updated mattermost-team-edition from version 6.6.70 to 6.6.71
- Updated external-dns from version 8.7.4 to 8.7.5
- Updated erpnext from version 7.0.166 to 7.0.168
- Updated aws-efs-csi-driver from version 3.1.6 to 3.1.7
- Updated argo-cd from version 7.8.2 to 7.8.5

### Improvements
- [`9d02ac9c`](../../commit/9d02ac9c) feat(capi-cluster/aws) : added support to specify additional users, each with corresponding SSH public key | fixed scale from 0 support and node cordoning issue
- [`87c451b1`](../../commit/87c451b1) fix(sealed-secrets) : using correct container image and service-account name
- [`69127059`](../../commit/69127059) updates from my KubeAid fork
- [`a0541c48`](../../commit/a0541c48) (fix/hetzner-failover) : Adjust envs
- [`f108bb10`](../../commit/f108bb10) (fix/capi-cluster) : default values file structure | using super-admin.conf as the kubeconfig file

## 9.3.0
### Minor Version Upgrades
- Updated opentelemetry-operator from version 0.79.0 to 0.80.1
- Updated opensearch-dashboards from version 2.26.0 to 2.27.0
- Updated opensearch from version 2.30.1 to 2.31.0
- Updated crossplane from version 1.18.2 to 1.19.0

### Patch Version Upgrades
- Updated zfs-localpv from version 2.7.0 to 2.7.1
- Updated teleport-kube-agent from version 17.2.6 to 17.2.7
- Updated teleport-cluster from version 17.2.6 to 17.2.7
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated rabbitmq-cluster-operator from version 4.4.3 to 4.4.5
- Added openobserve-collector from version 0.3.22 to 0.3.22
- Updated oncall from version 1.14.3 to 1.14.4
- Updated metallb from version 6.4.5 to 6.4.6
- Updated fluent-bit from version 0.48.5 to 0.48.6
- Updated erpnext from version 7.0.164 to 7.0.166
- Updated cilium from version 1.17.0 to 1.17.1
- Updated cert-manager from version v1.17.0 to v1.17.1
- Updated aws-efs-csi-driver from version 3.1.5 to 3.1.6

## 9.2.0
### Minor Version Upgrades
- Updated zfs-localpv from version 2.6.2 to 2.7.0
- Updated traefik from version 34.2.0 to 34.3.0
- Updated opentelemetry-collector from version 0.115.0 to 0.116.0
- Updated cilium from version 1.16.6 to 1.17.0
- Updated cert-manager from version v1.16.3 to v1.17.0
- Updated argo-cd from version 7.7.22 to 7.8.2

### Patch Version Upgrades
- Updated tigera-operator from version v3.29.1 to v3.29.2
- Updated teleport-kube-agent from version 17.2.3 to 17.2.6
- Updated teleport-cluster from version 17.2.3 to 17.2.6
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated rook-ceph from version v1.16.2 to v1.16.3
- Added openobserve-collector from version 0.3.22 to 0.3.22
- Updated openobserve from version 0.14.18 to 0.14.20
- Updated oncall from version 1.14.1 to 1.14.3
- Updated metallb from version 6.4.4 to 6.4.5
- Updated kubernetes-dashboard from version 7.10.3 to 7.10.4
- Updated keycloakx from version 7.0.0 to 7.0.1
- Updated external-dns from version 8.7.3 to 8.7.4
- Updated erpnext from version 7.0.161 to 7.0.164

### Improvements
- [`86cc10d7`](../../commit/86cc10d7) [Fix] Install promtool v2.55.0
- [`d4371a7d`](../../commit/d4371a7d) add nvme percentage used rule in smartmon
- [`d6aa5338`](../../commit/d6aa5338) fix kubeaid build script: remove unknown monitoring mixin

## 9.1.0
### Minor Version Upgrades
- Updated traefik from version 34.1.0 to 34.2.0
- Updated mariadb-operator from version 0.36.0 to 0.37.1
- Updated keycloakx from version 6.0.0 to 7.0.0
- Updated cluster-api-operator from version 0.15.1 to 0.16.0

### Patch Version Upgrades
- Updated teleport-kube-agent from version 17.2.2 to 17.2.3
- Updated teleport-cluster from version 17.2.2 to 17.2.3
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated redmine from version 32.1.2 to 32.1.4
- Updated openobserve-collector from version 0.3.21 to 0.3.22
- Updated openobserve from version 0.14.7 to 0.14.18
- Updated kubernetes-dashboard from version 7.10.1 to 7.10.3
- Updated erpnext from version 7.0.160 to 7.0.161
- Updated aws-ebs-csi-driver from version 2.39.1 to 2.39.3
- Updated argo-cd from version 7.7.17 to 7.7.22

### Improvements
- [`3f135670`](../../commit/3f135670) fix: changed the resources to have a decent load working with it
- [`fc45ac62`](../../commit/fc45ac62) Add opentelemetry collector chart
- [`91d9d45f`](../../commit/91d9d45f) feat(capi-cluster/aws) : accepting existing VPC ID from the user
- [`bb2de70e`](../../commit/bb2de70e) use postInitApplicationSQL instead of postInitSQL in puppet psql to add extensions
- [`a9ba19cd`](../../commit/a9ba19cd) add postInitSQL key in puppetserver psql to add psql extensions required for puppet 8
- [`1593d7cc`](../../commit/1593d7cc) Move opentelemetry operator outside of openobserve

## 9.0.0
### Major Version Upgrades
- Updated sonarqube from version 10.8.1 to 2025.1.0

### Minor Version Upgrades
- Updated velero from version 8.2.0 to 8.3.0
- Updated traefik from version 33.2.1 to 34.1.0
- Updated teleport-kube-agent from version 17.1.5 to 17.2.2
- Updated teleport-cluster from version 17.1.5 to 17.2.2
- Updated opentelemetry-operator from version 0.78.1 to 0.79.0
- Updated gitlab-runner from version 0.72.0 to 0.73.3
- Updated cluster-autoscaler from version 9.45.0 to 9.46.0
- Updated aws-ebs-csi-driver from version 2.38.1 to 2.39.1
- Updated argocd-image-updater from version 0.11.4 to 0.12.0

### Patch Version Upgrades
- Updated whoami from version 5.2.0 to 5.2.1
- Updated snapshot-controller from version 4.0.0 to 4.0.1
- Updated sealed-secrets from version 2.17.0 to 2.17.1
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated rook-ceph from version v1.16.1 to v1.16.2
- Updated reloader from version 1.2.0 to 1.2.1
- Updated redmine from version 32.1.1 to 32.1.2
- Updated rabbitmq-cluster-operator from version 4.4.1 to 4.4.3
- Updated opensearch from version 2.30.0 to 2.30.1
- Added openobserve from version 0.14.7 to 0.14.7
- Updated opencost from version 1.43.0 to 1.43.2
- Updated metallb from version 6.4.2 to 6.4.4
- Updated mattermost-team-edition from version 6.6.67 to 6.6.70
- Updated harbor from version 1.16.1 to 1.16.2
- Updated fluent-bit from version 0.48.4 to 0.48.5
- Updated external-dns from version 8.7.1 to 8.7.3
- Updated erpnext from version 7.0.155 to 7.0.160
- Updated cilium from version 1.16.5 to 1.16.6
- Updated cert-manager from version v1.16.2 to v1.16.3
- Updated argo-cd from version 7.7.15 to 7.7.17

### Improvements
- [`85a48265`](../../commit/85a48265) Migrating cnpg in mattermost and updating the logical backup templates.
- [`3a498a67`](../../commit/3a498a67) fix: yamllint fix
- [`54d4431e`](../../commit/54d4431e) feat: split the cronjob, so all the container does not get spawned on a single node
- [`05cb0098`](../../commit/05cb0098) feat: added pvc support
- [`09a33c39`](../../commit/09a33c39) feat: added instruction to download the dbs
- [`9ce10d93`](../../commit/9ce10d93) chore: renamed from cve-dict to vuls-dict
- [`47ab3474`](../../commit/47ab3474) fix: the appversion and correct key to lookup to find the image.tag
- [`b1088620`](../../commit/b1088620) fix: deleted unwanted files from helm chart of cve-dictionary
- [`8075b92c`](../../commit/8075b92c) feat: added vuls-cve and oval db
- [`6d899590`](../../commit/6d899590) Fix project name in jsonnet for ArgoCD kubeaid apps
- [`9d77e0f5`](../../commit/9d77e0f5) fixing probe name for puppetserver
- [`b2db6ed7`](../../commit/b2db6ed7) adding ingress template for ciso-assistant
- [`93444600`](../../commit/93444600) (fix/capi-cluster) : MachineDeployment min-size defaults to 0
- [`df9eeb99`](../../commit/df9eeb99) (feat/capi-cluster) : add ClusterRole and ClusterRoleBinding, to support ClusterAPI scale from zero feature

## 8.1.0
### Minor Version Upgrades
- Updated velero from version 8.1.0 to 8.2.0
- Updated prometheus-smartctl-exporter from version 0.11.0 to 0.13.0
- Updated postgres-operator from version 1.13.0 to 1.14.0
- Updated opensearch-dashboards from version 2.25.0 to 2.26.0
- Updated opensearch from version 2.28.0 to 2.30.0
- Updated opentelemetry-operator from version 0.75.1 to 0.78.1
- Updated opencost from version 1.42.3 to 1.43.0
- Updated oncall from version 1.13.11 to 1.14.1
- Updated keycloakx from version 4.0.0 to 6.0.0
- Updated cluster-autoscaler from version 9.43.2 to 9.45.0
- Updated cloudnative-pg from version 0.22.1 to 0.23.0

### Patch Version Upgrades
- Updated teleport-kube-agent from version 17.1.1 to 17.1.5
- Updated teleport-cluster from version 17.1.1 to 17.1.5
- Added rook-ceph-cluster from version v1.16.0 to v1.16.0
- Updated rook-ceph from version v1.16.0 to v1.16.1
- Updated openobserve-collector from version 0.3.18 to 0.3.21
- Added openobserve from version 0.14.7 to 0.14.7
- Updated kubernetes-dashboard from version 7.10.0 to 7.10.1
- Updated keda from version 2.16.0 to 2.16.1
- Updated harbor from version 1.16.0 to 1.16.1
- Updated gatekeeper from version 3.18.1 to 3.18.2
- Updated fluent-bit from version 0.48.3 to 0.48.4
- Updated erpnext from version 7.0.146 to 7.0.155
- Updated aws-efs-csi-driver from version 3.1.4 to 3.1.5
- Updated argocd-image-updater from version 0.11.3 to 0.11.4
- Updated argo-cd from version 7.7.11 to 7.7.15

### Improvements
- [`4241f405`](../../commit/4241f405) (chore/capi-cluster) : minor UX improve by modifying a Helm parameter path
- [`f665ed21`](../../commit/f665ed21) (fix/capi-cluster) : using extraArgs instead of extraEnvs to enable ETCD metrics
- [`3a7a104a`](../../commit/3a7a104a) fix: moving the opsmondo alert into respective git repo
- [`3ca6d588`](../../commit/3ca6d588) fix: watchdog alerts should come from opsmondo helm chart
- [`09df8811`](../../commit/09df8811) (traefik) : enabling ServiceMonitor
- [`bc851e4d`](../../commit/bc851e4d) (capi-cluster) : using cluster-name + control-plane as label selectors in MachineHealthcheck
- [`1f947eef`](../../commit/1f947eef) (cluster-api) : Updating cluster-api-operator subchart to v0.15.1
- [`377a47af`](../../commit/377a47af) Updating container image versions in cluster-api and capi-cluster Helm chart
- [`8d444ae6`](../../commit/8d444ae6) (capi-cluster) : syncing Chart.lock with Chart.yaml
- [`72e80d21`](../../commit/72e80d21) (capi-cluster) : AWS Infrastructure Provider component should run in a master node
- [`4c9661a0`](../../commit/4c9661a0) (capi-cluster) : Helm chart error fixes
- [`a3563a80`](../../commit/a3563a80) (capi-cluster) : Always having ETCD metrics enabled
- [`064f1c48`](../../commit/064f1c48) (feat/capi-cluster) : allowing users to pass : extraArgs and extraVolumes to KubeAPI | files to be added in master nodes
- [`f2deec6e`](../../commit/f2deec6e) Update the README for relate chart Add nginx to relate deployment templated velero schedule's includenamespaces field
- [`452c1edf`](../../commit/452c1edf) adding ciso-assistant in helm charts
- [`bbcca257`](../../commit/bbcca257) fixed all blackbox probes
- [`ffcdb71a`](../../commit/ffcdb71a) remove commit for each helm update
- [`3a5d13af`](../../commit/3a5d13af) update kafka-operator chart, add steps in doc to use go with kafka
- [`4d7095be`](../../commit/4d7095be) adding templates to setup mariadb and redis instance using corresponding operators for erpnext
- [`dfea13b8`](../../commit/dfea13b8) adding erpnext helm chart under kubeaid to enable sales support data collection
- [`dc1641de`](../../commit/dc1641de) add smartmon disk relocated sector alert, move all smartmon alert rules to one file
- [`619be769`](../../commit/619be769) bug fix: mount eyaml secret on /tmp/puppet/configmap/eyaml/keys upstream pr - https://github.com/puppetlabs/puppetserver-helm-chart/pull/239
- [`0e64d89d`](../../commit/0e64d89d) update default volume
- [`86572b42`](../../commit/86572b42) add cnpg backup and ngnix server to serve static files

## 8.0.0
### Major Version Upgrades
- Updated keycloakx from version 3.0.0 to 4.0.0
- Updated ccm-hetzner from version 1.1.15 to 2.0.1

### Minor Version Upgrades
- Updated teleport-kube-agent from version 17.0.5 to 17.1.1
- Updated teleport-cluster from version 17.0.5 to 17.1.1
- Updated strimzi-kafka-operator from version 0.44.0 to 0.45.0
- Updated rook-ceph-cluster from version v1.15.6 to v1.16.0
- Updated rook-ceph from version v1.15.6 to v1.16.0
- Updated opensearch from version 2.27.1 to 2.28.0
- Updated community-operator from version 0.11.0 to 0.12.0
- Updated gitlab-runner from version 0.71.0 to 0.72.0
- Updated cluster-api-operator from version 0.14.0 to 0.15.0

### Patch Version Upgrades
- Updated sonarqube from version 10.8.0 to 10.8.1
- Updated rabbitmq-cluster-operator from version 4.4.0 to 4.4.1
- Added openobserve from version 0.14.7 to 0.14.7
- Updated metallb from version 6.4.1 to 6.4.2
- Updated gatekeeper from version 3.18.0 to 3.18.1
- Updated external-dns from version 8.7.0 to 8.7.1
- Updated crossplane from version 1.18.1 to 1.18.2
- Updated cilium from version 1.16.4 to 1.16.5
- Updated aws-efs-csi-driver from version 3.1.2 to 3.1.4
- Updated argo-cd from version 7.7.10 to 7.7.11

### Improvements
- [`109b8841`](../../commit/109b8841) Fixing hetzner-robot Helm chart
- [`26b6539e`](../../commit/26b6539e) Adding the hetzner-robot KubeAid App
- [`8fb9ab22`](../../commit/8fb9ab22) Updated the docker rules and fixed the test case for docker container status
- [`66d3c0ad`](../../commit/66d3c0ad) update from pg operator from zalando to cncf for relate in kbm
- [`75ecc54e`](../../commit/75ecc54e) Update helm chart update script to handle individual helm update logging properly and fix name change bug

## 7.0.0

### Major Version Upgrades
- Updated snapshot-controller from version 3.0.6 to 4.0.0
- Updated keycloakx from version 2.6.0 to 3.0.0

### Minor Version Upgrades
- Updated traefik from version 33.1.0 to 33.2.1
- Updated redmine from version 32.0.1 to 32.1.1
- Updated rabbitmq-cluster-operator from version 4.3.29 to 4.4.0
- Updated metallb from version 6.3.16 to 6.4.1
- Updated gatekeeper from version 3.17.1 to 3.18.0
- Updated external-dns from version 8.6.1 to 8.7.0
- Updated aws-ebs-csi-driver from version 2.37.0 to 2.38.1
- Updated strimzi-kafka-operator from version 0.38.0 to 0.44.0

### Patch Version Upgrades
- Updated teleport-kube-agent from version 17.0.4 to 17.0.5
- Updated teleport-cluster from version 17.0.4 to 17.0.5
- Updated openobserve-collector from version 0.3.15 to 0.3.18
- Updated openobserve from version 0.14.1 to 0.14.7
- Updated oncall from version 1.13.9 to 1.13.11
- Updated mattermost-team-edition from version 6.6.66 to 6.6.67
- Updated argocd-image-updater from version 0.11.2 to 0.11.3
- Updated argo-cd from version 7.7.7 to 7.7.10
- Added opentelemetry-operator from version 0.75.1 to 0.75.1
- Added opentelemetry-operator from version 0.75.1 to 0.75.1
- Updated openobserve-collector from version 0.3.14 to 0.3.15
- Added opentelemetry-operator from version 0.75.1 to 0.75.1
- Added opentelemetry-operator from version 0.75.1 to 0.75.1
- Updated openobserve-collector from version 0.3.14 to 0.3.15

### Improvements
- [`832a1406`](../../commit/832a1406) add kafka operator chart and templates
- [`a84f8da7`](../../commit/a84f8da7) Add proxy mode to keycloak chart due to upgrade to v25
- [`14d71e97`](../../commit/14d71e97) 730 Add openserve-collector & opentelemetry-operator
- [`78691fcc`](../../commit/78691fcc) removing explicit resource namespaces and templatizing secret names
- [`2a6f45c5`](../../commit/2a6f45c5) fix: Update tar command to use updated name after renaming

## 6.3.0

### Minor Version Upgrades

- Updated traefik from version 33.0.0 to 33.1.0
- Updated sonarqube from version 10.7.0+3598 to 10.8.0
- Updated sealed-secrets from version 2.16.2 to 2.17.0
- Updated aws-efs-csi-driver from version 3.0.8 to 3.1.2

### Patch Version Upgrades

- Updated teleport-kube-agent from version 17.0.2 to 17.0.4
- Updated teleport-cluster from version 17.0.2 to 17.0.4
- Added strimzi-kafka-operator from version 0.38.0 to 0.38.0
- Updated rabbitmq-cluster-operator from version 4.3.27 to 4.3.29
- Updated openobserve-collector from version 0.3.14 to 0.3.15
- Updated openobserve-standalone from version 0.13.5 to 0.13.6
- Updated openobserve from version 0.13.5 to 0.13.8
- Updated oncall from version 1.13.3 to 1.13.9
- Updated metallb from version 6.3.15 to 6.3.16
- Updated fluent-bit from version 0.48.1 to 0.48.3
- Updated external-dns from version 8.6.0 to 8.6.1
- Updated crossplane from version 1.18.0 to 1.18.1
- Updated argo-cd from version 7.7.5 to 7.7.7

### Improvements

- [`27bc985d`](../../commit/27bc985d) fix helm repo update script failing to untar newly downloaded chart tar files when naming is different and HELM_UPSTREAM_CHART_VERSION giving unbound variable error when there is no upstream chart already present
- [`59cd0be3`](../../commit/59cd0be3) adding blackbox prober for important services
- [`f906eef5`](../../commit/f906eef5) add steps to add new alerts for servers
- [`c763329f`](../../commit/c763329f) feat: add dashboard if the upstream mixin support it
- [`05ed13ba`](../../commit/05ed13ba) Fix netpol for cert-manager to allow prometheus scrapes
- [`b3e5b381`](../../commit/b3e5b381) add zfs state degrade rule in prometheus linuxaid
- [`0ef419fe`](../../commit/0ef419fe) add mixtool lint check in ci for jsonnet files
- [`877edfda`](../../commit/877edfda) fix mixtool lint
- [`5b1c6824`](../../commit/5b1c6824) Add keycloak Upgrade guide
- [`01982f7d`](../../commit/01982f7d) Make dnszone and dns hostedzone optional for cloudflare
- [`ad626322`](../../commit/ad626322) Add recovery doc for cnpg cluster

## 6.2.0

### Minor Version Upgrades

- Updated velero from version 8.0.0 to 8.1.0

### Patch Version Upgrades

- Updated teleport-kube-agent from version 17.0.1 to 17.0.2
- Updated teleport-cluster from version 17.0.1 to 17.0.2

### Improvements

- [`fdea4476`](../../commit/fdea4476) add mixtool in kubeai ci docker image
- [`a6864eea`](../../commit/a6864eea) feat: build dashboard for all the mixins kubeaid supports
- [`a055b063`](../../commit/a055b063) chore: added mixin-utils needed for grafonnet
- [`8c2bd877`](../../commit/8c2bd877) doc: fix for adding new mixins
- [`2ff09013`](../../commit/2ff09013) chore: added opencost-mixin and mixin-utils v0.14.0 for kube-prom
- [`2d044d25`](../../commit/2d044d25) chore: updated grafananet under v0.13.0 for kube-prom
- [`472b74b4`](../../commit/472b74b4) chore: updated kube-prom libaries
- [`bbf03557`](../../commit/bbf03557) fix: changed the promtool check format in gitea workflow
- [`a8ec4018`](../../commit/a8ec4018) add ci promtool checks for kube-prometheus mixins
- [`d8d9da91`](../../commit/d8d9da91) add missing prometheus rule in mixins
- [`20e85887`](../../commit/20e85887) Fix the spelling mistake
- [`b5b34c84`](../../commit/b5b34c84) deleting main folder from build/kube-prometheus/libraries/main
- [`95313f89`](../../commit/95313f89) fix: expr for mdraid promql rule
- [`10ecae3b`](../../commit/10ecae3b) add mdraid mixin in kube prometheus
- [`3bdc0fc7`](../../commit/3bdc0fc7) add new rule monitor::raid::mdraid::failed, update epr of monitor::raid::mdraid::degraded, and add tests
- [`4f6bcb14`](../../commit/4f6bcb14) feat: mdraid monitoring
- [`ef3de665`](../../commit/ef3de665) (add) : postgresql, redis, and gitea configurations https://gitea.obmondo.com/EnableIT/opsmondo/issues/261
- [`cfa568bd`](../../commit/cfa568bd) (remove) : postgresql and redis dependencies from gitea chart https://gitea.obmondo.com/EnableIT/opsmondo/issues/261
- [`c561f701`](../../commit/c561f701) (add) : gitea chart https://gitea.obmondo.com/EnableIT/opsmondo/issues/261

## 6.1.0

### Minor Version Upgrades

- Updated reloader from version 1.1.0 to 1.2.0
- Updated oncall from version 1.12.1 to 1.13.3
- Updated keycloakx from version 2.5.1 to 2.6.0
- Updated harbor from version 1.15.1 to 1.16.0
- Updated gitlab-runner from version 0.70.3 to 0.71.0
- Updated fluent-bit from version 0.47.10 to 0.48.1

### Patch Version Upgrades

- Updated tigera-operator from version v3.29.0 to v3.29.1
- Updated rook-ceph-cluster from version v1.15.5 to v1.15.6
- Updated rook-ceph from version v1.15.5 to v1.15.6
- Updated opensearch from version 2.27.0 to 2.27.1
- Updated openobserve-standalone from version 0.13.4 to 0.13.5
- Updated openobserve from version 0.13.4 to 0.13.5
- Updated cilium from version 1.16.3 to 1.16.4
- Updated cert-manager from version v1.16.1 to v1.16.2
- Updated argo-cd from version 7.7.3 to 7.7.5

### Improvements

- [`f82edb4b`](../../commit/f82edb4b) fix: added some default resource for puppet-server/db
- [`518ab125`](../../commit/518ab125) fix: tunned puppetserver and puppetdb, so it does not eat too much of memory
- [`3f2140b7`](../../commit/3f2140b7) Add openobserve helm chart
- [`9d52c555`](../../commit/9d52c555) remove zfs exporter
- [`1316dce1`](../../commit/1316dce1) feat: added zfs pool status monitoring
- [`53dbbc78`](../../commit/53dbbc78) add smartmon_sata failure as a mixin in kube-prometheus
- [`5af854dd`](../../commit/5af854dd) add relabeling in prometheus smartctl exporter servicemonitor
- [`82041ba4`](../../commit/82041ba4) add role and rolebinding for prom to scrape it from a respective prometheus namespace
- [`d7ee3cab`](../../commit/d7ee3cab) fix: look for servicemonitor under monitoring and puppetserver for customers

## 6.0.0

### Major Version Upgrades

- Updated velero from version 7.2.2 to 8.0.0
- Updated teleport-kube-agent from version 16.4.6 to 17.0.1
- Updated teleport-cluster from version 16.4.6 to 17.0.1
- Updated redmine from version 30.0.4 to 32.0.1

### Minor Version Upgrades

- Updated whoami from version 5.1.2 to 5.2.0
- Updated external-dns from version 8.5.1 to 8.6.0
- Updated aws-ebs-csi-driver from version 2.36.0 to 2.37.0

### Patch Version Upgrades

- Updated mattermost-team-edition from version 6.6.65 to 6.6.66
- Updated argocd-image-updater from version 0.11.1 to 0.11.2
- Updated argo-cd from version 7.7.0 to 7.7.3

### Improvements

- [`ab5f35b2`](../../commit/ab5f35b2) Fixed the alert query for domains status
- [`6a27021f`](../../commit/6a27021f) bug fix: fixed the env for puppet-agent status monitoring, since default env is master
- [`f678f88f`](../../commit/f678f88f) Added the template file for domain rule
- [`ed1216e8`](../../commit/ed1216e8) Enable domain monitoring
- [`7c06efc9`](../../commit/7c06efc9) Added the alert for domain down
- [`7812104a`](../../commit/7812104a) Fixing AWS InfrastructureProvider Helm template
- [`ddeaa441`](../../commit/ddeaa441) Adding blog : Demonstrating KubeAid (part 0)
- [`4979745e`](../../commit/4979745e) Adding Terraform code for creating a VPC setup for building custom AMIs
- [`9cd9b8c3`](../../commit/9cd9b8c3) fix smartmon disk rule name
- [`6d369aff`](../../commit/6d369aff) rename smart rule to smartmon_disk_health, add doc on how to test rule locally
- [`9288b25c`](../../commit/9288b25c) add smartmon_sata rule to handle sata cable failures
- [`485280ac`](../../commit/485280ac) Fixing KubeadmConfigTemplate not rendering
- [`39e5082d`](../../commit/39e5082d) Fixing indentation for taints in KubeadmConfigTemplate in capi-cluster app
- [`48a75a78`](../../commit/48a75a78) add puppet agent exporter deployment
- [`8142b396`](../../commit/8142b396) add steps for setting up keycloak and giving super user access in matomo
- [`726a1c64`](../../commit/726a1c64) Support Cluster API - Cluster AutoScaler integration

## 5.1.0

### Minor Version Upgrades

- Updated opensearch-dashboards from version 2.24.1 to 2.25.0
- Updated opensearch from version 2.26.1 to 2.27.0
- Updated oncall from version 1.11.5 to 1.12.1
- Updated mariadb-operator from version 0.35.1 to 0.36.0
- Updated keda from version 2.15.2 to 2.16.0
- Updated external-dns from version 8.3.12 to 8.5.1
- Updated crossplane from version 1.17.2 to 1.18.0
- Updated argo-cd from version 7.6.12 to 7.7.0

### Patch Version Upgrades

- Updated sealed-secrets from version 2.16.1 to 2.16.2
- Updated rook-ceph-cluster from version v1.15.4 to v1.15.5
- Updated rook-ceph from version v1.15.4 to v1.15.5
- Updated redmine from version 30.0.2 to 30.0.4
- Updated rabbitmq-cluster-operator from version 4.3.25 to 4.3.27
- Updated opencost from version 1.42.2 to 1.42.3
- Updated metallb from version 6.3.13 to 6.3.15
- Updated cluster-autoscaler from version 9.43.1 to 9.43.2

## 5.0.0

### Major Version Upgrades

- Updated traefik from version 32.1.1 to 33.0.0

### Minor Version Upgrades

- Updated tigera-operator from version v3.28.2 to v3.29.0
- Updated kubernetes-dashboard from version 7.9.0 to 7.10.0

### Patch Version Upgrades

- Updated velero from version 7.2.1 to 7.2.2
- Updated redmine from version 30.0.0 to 30.0.2
- Updated opencost from version 1.42.0 to 1.42.2
- Updated gitlab-runner from version 0.70.2 to 0.70.3
- Updated external-dns from version 8.3.11 to 8.3.12
- Updated argocd-image-updater from version 0.11.0 to 0.11.1

### Improvements

- [`81ba9fea`](../../commit/81ba9fea) fix: cert-manager failed to get parsed, due to templating issue feat: added dnszone support
- [`a40f15a6`](../../commit/a40f15a6) Adding support for specifying root EBS volume size
- [`c9b77dd0`](../../commit/c9b77dd0) fixed the golang version in the dockerfile, after changing the base image
- [`ab50d689`](../../commit/ab50d689) updated the dockerfile to use a noble base image
- [`74a1636e`](../../commit/74a1636e) fix: the context for docker build and removed obsolete options for template workflow
- [`3c0141b3`](../../commit/3c0141b3) fix: run the ci, when the workflow file is change for container image build
- [`32ef499c`](../../commit/32ef499c) fix: the image tag for the kubeaid-ci container image
- [`146230ad`](../../commit/146230ad) removed the bin/tag-update.sh script
- [`fef4c5cb`](../../commit/fef4c5cb) feat: added a support for updating argocd template file with correct tag and added doc as well
- [`38ba0c12`](../../commit/38ba0c12) Add config repo tag updater script and install yq
- [`885d9982`](../../commit/885d9982) update add-commits script to support github commit hash link by adding relative link to commit hash
- [`86107ac2`](../../commit/86107ac2) remove : and add local commit hash linking in changelog for github
- [`7b703a29`](../../commit/7b703a29) Add comment for kubeaid managed apps from cluster specific jsonnet
- [`0405d178`](../../commit/0405d178) Remove redmine app from list of kubeaid apps in Prometheus recording rule
- [`d9e08469`](../../commit/d9e08469) Fix and rename kubeaid managed apps and recording rules for Prometheus
- [`d9153b41`](../../commit/d9153b41) Fixing link to the KubeAid Bootstrap Script container image in KubeAid demo blog (Part 1)

## 4.3.0

### Minor Version Upgrades

- Updated mariadb-operator from version 0.34.0 to 0.35.1
- Updated kubernetes-dashboard from version 7.8.0 to 7.9.0

### Patch Version Upgrades

- Updated yetibot from version 1.0.106 to 1.0.107
- Updated teleport-kube-agent from version 16.4.3 to 16.4.6
- Updated teleport-cluster from version 16.4.3 to 16.4.6
- Updated opensearch-dashboards from version 2.24.0 to 2.24.1
- Updated opensearch from version 2.26.0 to 2.26.1
- Updated oncall from version 1.11.3 to 1.11.5
- Updated mattermost-team-edition from version 6.6.64 to 6.6.65
- Updated gitlab-runner from version 0.70.1 to 0.70.2
- Updated external-dns from version 8.3.9 to 8.3.11
- Updated crossplane from version 1.17.1 to 1.17.2

### Improvements

- [`8f8b179f`](../../commit/8f8b179f) Support for changing memory requests and limits for PostgreSQL in KeycloakX Helm Chart
- [`0acaed4d`](../../commit/0acaed4d) Removed CPU limit for CNPG cluster in KeycloakX helm chart
- [`733f95dc`](../../commit/733f95dc) fixing hbk prometheus
- [`4fb88b73`](../../commit/4fb88b73) (cert-manager) : Simplifying the ClusterIssuer template | Fixes for making the wildcard certificates feature work
- [`1fca8b8c`](../../commit/1fca8b8c) Specifying AWS CLI command to create SSH KeyPair

## 4.2.0

### Minor Version Upgrades

- Updated gitlab-runner from version 0.69.0 to 0.70.1
- Updated aws-ebs-csi-driver from version 2.35.1 to 2.36.0

### Patch Version Upgrades

- Updated teleport-kube-agent from version 16.4.2 to 16.4.3
- Updated teleport-cluster from version 16.4.2 to 16.4.3
- Updated rook-ceph-cluster from version v1.15.3 to v1.15.4
- Updated rook-ceph from version v1.15.3 to v1.15.4
- Updated rabbitmq-cluster-operator from version 4.3.24 to 4.3.25
- Updated oncall from version 1.11.0 to 1.11.3
- Updated mattermost-team-edition from version 6.6.63 to 6.6.64
- Updated keda from version 2.15.1 to 2.15.2
- Updated cluster-autoscaler from version 9.43.0 to 9.43.1
- Updated cloudnative-pg from version 0.22.0 to 0.22.1
- Updated cilium from version 1.16.2 to 1.16.3
- Updated argo-cd from version 7.6.8 to 7.6.12

### Improvements

- [`2c76119b`](../../commit/2c76119b) Adding KubeAid demo blog (Part 1)

## 4.1.0

### Minor Version Upgrades

- Updated oncall from version 1.10.2 to 1.11.0
- Updated mariadb-operator from version 0.33.0 to 0.34.0
- Updated kubernetes-dashboard from version 7.7.0 to 7.8.0
- Updated cluster-api-operator from version 0.13.0 to 0.14.0

### Patch Version Upgrades

- Updated traefik from version 32.1.0 to 32.1.1
- Updated metrics-server from version 3.12.1 to 3.12.2
- Updated k8s-event-logger from version 1.1.7 to 1.1.8
- Updated cert-manager from version v1.16.0 to v1.16.1

### Improvements

- [`d289c927`](../../commit/d289c927) Making CAPI Cluster App's default values file compatible with the optional customerid feature
- [`64f72b7b`](../../commit/64f72b7b) Make customerid optional in CAPI Cluster Helm values
- [`9d18cb83`](../../commit/9d18cb83) add/renamed the references and links to kubeaid
- [`618f0bf3`](../../commit/618f0bf3) Add support for storage blob network rules
- [`261f66a1`](../../commit/261f66a1) enable azure policy

## 4.0.0

### Major Version Upgrades

- Updated redmine from version 29.0.6 to 30.0.0

### Minor Version Upgrades

- Updated traefik from version 32.0.0 to 32.1.0
- Updated sonarqube from version 10.6.1+3163 to 10.7.0+3598
- Updated opensearch-dashboards from version 2.23.0 to 2.24.0
- Updated opensearch from version 2.25.0 to 2.26.0
- Updated oncall from version 1.9.30 to 1.10.2
- Updated kubernetes-dashboard from version 7.6.1 to 7.7.0
- Updated cluster-autoscaler from version 9.41.0 to 9.43.0
- Updated cert-manager from version v1.15.3 to v1.16.0

### Patch Version Upgrades

- Updated rook-ceph-cluster from version v1.15.2 to v1.15.3
- Updated rook-ceph from version v1.15.2 to v1.15.3
- Updated rabbitmq-cluster-operator from version 4.3.23 to 4.3.24
- Updated metallb from version 6.3.12 to 6.3.13
- Updated fluent-bit from version 0.47.9 to 0.47.10
- Updated external-dns from version 8.3.8 to 8.3.9
- Updated argo-cd from version 7.6.5 to 7.6.8

### Improvements

- [`85759c07`](../../commit/85759c07) MachinePool annotation required for the AWS native autoscaler to autoscale it
- [`f43f1e77`](../../commit/f43f1e77) bootstrap crossplane
- [`84054ce6`](../../commit/84054ce6) Change deployment.revisionHistoryLimit type to int from string for Traefik KubeAid app

## 3.0.0

### Major Version Upgrades

- Updated traefik from version 31.1.1 to 32.0.0

### Minor Version Upgrades

- Updated mariadb-operator from version 0.31.0 to 0.33.0
- Updated cluster-autoscaler from version 9.37.0 to 9.41.0

### Patch Version Upgrades

- Updated zfs-localpv from version 2.6.1 to 2.6.2
- Updated teleport-kube-agent from version 16.4.0 to 16.4.2
- Updated teleport-cluster from version 16.4.0 to 16.4.2
- Updated rabbitmq-cluster-operator from version 4.3.22 to 4.3.23
- Updated oncall from version 1.9.25 to 1.9.30
- Updated k8s-event-logger from version 1.1.6 to 1.1.7
- Updated graylog from version 2.3.9 to 2.3.10
- Updated cilium from version 1.16.1 to 1.16.2
- Updated argo-cd from version 7.6.1 to 7.6.5

### Improvements

- [`c0dc582b`](../../commit/c0dc582b) Add network rules for private link access
- [`5854e551`](../../commit/5854e551) Add coredns chart for custom DNS servers (#424)
- [`20683255`](../../commit/20683255) Fix template to allow custom ingressClass for http solver in cert-manager https://gitea.obmondo.com/EnableIT/qd2xcggwag/issues/449

## 2.2.0

### Minor Version Upgrades

- Updated traefik from version 31.0.0 to 31.1.1
- Updated teleport-kube-agent from version 16.3.0 to 16.4.0
- Updated teleport-cluster from version 16.3.0 to 16.4.0
- Updated opensearch-dashboards from version 2.22.0 to 2.23.0
- Updated opensearch from version 2.24.0 to 2.25.0
- Updated haproxy from version 1.22.0 to 1.23.0
- Updated gitlab-runner from version 0.68.1 to 0.69.0
- Updated argo-cd from version 7.5.2 to 7.6.1

### Patch Version Upgrades

- Updated zfs-localpv from version 2.6.0 to 2.6.1
- Updated tigera-operator from version v3.28.1 to v3.28.2
- Updated rook-ceph-cluster from version v1.15.1 to v1.15.2
- Updated rook-ceph from version v1.15.1 to v1.15.2
- Updated redmine from version 29.0.5 to 29.0.6
- Updated metallb from version 6.3.11 to 6.3.12
- Updated crossplane from version 1.17.0 to 1.17.1
- Updated aws-ebs-csi-driver from version 2.35.0 to 2.35.1

### Improvements

- [`f7e69e6c`](../../commit/f7e69e6c) Remove CPU Limits from CrossPlane KubeAid app
- [`def0201d`](../../commit/def0201d) Support for specifying taints for a MachinePool | Adding a NOTE about MachinePool labels
- [`101fadc5`](../../commit/101fadc5) add service monitoring to errbot and update image link

## 2.1.0

### Minor Version Upgrades

- Updated teleport-kube-agent from version 16.2.1 to 16.3.0
- Updated teleport-cluster from version 16.2.1 to 16.3.0
- Updated opensearch-dashboards from version 2.21.2 to 2.22.0
- Updated opensearch from version 2.23.2 to 2.24.0
- Updated mariadb-operator from version 0.30.0 to 0.31.0
- Updated kubernetes-dashboard from version 7.5.0 to 7.6.1
- Updated aws-ebs-csi-driver from version 2.34.0 to 2.35.0

### Patch Version Upgrades

- Updated redmine from version 29.0.4 to 29.0.5
- Updated oncall from version 1.9.22 to 1.9.25
- Updated mattermost-team-edition from version 6.6.62 to 6.6.63
- Updated gatekeeper from version 3.17.0 to 3.17.1
- Updated external-dns from version 8.3.7 to 8.3.8

### Improvements

- [`976335cd`](../../commit/976335cd) (add) : kube-prometheus version 0.14.0 and add-version script
- [`a4b6de55`](../../commit/a4b6de55) Using user specified secret name instead of capi-cluster-token in AWS InfrastructureProvider
- [`9cb20e84`](../../commit/9cb20e84) Using user specified secret name instead of capi-cluster-token in AWS InfrastructureProvider
- [`75a1144a`](../../commit/75a1144a) Upgrade keycloak and remove discarded param
- [`14bad7f9`](../../commit/14bad7f9) Update graylog/upgrading.md with compatibility matrix and reference link
- [`8d6c7028`](../../commit/8d6c7028) Rename graylog6.0.5.md to upgrading.md and update instructions for Graylog and MongoDB upgrade
- [`6784ef4e`](../../commit/6784ef4e) Add readme to Upgrade Graylog and MongoDB to version 6.0.5 and 6.0.16 respectively

## 2.0.0

### Major Version Upgrades

- Updated traefik from version 30.1.0 to 31.0.0

### Minor Version Upgrades

- Updated velero from version 7.1.5 to 7.2.1
- Updated cluster-api-operator from version 0.12.0 to 0.13.0

### Patch Version Upgrades

- Updated teleport-kube-agent from version 16.2.0 to 16.2.1
- Updated teleport-cluster from version 16.2.0 to 16.2.1
- Updated snapshot-controller from version 3.0.5 to 3.0.6
- Updated rook-ceph-cluster from version v1.15.0 to v1.15.1
- Updated rook-ceph from version v1.15.0 to v1.15.1
- Updated rabbitmq-cluster-operator from version 4.3.21 to 4.3.22
- Updated opensearch-dashboards from version 2.21.1 to 2.21.2
- Updated opensearch from version 2.23.1 to 2.23.2
- Updated oncall from version 1.9.20 to 1.9.22
- Updated metallb from version 6.3.10 to 6.3.11
- Updated keycloakx from version 2.5.0 to 2.5.1
- Updated fluent-bit from version 0.47.7 to 0.47.9
- Updated external-dns from version 8.3.5 to 8.3.7

### Improvements

- [`350661b0`](../../commit/350661b0) chore: Remove Middleware and Use Ingress Route
- [`ace356f0`](../../commit/ace356f0) (fix/multiple-machinepool-support) Having multiple KubeadmConfigs - one for each MachinePool
- [`f9d42b03`](../../commit/f9d42b03) Adding AWS CCM as a KubeAid managed app | Removing AWS CCM, Hetzner CCM and Cilium HelmChartProxies | Removing Helm ClusterAPI addon | Installing Cilium and AWS CCM using postKubeadm commands
- [`729be650`](../../commit/729be650) chore: Update middleware name to puppetdb-middlewaretcp.yaml (#398)
- [`cf63dc37`](../../commit/cf63dc37) (fix) : kubeaid-config in example commands
- [`85f13bea`](../../commit/85f13bea) (fix) : kubernetes-config-enableit to kubeaid-config
- [`a07d8448`](../../commit/a07d8448) (clean + update) : remove 7e.. commit and add main vendor files
- [`b550d973`](../../commit/b550d973) (clean) : keeping the generic kubeaid-config repo name
- [`fcc52055`](../../commit/fcc52055) (add) : the latest kube-prom deps https://github.com/prometheus-operator/kube-prometheus/commit/74e445ae4a2582f978bae2e0e9b63024d7f759d6
- [`589fe91f`](../../commit/589fe91f) (docs) : addressing to comment
- [`63d71261`](../../commit/63d71261) (update) : readme with more info
- [`04557af4`](../../commit/04557af4) (docs) : default version
- [`3f35ac66`](../../commit/3f35ac66) (clean) : main stuff
- [`fc236715`](../../commit/fc236715) (fix) : build script with default commit/tag
- [`88bce270`](../../commit/88bce270) (add) : kube-prom main
- [`36529fc6`](../../commit/36529fc6) Adding support for user specified labels for a MachinePool
- [`409aa7d7`](../../commit/409aa7d7) chore: Rename middleware.yaml to puppetdb-middlewaretcp.yaml
- [`a934cf33`](../../commit/a934cf33) chore: Rename middleware.yaml to puppetdb-middlewaretcp.yaml
- [`8e027ee9`](../../commit/8e027ee9) Adding support for multiple MachinePools
- [`1a55b3ea`](../../commit/1a55b3ea) Removing CertManager, ArgoCD, SealedSecrets and AWS EBS HelmChartProxies (they'll be installed using KubeAid)
- [`84694ba7`](../../commit/84694ba7) upgrade argocd

## 1.4.0

### Minor Version Upgrades

- Updated teleport-kube-agent from version 16.1.7 to 16.2.0
- Updated teleport-cluster from version 16.1.7 to 16.2.0
- Updated reloader from version 1.0.121 to 1.1.0
- Updated mariadb-operator from version 0.29.0 to 0.30.0
- Updated crossplane from version 1.16.0 to 1.17.0
- Updated aws-ebs-csi-driver from version 2.33.0 to 2.34.0
- Updated argo-cd from version 7.4.5 to 7.5.2

### Patch Version Upgrades

- Updated whoami from version 5.1.1 to 5.1.2
- Updated rabbitmq-cluster-operator from version 4.3.19 to 4.3.21
- Updated opensearch-dashboards from version 2.21.0 to 2.21.1
- Updated opensearch from version 2.23.0 to 2.23.1
- Updated oncall from version 1.9.12 to 1.9.20
- Updated mattermost-team-edition from version 6.6.61 to 6.6.62
- Updated harbor from version 1.15.0 to 1.15.1

### Improvements

- [`a6d60f64`](../../commit/a6d60f64) Update titles in CHANGELOG, script and add patch dump codition when no helm updates are available since last update
- [`5afabefd`](../../commit/5afabefd) wiki for keycloak custom theme
- [`ed933e77`](../../commit/ed933e77) install cni and ccm as a part of post kubadm commands since its needed for the other nodes to be provisioned
- [`9d5cf60c`](../../commit/9d5cf60c) Update caph version
- [`be13744c`](../../commit/be13744c) use ubuntu 24.04
- [`ca8e8c8f`](../../commit/ca8e8c8f) :no-diff Add procedure for Traefik chart upgrade
- [`84dc17f2`](../../commit/84dc17f2) Revert "Fixed the template to read the correct value for nodes"
- [`9476b6f5`](../../commit/9476b6f5) Fixed the template to read the correct value for nodes
- [`85f033dd`](../../commit/85f033dd) Update the version of k8s and caph
- [`3c192d85`](../../commit/3c192d85) fix: bumped the prometheus version in prom-linuxaid
- [`7146d88c`](../../commit/7146d88c) Fixed lint
- [`5a1ce66e`](../../commit/5a1ce66e) fixed machineDeployment SystemManagedMachiePool
- [`ea3df458`](../../commit/ea3df458) fixed machineDeployment
- [`c492a438`](../../commit/c492a438) Added example value file
- [`81cdd6e8`](../../commit/81cdd6e8) Make default value of azure provider as false
- [`099ab8db`](../../commit/099ab8db) Added loop for machinePool
- [`a113f5cb`](../../commit/a113f5cb) Added loop for machineDeployment
- [`03274d7c`](../../commit/03274d7c) Fixing value file
- [`85326b52`](../../commit/85326b52) Updated readmefile
- [`3875c4b1`](../../commit/3875c4b1) Updated readmefile
- [`16ae93c3`](../../commit/16ae93c3) Added subchart info in chart.yaml
- [`9b9dedf2`](../../commit/9b9dedf2) Added SelfManaged azureClusterAPi
- [`6406970e`](../../commit/6406970e) fix: cert_expiry prom rule fixed in prom-linuxaid, since pushprox is depcrecated now
- [`9c22d854`](../../commit/9c22d854) Adding commented out code for Cilium NetKit support
- [`3ec5e9c3`](../../commit/3ec5e9c3) Removing unnecessary ClusterAPI HelmChartProxy
- [`31bc6afa`](../../commit/31bc6afa) Updating CertManager version and enabling CertManager CRDs to be installed - in HelmChartProxy for ClusterAPI
- [`d924b26c`](../../commit/d924b26c) Adding Cilium specific CNI ingress rules in AWSCluster for ClusterAPI
- [`a15d1f66`](../../commit/a15d1f66) Updating Cilium version to 1.16.0 in ClusterAPI HelmChartProxy

## 1.3.0

### Minor Version Upgrades

- Updated traefik from version 30.0.2 to 30.1.0
- Updated rook-ceph-cluster from version v1.14.9 to v1.15.0
- Updated rook-ceph from version v1.14.9 to v1.15.0
- Updated prometheus-adapter from version 4.10.0 to 4.11.0
- Updated postgres-operator from version 1.12.2 to 1.13.0
- Updated opensearch-dashboards from version 2.20.0 to 2.21.0
- Updated opensearch from version 2.22.0 to 2.23.0
- Updated opencost from version 1.41.0 to 1.42.0
- Updated oncall from version 1.8.9 to 1.9.12
- Updated keycloakx from version 2.4.4 to 2.5.0
- Updated gitlab-runner from version 0.67.1 to 0.68.1
- Updated gatekeeper from version 3.16.3 to 3.17.0
- Updated cloudnative-pg from version 0.21.6 to 0.22.0
- Updated cerebro from version 2.0.5 to 2.1.0

### Patch Version Upgrades

- Updated velero from version 7.1.4 to 7.1.5
- Updated teleport-kube-agent from version 16.1.4 to 16.1.7
- Updated teleport-cluster from version 16.1.4 to 16.1.7
- Updated redmine from version 29.0.3 to 29.0.4
- Updated rabbitmq-cluster-operator from version 4.3.18 to 4.3.19
- Updated mattermost-team-edition from version 6.6.60 to 6.6.61
- Updated keda from version 2.15.0 to 2.15.1
- Updated graylog from version 2.3.8 to 2.3.9
- Updated fluent-bit from version 0.47.5 to 0.47.7
- Updated external-dns from version 8.3.4 to 8.3.5
- Updated cilium from version 1.16.0 to 1.16.1
- Updated cert-manager from version v1.15.2 to v1.15.3
- Updated argo-cd from version 7.4.2 to 7.4.5

### Improvements

- [`f931fffe`](../../commit/f931fffe) updated the prometheus metrics alert to handle boot time as well
- [`44a0e0ec`](../../commit/44a0e0ec) Add add-commit bash script and call it in helm-repo-update script and update CHANGELOG with commits as per new standard
- [`a3293137`](../../commit/a3293137) refactor: Update TCP ingress route for puppetdb to use new domain name
- [`e40cfb96`](../../commit/e40cfb96) fixed the alert expression for node which are not sending metrics within the timefram
- [`a74fb76d`](../../commit/a74fb76d) feat: Add TCP ingress route for puppetdb
- [`5be86fec`](../../commit/5be86fec) refactor: Update IP allowlist in puppetserver middleware.yaml
- [`6ad2a8ae`](../../commit/6ad2a8ae) feat: Add middleware for IP allowlist in puppetserver ingress route
- [`d706ddce`](../../commit/d706ddce) fixed the watchdog alert to alert if alertmanager are not sending the watchdog alert within a time-frame
- [`2780a6f2`](../../commit/2780a6f2) fix: job name of opsmondo
- [`1c8c9ab0`](../../commit/1c8c9ab0) [FEAT] add default value for networkpolicies
- [`0baf17c1`](../../commit/0baf17c1) change matomo version to 5.1.1
- [`cb080daf`](../../commit/cb080daf) wildcard certificates should be set to disabled as a default
- [`35adfd74`](../../commit/35adfd74) need kind in ingressroute object
- [`4019afc4`](../../commit/4019afc4) removed middleware from ingressroute, it was never working, and its moved to client cert auth
- [`dcf43853`](../../commit/dcf43853) upgrade prom/alertmanager and grafana version in prom-linuxaid helm chart
- [`e6c69984`](../../commit/e6c69984) [FEAT] add netpol template to fluentbit
- [`730161c0`](../../commit/730161c0) changed the alert expr for arogcd-app which are unhealthy and outofsync
- [`f1e1a7d6`](../../commit/f1e1a7d6) removed .gitignore from the kubeaid list and fixed metadata.name for promrule and added a default project
- [`2973d15b`](../../commit/2973d15b) added support for monitoring oosync apps of argocd, for now only kubeaid apps
- [`16945fb8`](../../commit/16945fb8) removed puppetserver image and tag and let it come from upstream default values file
- [`0f3414e4`](../../commit/0f3414e4) removed mastersfor ingressroute for puppetserver, since we cant generate new CA cert, if new customer/users comes up. otherwise we will have re-gen all the cert of the puppet agent, which is not feasible
- [`70d0b5c3`](../../commit/70d0b5c3) fixed puppetserver values file to be more generic
- [`70c04e7c`](../../commit/70c04e7c) changed the cron time for puppet git pull
- [`dd69e2ca`](../../commit/dd69e2ca) Installing tzinfo-data to puppet server
- [`cc87bbec`](../../commit/cc87bbec) fixed the puppetserver helm chart bug when mounting eyaml
- [`3711dd68`](../../commit/3711dd68) added an empty value for ingressrotue for puppetserver
- [`468c7076`](../../commit/468c7076) fix: handle puppet agent for user which has few puppet agent
- [`2b6dee6d`](../../commit/2b6dee6d) removed prometheus report setting, since its not setup entirely
- [`c6a9b090`](../../commit/c6a9b090) added a custom gem to be installed, need by one of the puppet function on linuxaid
- [`0207de09`](../../commit/0207de09) added node_terminus setting in puppet server section
- [`43ef8c98`](../../commit/43ef8c98) fixed the customentrypoints bug in values file for puppetserver
- [`3a1d5010`](../../commit/3a1d5010) added enc support and updated readme as well
- [`7f02e48e`](../../commit/7f02e48e) removed options from ingressroutetcp as its not wanted
- [`fda279cd`](../../commit/fda279cd) fixed the autosign path for puppetserver
- [`8ed24a46`](../../commit/8ed24a46) added autosign script puppetserver
- [`3d92261b`](../../commit/3d92261b) migrated the ingressroute to ingressroutetcp and removed options as per the tcp spec
- [`af1ff6c7`](../../commit/af1ff6c7) changed the object name from ingressroute to ingressroutetcp
- [`16a606ea`](../../commit/16a606ea) added passthrough and remove certresolver, since we dont need it
- [`fde8302d`](../../commit/fde8302d) added ingressroute and disabled ingress
- [`7d742f78`](../../commit/7d742f78) Fix providers and upgrad vpc module
- [`76b51ba3`](../../commit/76b51ba3) update helm-repo-update script with logging in changelog, auto tag bumping according to helm charts being updated and update commit structure
- [`0edee695`](../../commit/0edee695) doc: updated readme and an example netrc file
- [`f8f23501`](../../commit/f8f23501) lets not run r10k as sidecar, to avoid multiple container for it and fixed the r10k spec issue, entered in the wrong place
- [`967e92d8`](../../commit/967e92d8) added puppeturl and secret to access the puppet git repo
- [`a0bf9874`](../../commit/a0bf9874) wip
- [`a553cce0`](../../commit/a553cce0) fixed the ingress alignment
- [`2e5db425`](../../commit/2e5db425) fix: fixed the env and secret name as per new object name for puppetserver
- [`86a3774a`](../../commit/86a3774a) fix: added namespace support to postgresql puppetserver
- [`334bfb84`](../../commit/334bfb84) fixes:

## 1.2.0

### Minor Version Upgrades

- Updated opensearch-dashboards from version 2.19.1 to 2.20.0
- Updated opensearch from version 2.21.0 to 2.22.0
- Updated community-operator from version 0.10.0 to 0.11.0

### Patch Version Upgrades

- Updated teleport-kube-agent from version 16.1.3 to 16.1.4
- Updated teleport-cluster from version 16.1.3 to 16.1.4
- Updated rabbitmq-cluster-operator from version 4.3.17 to 4.3.18
- Updated metallb from version 6.3.9 to 6.3.10
- Updated aws-efs-csi-driver from version 3.0.7 to 3.0.8
- Updated argo-cd from version 7.4.1 to 7.4.2

### Improvements

- [`ca279e10`](../../commit/ca279e10) Update changelog format
- [`a553cce0`](../../commit/a553cce0) fixed the ingress alignment
- [`c78a3a5b`](../../commit/c78a3a5b) small spelling fix and add log delition and garbage collection history
- [`52b24a6d`](../../commit/52b24a6d) harbor clean up doc
- [`ca004f96`](../../commit/ca004f96) Fixed cilium template condition
- [`044ed1b6`](../../commit/044ed1b6) Added a readme file for azure cluster api
- [`2e5db425`](../../commit/2e5db425) fix: fixed the env and secret name as per new object name for puppetserver
- [`86a3774a`](../../commit/86a3774a) fix: added namespace support to postgresql puppetserver
- [`334bfb84`](../../commit/334bfb84) fixes:
- [`62e841a7`](../../commit/62e841a7) Added a helm chart for azure cluster api
- [`98f94caa`](../../commit/98f94caa) Fixed Yaml linting
- [`d6f40a65`](../../commit/d6f40a65) Added capz version
- [`edf3a588`](../../commit/edf3a588) Added Azure capz helm chart
- [`5c93bc15`](../../commit/5c93bc15) setup matomo in k8s

## 1.1.0

### Minor Version Upgrades

- Updated keda from version 2.14.2 to 2.15.0
- Updated cluster-api-operator from version 0.11.0 to 0.12.0
- Updated argo-cd from version 7.3.11 to 7.4.1

### Patch Version Upgrades

- Updated teleport-kube-agent from version 16.1.0 to 16.1.3
- Updated teleport-cluster from version 16.1.0 to 16.1.3
- Updated reloader from version 1.0.119 to 1.0.121
- Updated rabbitmq-cluster-operator from version 4.3.16 to 4.3.17
- Updated oncall from version 1.8.8 to 1.8.9
- Updated keycloakx from version 2.4.3 to 2.4.4
- Updated external-dns from version 8.3.3 to 8.3.4
- Updated dokuwiki from version 16.2.10 to 16.2.11

## 1.0.0

### Major Version Upgrades

- Updated matomo from version 7.3.7 to 8.0.5
- Updated redmine from version 28.2.7 to 29.0.3
- Updated traefik from version 29.0.0 to 30.0.2

### Minor Version Upgrades

- Updated aws-ebs-csi-driver from version 2.32.0 to 2.33.0
- Updated cilium from version 1.15.6 to 1.16.0
- Updated external-dns from version 8.1.0 to 8.3.3
- Updated fluent-bit from version 0.46.11 to 0.47.5
- Updated gitlab-runner from version 0.66.0 to 0.67.1
- Updated opencost from version 1.40.0 to 1.41.0

### Patch Version Upgrades

- Updated argo-cd from version 7.3.4 to 7.3.11
- Updated aws-efs-csi-driver from version 3.0.6 to 3.0.7
- Updated cert-manager from version v1.15.1 to v1.15.2
- Updated cloudnative-pg from version 0.21.5 to 0.21.6
- Updated dokuwiki from version 16.2.6 to 16.2.10
- Updated mattermost-team-edition from version 6.6.58 to 6.6.60
- Updated metallb from version 6.3.7 to 6.3.9
- Updated oncall from version 1.8.1 to 1.8.8
- Updated opensearch-dashboards from version 2.19.0 to 2.19.1
- Updated rabbitmq-cluster-operator from version 4.3.13 to 4.3.16
- Updated reloader from version 1.0.116 to 1.0.119
- Updated rook-ceph from version v1.14.8 to v1.14.9
- Updated rook-ceph-cluster from version v1.14.4 to v1.14.9
- Updated sealed-secrets from version 2.16.0 to 2.16.1
- Updated sonarqube from version 10.6.0+3033 to 10.6.1+3163
- Updated tigera-operator from version v3.28.0 to v3.28.1
- Updated velero from version 7.1.0 to 7.1.4
