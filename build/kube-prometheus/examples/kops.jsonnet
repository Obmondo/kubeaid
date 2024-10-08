{
  // which platform kubernetes runs on
  platform: 'kops',
  extra_configs: true,
  'blackbox-exporter': false,
  // If you want kubeaid Supprt, set it to true
  connect_obmondo: true,
  prometheus_operator_resources+: {
    limits: { memory: '200Mi' },
    requests: { cpu: '150m', memory: '200Mi' },
  },
  alertmanager_resources+: {
    limits: { memory: '50Mi' },
    requests: { cpu: '100m', memory: '50Mi' },
  },
  prometheus_resources+: {
    limits: { memory: '2Gi' },
    requests: { cpu: '500m', memory: '2Gi' },
  },
  node_exporter_resources: {
    limits: { memory: '180Mi' },
    requests: { cpu: '200m', memory: '180Mi' },
  },

  addMixins+: {
    ceph: false,
    velero: true,
  },
  grafana_keycloak_enable: true,
  grafana_root_url: 'https://grafana.kubeaid.io',
  grafana_signout_redirect_url: 'https://keycloak.kubeaid.io/auth/realms/master/protocol/openid-connect/logout?redirect_uri=https://grafana.kubeaid.io',
  grafana_auth_url: 'https://keycloak.kubeaid.io/auth/realms/master/protocol/openid-connect/auth',
  grafana_token_url: 'https://keycloak.kubeaid.io/auth/realms/master/protocol/openid-connect/token',
  grafana_api_url: 'https://keycloak.kubeaid.io/auth/realms/master/protocol/openid-connect/userinfo',
  grafana_ingress_host: 'grafana.kubeaid.io',
  kube_prometheus_version: 'v0.11.0',
  prometheus+: {
    storage: {
      size: '10Gi',
      classname: 'gp2',
    },
    retention: '30d',
  },
  prometheus_scrape_namespaces: [
    'velero',
    'aws',
  ],
}
