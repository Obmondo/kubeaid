{
  platform: 'kubeadm',
  extra_configs: true,
  'blackbox-exporter': true,

  grafana_keycloak_enable: false,
  grafana_root_url: 'https://grafana.kam.obmondo.com',
  grafana_signout_redirect_url: 'https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/logout?redirect_uri=https://grafana.kam.obmondo.com',
  grafana_auth_url: 'https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/auth',
  grafana_token_url: 'https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/token',
  grafana_api_url: 'https://keycloak.kam.obmondo.com/auth/realms/devops/protocol/openid-connect/userinfo',
  grafana_ingress_host: 'grafana.kam.obmondo.com',
  kube_prometheus_version: 'release-0.10',

  prometheus_operator_resources: {
    limits: { cpu: '100m', memory: '80Mi' },
    requests: { cpu: '10m', memory: '30Mi' },
  },
  alertmanager_resources: {
    limits: { cpu: '100m', memory: '50Mi' },
    requests: { cpu: '10m', memory: '20Mi' },
  },
  prometheus_resources: {
    limits: { memory: '4Gi' },
    requests: { cpu: '800m', memory: '200Mi' },
  },
  alertmanager_cert: false,
}
