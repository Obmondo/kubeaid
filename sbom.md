helm chart: argo-cd

ecr-public.aws.com/docker/library/redis:7.2.8-alpine
quay.io/argoproj/argocd:v3.0.12


helm chart: argocd-image-updater

quay.io/argoprojlabs/argocd-image-updater:v0.16.0


helm chart: aws-efs-csi-driver

public.ecr.aws/efs-csi-driver/amazon/aws-efs-csi-driver:v2.1.10
public.ecr.aws/eks-distro/kubernetes-csi/external-provisioner:v5.2.0-eks-1-33-3
public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe:v2.15.0-eks-1-33-3
public.ecr.aws/eks-distro/kubernetes-csi/node-driver-registrar:v2.13.0-eks-1-33-3


helm chart: azuredisk-csi-driver

mcr.microsoft.com/oss/kubernetes-csi/azuredisk-csi:v1.33.2
mcr.microsoft.com/oss/kubernetes-csi/azuredisk-csi:v1.33.2-windows-hp
mcr.microsoft.com/oss/kubernetes-csi/csi-snapshotter:v8.3.0
mcr.microsoft.com/oss/v2/kubernetes-csi/csi-attacher:v4.8.1
mcr.microsoft.com/oss/v2/kubernetes-csi/csi-node-driver-registrar:v2.13.0
mcr.microsoft.com/oss/v2/kubernetes-csi/csi-provisioner:v5.2.0
mcr.microsoft.com/oss/v2/kubernetes-csi/csi-resizer:v1.13.2
mcr.microsoft.com/oss/v2/kubernetes-csi/livenessprobe:v2.15.0


helm chart: ccm-aws

registry.k8s.io/provider-aws/cloud-controller-manager:v1.30.0


helm chart: ccm-azure

mcr.microsoft.com/oss/kubernetes/azure-cloud-controller-manager:v1.33.2
mcr.microsoft.com/oss/kubernetes/azure-cloud-node-manager:v1.33.2


helm chart: ccm-hcloud

docker.io/hetznercloud/hcloud-cloud-controller-manager:v1.26.0


helm chart: ccm-hetzner

ghcr.io/syself/hetzner-cloud-controller-manager:v2.0.1


helm chart: cerebro

lmenezes/cerebro:0.9.4


helm chart: cert-manager

quay.io/jetstack/cert-manager-cainjector:v1.18.2
quay.io/jetstack/cert-manager-controller:v1.18.2
quay.io/jetstack/cert-manager-startupapicheck:v1.18.2
quay.io/jetstack/cert-manager-webhook:v1.18.2


helm chart: cilium

quay.io/cilium/cilium-envoy:v1.34.4-1753677767-266d5a01d1d55bd1d60148f991b98dac0390d363@sha256:231b5bd9682dfc648ae97f33dcdc5225c5a526194dda08124f5eded833bf02bf
quay.io/cilium/cilium:v1.18.0@sha256:dfea023972d06ec183cfa3c9e7809716f85daaff042e573ef366e9ec6a0c0ab2
quay.io/cilium/hubble-relay:v1.18.0@sha256:c13679f22ed250457b7f3581189d97f035608fe13c87b51f57f8a755918e793a
quay.io/cilium/hubble-ui-backend:v0.13.2@sha256:a034b7e98e6ea796ed26df8f4e71f83fc16465a19d166eff67a03b822c0bfa15
quay.io/cilium/hubble-ui:v0.13.2@sha256:9e37c1296b802830834cc87342a9182ccbb71ffebb711971e849221bd9d59392
quay.io/cilium/operator-generic:v1.18.0@sha256:398378b4507b6e9db22be2f4455d8f8e509b189470061b0f813f0fabaf944f51


helm chart: circleci-runner

circleci/runner:launch-agent


helm chart: ciso-assistant

ghcr.io/intuitem/ciso-assistant-community/backend:v2.5.4
ghcr.io/intuitem/ciso-assistant-community/frontend:v2.5.4


helm chart: cloudnative-pg

ghcr.io/cloudnative-pg/cloudnative-pg:1.26.1


