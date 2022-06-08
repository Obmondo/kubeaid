apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: {{.cluster_name.value}}
spec:
  api:
    loadBalancer:
      class: Classic
      idleTimeoutSeconds: 4000
      type: Internal
      crossZoneLoadBalancing: true
      additionalSecurityGroups: ["{{.k8s_api_http_security_group_id.value}}"]
  authorization:
    rbac: {}
  channel: stable
  cloudProvider: aws
  configBase: s3://{{.kops_s3_bucket_name.value}}/{{.cluster_name.value}}
  cloudConfig:
    awsEBSCSIDriver:
      enabled: false
  # Create one etcd member per AZ
  etcdClusters:
  - cpuRequest: 200m
    etcdMembers:
    {{range $i, $az := .availability_zones.value}}
      - instanceGroup: master-{{.}}
        encryptedVolume: true
        name: {{. | replace $.region.value "" }}
    {{end}}
    memoryRequest: 100Mi
    name: main
  - cpuRequest: 100m
    etcdMembers:
    {{range $i, $az := .availability_zones.value}}
      - instanceGroup: master-{{.}}
        name: {{. | replace $.region.value "" }}
    {{end}}
    memoryRequest: 100Mi
    name: events
  hooks:
  - manifest: |
      [unit]
      Description=unattended-upgrades on boot
      Before=docker.service kubelet.service
      After=network-online.target
      Wants=network-online.target
      [Service]
      Type=oneshot
      ExecStart=/usr/bin/unattended-upgrades
      RemainAfterExit=true
      StandardOutput=journal
      [Install]
      WantedBy=multi-user.target
    name: boot-upgrade.service
    roles:
    - Node
    - Master
  useRawManifest: true
  iam:
    allowContainerRegistry: true
    legacy: false
  kubernetesVersion: {{.kubernetes_version.value}}
  masterPublicName: api.{{.cluster_name.value}}
  masterInternalName: api.internal.{{.cluster_name.value}}
  networkCIDR: {{.vpc_cidr_block.value}}
  kubeControllerManager:
    logLevel: 3
  kubeProxy:
    metricsBindAddress: 0.0.0.0
    proxyMode: ipvs
  networkID: {{.vpc_id.value}}
  kubelet:
    anonymousAuth: false
  kubernetesApiAccess:
  - 0.0.0.0/0
  networking:
    calico: {}
  nonMasqueradeCIDR: 100.64.0.0/10
  sshAccess:
  - 0.0.0.0/0
  subnets:
  # Public (utility) subnets, one per AZ
  {{range $i, $id := .public_subnet_ids.value}}
  - id: {{.}}
    name: utility-{{index $.availability_zones.value $i}}
    type: Utility
    zone: {{index $.availability_zones.value $i}}
  {{end}}
  # Private subnets, one per AZ
  {{range $i, $id := .private_subnet_ids.value}}
  - id: {{.}}
    name: {{index $.availability_zones.value $i}}
    type: Private
    zone: {{index $.availability_zones.value $i}}
    egress: {{index $.nat_gateway_ids.value 0}}
  {{end}}
  topology:
    bastion:
      bastionPublicName: bastion.{{.cluster_name.value}}
    dns:
      type: Public
    masters: private
    nodes: private
