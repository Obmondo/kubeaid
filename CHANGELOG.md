# Changelog
All releases and the changes included in them (pulled from git commits added since last release) will be detailed in this file.

## 2024-08-23
### Major Changes %%^^

### Minor Changes %%^^
- Updated gitlab-runner from version 0.67.1 to 0.68.1
- Updated gatekeeper from version 3.16.3 to 3.17.0
- Updated cloudnative-pg from version 0.21.6 to 0.22.0
- Updated cerebro from version 2.0.5 to 2.1.0

### Patch Changes %%^^
- Updated keda from version 2.15.0 to 2.15.1
- Updated graylog from version 2.3.8 to 2.3.9
- Updated fluent-bit from version 0.47.5 to 0.47.7
- Updated external-dns from version 8.3.4 to 8.3.5
- Updated cilium from version 1.16.0 to 1.16.1
- Updated cert-manager from version v1.15.2 to v1.15.3
- Updated argo-cd from version 7.4.2 to 7.4.5

### KubeAid Improvements
- f931fffe updated the prometheus metrics alert to handle boot time as well
- 44a0e0ec Add add-commit bash script and call it in helm-repo-update script and update CHANGELOG with commits as per new standard
- a3293137 refactor: Update TCP ingress route for puppetdb to use new domain name
- e40cfb96 fixed the alert expression for node which are not sending metrics within the timefram
- a74fb76d feat: Add TCP ingress route for puppetdb
- 5be86fec refactor: Update IP allowlist in puppetserver middleware.yaml
- 6ad2a8ae feat: Add middleware for IP allowlist in puppetserver ingress route
- d706ddce fixed the watchdog alert to alert if alertmanager are not sending the watchdog alert within a time-frame
- 2780a6f2 fix: job name of opsmondo
- 1c8c9ab0 [FEAT] add default value for networkpolicies
- 0baf17c1 change matomo version to 5.1.1
- cb080daf wildcard certificates should be set to disabled as a default
- 35adfd74 need kind in ingressroute object
- 4019afc4 removed middleware from ingressroute, it was never working, and its moved to client cert auth
- dcf43853 upgrade prom/alertmanager and grafana version in prom-linuxaid helm chart
- e6c69984 [FEAT] add netpol template to fluentbit
- 730161c0 changed the alert expr for arogcd-app which are unhealthy and outofsync
- f1e1a7d6 removed .gitignore from the kubeaid list and fixed metadata.name for promrule and added a default project
- 2973d15b added support for monitoring oosync apps of argocd, for now only kubeaid apps
- 16945fb8 removed puppetserver image and tag and let it come from upstream default values file
- 0f3414e4 removed mastersfor ingressroute for puppetserver, since we cant generate new CA cert, if new customer/users comes up. otherwise we will have re-gen all the cert of the puppet agent, which is not feasible
- 70d0b5c3 fixed puppetserver values file to be more generic
- 70c04e7c changed the cron time for puppet git pull
- dd69e2ca Installing tzinfo-data to puppet server
- cc87bbec fixed the puppetserver helm chart bug when mounting eyaml
- 3711dd68 added an empty value for ingressrotue for puppetserver
- 468c7076 fix: handle puppet agent for user which has few puppet agent
- 2b6dee6d removed prometheus report setting, since its not setup entirely
- c6a9b090 added a custom gem to be installed, need by one of the puppet function on linuxaid
- 0207de09 added node_terminus setting in puppet server section
- 43ef8c98 fixed the customentrypoints bug in values file for puppetserver
- 3a1d5010 added enc support and updated readme as well
- 7f02e48e removed options from ingressroutetcp as its not wanted
- fda279cd fixed the autosign path for puppetserver
- 8ed24a46 added autosign script puppetserver
- 3d92261b migrated the ingressroute to ingressroutetcp and removed options as per the tcp spec
- af1ff6c7 changed the object name from ingressroute to ingressroutetcp
- 16a606ea added passthrough and remove certresolver, since we dont need it
- fde8302d added ingressroute and disabled ingress
- 7d742f78 Fix providers and upgrad vpc module
- 76b51ba3 update helm-repo-update script with logging in changelog, auto tag bumping according to helm charts being updated and update commit structure
- 0edee695 doc: updated readme and an example netrc file
- f8f23501 lets not run r10k as sidecar, to avoid multiple container for it and fixed the r10k spec issue, entered in the wrong place
- 967e92d8 added puppeturl and secret to access the puppet git repo
- a0bf9874 wip
- a553cce0 fixed the ingress alignment
- 2e5db425 fix: fixed the env and secret name as per new object name for puppetserver
- 86a3774a fix: added namespace support to postgresql puppetserver
- 334bfb84 fixes:

## 1.2.0
### Minor Changes
- Updated opensearch-dashboards from version 2.19.1 to 2.20.0
- Updated opensearch from version 2.21.0 to 2.22.0
- Updated community-operator from version 0.10.0 to 0.11.0

### Patch Changes
- Updated teleport-kube-agent from version 16.1.3 to 16.1.4
- Updated teleport-cluster from version 16.1.3 to 16.1.4
- Updated rabbitmq-cluster-operator from version 4.3.17 to 4.3.18
- Updated metallb from version 6.3.9 to 6.3.10
- Updated aws-efs-csi-driver from version 3.0.7 to 3.0.8
- Updated argo-cd from version 7.4.1 to 7.4.2

### KubeAid Improvements
- ca279e10 Update changelog format
- a553cce0 fixed the ingress alignment
- c78a3a5b small spelling fix and add log delition and garbage collection history
- 52b24a6d harbor clean up doc
- ca004f96 Fixed cilium template condition
- 044ed1b6 Added a readme file for azure cluster api
- 2e5db425 fix: fixed the env and secret name as per new object name for puppetserver
- 86a3774a fix: added namespace support to postgresql puppetserver
- 334bfb84 fixes:
- 62e841a7 Added a helm chart for azure cluster api
- 98f94caa Fixed Yaml linting
- d6f40a65 Added capz version
- edf3a588 Added Azure capz helm chart
- 5c93bc15 setup matomo in k8s

## 1.1.0
### Minor Changes
- Updated keda from version 2.14.2 to 2.15.0
- Updated cluster-api-operator from version 0.11.0 to 0.12.0
- Updated argo-cd from version 7.3.11 to 7.4.1

### Patch Changes
- Updated teleport-kube-agent from version 16.1.0 to 16.1.3
- Updated teleport-cluster from version 16.1.0 to 16.1.3
- Updated reloader from version 1.0.119 to 1.0.121
- Updated rabbitmq-cluster-operator from version 4.3.16 to 4.3.17
- Updated oncall from version 1.8.8 to 1.8.9
- Updated keycloakx from version 2.4.3 to 2.4.4
- Updated external-dns from version 8.3.3 to 8.3.4
- Updated dokuwiki from version 16.2.10 to 16.2.11

## 1.0.0
### Major Changes
- Updated: matomo from version 7.3.7 to 8.0.5
- Updated: redmine from version 28.2.7 to 29.0.3
- Updated: traefik from version 29.0.0 to 30.0.2

### Minor Changes
- Updated: aws-ebs-csi-driver from version 2.32.0 to 2.33.0
- Updated: cilium from version 1.15.6 to 1.16.0
- Updated: external-dns from version 8.1.0 to 8.3.3
- Updated: fluent-bit from version 0.46.11 to 0.47.5
- Updated: gitlab-runner from version 0.66.0 to 0.67.1
- Updated: opencost from version 1.40.0 to 1.41.0

### Patch Changes
- Updated: argo-cd from version 7.3.4 to 7.3.11
- Updated: aws-efs-csi-driver from version 3.0.6 to 3.0.7
- Updated: cert-manager from version v1.15.1 to v1.15.2
- Updated: cloudnative-pg from version 0.21.5 to 0.21.6
- Updated: dokuwiki from version 16.2.6 to 16.2.10
- Updated: mattermost-team-edition from version 6.6.58 to 6.6.60
- Updated: metallb from version 6.3.7 to 6.3.9
- Updated: oncall from version 1.8.1 to 1.8.8
- Updated: opensearch-dashboards from version 2.19.0 to 2.19.1
- Updated: rabbitmq-cluster-operator from version 4.3.13 to 4.3.16
- Updated: reloader from version 1.0.116 to 1.0.119
- Updated: rook-ceph from version v1.14.8 to v1.14.9
- Updated: rook-ceph-cluster from version v1.14.4 to v1.14.9
- Updated: sealed-secrets from version 2.16.0 to 2.16.1
- Updated: sonarqube from version 10.6.0+3033 to 10.6.1+3163
- Updated: tigera-operator from version v3.28.0 to v3.28.1
- Updated: velero from version 7.1.0 to 7.1.4