helm chart: cluster-api-operator

registry.k8s.io/capi-operator/cluster-api-operator:v0.22.0


helm chart: crossplane

xpkg.crossplane.io/crossplane/crossplane:v2.0.2


helm chart: dokuwiki

docker.io/bitnami/dokuwiki:20240206.1.0-debian-12-r24


helm chart: erpnext

busybox
frappe/erpnext:v15.75.0
mariadb:11.6.2-noble
quay.io/opstree/redis-exporter:v1.44.0
quay.io/opstree/redis:v7.2.6


helm chart: errbot

docker.io/alpine:3
harbor.obmondo.com/obmondo/errbot:6.1.10


helm chart: external-dns

docker.io/bitnami/external-dns:0.18.0-debian-12-r3


helm chart: filebeat

docker.elastic.co/beats/filebeat:8.7.1


helm chart: fluent-bit

busybox:latest
cr.fluentbit.io/fluent/fluent-bit:4.0.7


helm chart: gatekeeper

curlimages/curl:8.12.0
openpolicyagent/gatekeeper-crds:v3.20.0
openpolicyagent/gatekeeper:v3.20.0


helm chart: gitea

busybox:latest
docker.gitea.com/gitea:1.24.3-rootless
docker.io/bitnami/pgpool:4.6.2-debian-12-r4
docker.io/bitnami/postgresql-repmgr:17.5.0-debian-12-r16
docker.io/bitnami/valkey-cluster:8.1.3-debian-12-r1
quay.io/opstree/redis-exporter:v1.44.0
quay.io/opstree/redis:v7.2.6


helm chart: gitea-runner

vegardit/gitea-act-runner:dind-0.2.12


helm chart: gitlab-runner

registry.gitlab.com/gitlab-org/gitlab-runner:alpine-v18.2.1


helm chart: grafana-operator

ghcr.io/grafana/grafana-operator:v5.6.0


helm chart: graylog

alpine
graylog/graylog:6.3.1


helm chart: haproxy

haproxytech/haproxy-alpine:3.1.5


helm chart: harbor

docker.io/busybox:latest
goharbor/harbor-core:v2.13.2
goharbor/harbor-jobservice:v2.13.2
goharbor/harbor-portal:v2.13.2
goharbor/harbor-registryctl:v2.13.2
goharbor/registry-photon:v2.13.2
goharbor/trivy-adapter-photon:v2.13.2
quay.io/opstree/redis-exporter:v1.48.0
quay.io/opstree/redis:v8.0.2


helm chart: hcloud-csi-driver

docker.io/hetznercloud/hcloud-csi-driver:v2.17.0
registry.k8s.io/sig-storage/csi-attacher:v4.9.0
registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.14.0
registry.k8s.io/sig-storage/csi-provisioner:v5.3.0
registry.k8s.io/sig-storage/csi-resizer:v1.14.0
registry.k8s.io/sig-storage/livenessprobe:v2.16.0


helm chart: ingress-nginx

registry.k8s.io/ingress-nginx/controller:v1.12.2@sha256:03497ee984628e95eca9b2279e3f3a3c1685dd48635479e627d219f00c8eefa9
registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.5.4@sha256:7a38cf0f8480775baaee71ab519c7465fd1dfeac66c421f28f087786e631456e


helm chart: k8s-event-logger

maxrocketinternet/k8s-event-logger:2.1


helm chart: keda

ghcr.io/kedacore/keda-admission-webhooks:2.17.2
ghcr.io/kedacore/keda-metrics-apiserver:2.17.2
ghcr.io/kedacore/keda:2.17.2


helm chart: keycloakx

docker.io/busybox:1.32
quay.io/keycloak/keycloak:25.0.5


helm chart: kube2iam

jtblin/kube2iam:0.11.1


helm chart: kubernetes-dashboard

docker.io/kubernetesui/dashboard-api:1.13.0
docker.io/kubernetesui/dashboard-auth:1.3.0
docker.io/kubernetesui/dashboard-metrics-scraper:1.2.2
docker.io/kubernetesui/dashboard-web:1.7.0
kong:3.8


helm chart: kyverno

bitnami/kubectl:1.32.3
busybox:1.35
reg.kyverno.io/kyverno/background-controller:v1.15.0
reg.kyverno.io/kyverno/cleanup-controller:v1.15.0
reg.kyverno.io/kyverno/kyverno-cli:v1.15.0
reg.kyverno.io/kyverno/kyverno:v1.15.0
reg.kyverno.io/kyverno/kyvernopre:v1.15.0
reg.kyverno.io/kyverno/reports-controller:v1.15.0


helm chart: localpv-provisioner

openebs/provisioner-localpv:4.4.0-develop


helm chart: loki-stack

docker.io/grafana/promtail:2.9.3
grafana/loki:2.6.1


helm chart: mail

boky/postfix:v1.0.0


helm chart: mariadb-operator

docker-registry3.mariadb.com/mariadb-operator/mariadb-operator:25.8.3


helm chart: matomo

docker.io/bitnami/matomo:5.1.1
mariadb:latest


helm chart: mattermost-operator

mattermost/mattermost-enterprise-edition
mattermost/mattermost-operator:v1.24.0


helm chart: mattermost-team-edition

bats/bats:v1.1.0
mattermost/mattermost-team-edition:10.10.1@sha256:714be7be92339433c4f9c5ff9de6ebe6540247c6e2154889503a734f9bc9a100


helm chart: metal3

registry.opensuse.org/isv/suse/edge/containers/images/baremetal-operator:0.9.0
registry.opensuse.org/isv/suse/edge/containers/images/ironic-ipa-downloader:3.0.7
registry.opensuse.org/isv/suse/edge/metal3/containers/images/ironic:26.1.2.4


helm chart: metrics-server

registry.k8s.io/metrics-server/metrics-server:v0.8.0


helm chart: mongodb-operator

quay.io/mongodb/mongodb-kubernetes-operator:0.13.0


helm chart: netbird

coturn/coturn:4.7.0
ghcr.io/obmondo/postgres-logical-backup:v1.0.7
mikefarah/yq:latest
netbirdio/dashboard:v2.13.1
netbirdio/management:0.46.0
netbirdio/relay:0.46.0
netbirdio/signal:0.46.0


helm chart: netbird-operator

bitnami/kubectl:latest
docker.io/netbirdio/kubernetes-operator:0.1.4


helm chart: obmondo-k8s-agent

ghcr.io/obmondo/obmondo-k8s-agent:v1.1.5


helm chart: oncall

docker.io/bats/bats:v1.4.1
docker.io/bitnami/redis:6.2.7-debian-11-r11
docker.io/grafana/grafana:11.1.4
docker.io/library/busybox:1.31.1
grafana/oncall:v1.16.4


helm chart: opencost

ghcr.io/opencost/opencost-ui:1.116.0@sha256:09253417a761ec2ee5d60d7d5db249d0be7b48506855152be5328906a45dbd33
ghcr.io/opencost/opencost:1.116.0@sha256:e4658c3be1119f2ab57c5a57c3e19b785d525de63f4cc57111d0da3e0a6654c0


helm chart: openobserve

docker.io/bitnami/etcd:3.5.8-debian-11-r4
nats:2.11.1-alpine
natsio/nats-box:0.17.0-nonroot
natsio/nats-server-config-reloader:0.17.1
openfga/openfga:latest
public.ecr.aws/docker/library/busybox:1.36.1
public.ecr.aws/zinclabs/openobserve-enterprise:v0.14.7
public.ecr.aws/zinclabs/report-server:v0.11.0-70baf7a
quay.io/minio/mc:RELEASE.2023-01-28T20-29-38Z
quay.io/minio/minio:RELEASE.2023-02-10T18-48-39Z


helm chart: opensearch

busybox:latest
opensearchproject/opensearch:3.1.0


helm chart: opensearch-dashboards

opensearchproject/opensearch-dashboards:3.1.0


helm chart: opensearch-operator

gcr.io/kubebuilder/kube-rbac-proxy:v0.15.0
opensearchproject/opensearch-operator:2.8.0


helm chart: postgres-operator

ghcr.io/zalando/postgres-operator/logical-backup:v1.13.0
ghcr.io/zalando/postgres-operator:v1.14.0
ghcr.io/zalando/spilo-17:4.0-p2
registry.opensource.zalan.do/acid/pgbouncer:master-32


helm chart: prometheus-adapter

registry.k8s.io/prometheus-adapter/prometheus-adapter:v0.12.0


helm chart: prometheus-linuxaid

grafana/grafana:11.1.4


helm chart: puppetserver

camptocamp/prometheus-puppetdb-exporter:1.1.0
curlimages/curl:8.7.1
docker.io/busybox:1.36
ghcr.io/obmondo/puppet-agent-exporter:v0.0.1
ghcr.io/voxpupuli/container-puppetdb:7.18.0-v1.5.0
ghcr.io/voxpupuli/container-puppetserver:7.17.0-v1.5.0
ghcr.io/voxpupuli/puppetboard:6.0.1
puppet/r10k:3.15.2


helm chart: rabbitmq-operator

docker.io/bitnami/rabbitmq-cluster-operator:2.16.0-debian-12-r1
docker.io/bitnami/rmq-messaging-topology-operator:1.17.3-debian-12-r1


helm chart: redis-operator

ghcr.io/ot-container-kit/redis-operator/redis-operator:v0.17.0


helm chart: reloader

ghcr.io/stakater/reloader:v1.4.6


helm chart: sealed-secrets

docker.io/bitnami/sealed-secrets-controller:0.28.0
ghcr.io/obmondo/backup-sealed-secrets-keys@sha256:7e409526cd68d09ccb7519cfbd92120e9425d6c459d11b2e6af1c20c7f177c17


helm chart: sftpgo

ghcr.io/drakkan/sftpgo:v2.6.2


helm chart: smartmon-exporter

quay.io/prometheuscommunity/smartctl-exporter:v0.14.0


helm chart: snapshot-controller

registry.k8s.io/sig-storage/snapshot-controller:v8.3.0


helm chart: step-ca

alpine/curl:latest
busybox:latest
cr.smallstep.com/smallstep/step-ca-bootstrap:latest
cr.smallstep.com/smallstep/step-ca:0.28.4
cr.step.sm/smallstep/step-issuer:0.9.9
gcr.io/kubebuilder/kube-rbac-proxy:v0.15.0
quay.io/jetstack/trust-manager:v0.19.0
quay.io/jetstack/trust-pkg-debian-bookworm:20230311-deb12u1.0


helm chart: strimzi-kafka-operator

quay.io/strimzi/operator:0.47.0


helm chart: teleport-cluster

public.ecr.aws/gravitational/teleport-distroless:18.1.4


helm chart: teleport-kube-agent

public.ecr.aws/gravitational/teleport-distroless:18.1.4


helm chart: tigera-operator

quay.io/tigera/operator:v1.38.3


helm chart: traefik-forward-auth

busybox
mesosphere/kubeaddons-addon-initializer:v0.5.1
mesosphere/traefik-forward-auth:3.1.0


helm chart: velero

docker.io/bitnami/kubectl:1.33
velero/velero:v1.16.2


helm chart: vuls-dictionary

vuls/go-cve-dictionary:v0.12.1
vuls/goval-dictionary:v0.12.0


helm chart: whoami

docker.io/traefik/whoami:v1.11.0
ghcr.io/cowboysysop/pytest:1.2.0


helm chart: yetibot

busybox
docker.io/bitnami/postgresql:15.1.0-debian-11-r12
yetibot/yetibot:20250217.155538.739211b


helm chart: zfs-localpv

openebs/zfs-driver:2.8.0
registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.13.0
registry.k8s.io/sig-storage/csi-provisioner:v5.2.0
registry.k8s.io/sig-storage/csi-resizer:v1.13.2
registry.k8s.io/sig-storage/csi-snapshotter:v8.2.0
registry.k8s.io/sig-storage/snapshot-controller:v8.2.0