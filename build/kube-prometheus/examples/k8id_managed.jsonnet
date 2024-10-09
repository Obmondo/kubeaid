{
  platform: 'kubeadm',
  extra_configs: true,
  'blackbox-exporter': false,
  connect_obmondo: true,
  grafana_keycloak_enable: true,
  grafana_root_url: 'https://grafana.kubeaid.io',
  grafana_signout_redirect_url: 'https://keycloakx.kubeaid.io/auth/realms/Obmondo/protocol/openid-connect/logout?redirect_uri=https://grafana.kbm.obmondo.com',
  grafana_auth_url: 'https://keycloakx.kubeaid.io/auth/realms/Obmondo/protocol/openid-connect/auth',
  grafana_token_url: 'https://keycloakx.kubeaid.io/auth/realms/Obmondo/protocol/openid-connect/token',
  grafana_api_url: 'https://keycloakx.kubeaid.io/auth/realms/Obmondo/protocol/openid-connect/userinfo',
  grafana_ingress_host: 'grafana.kbm.obmondo.com',
  kube_prometheus_version: 'v0.11.0',

  prometheus_operator_resources+: {
    limits: { memory: '80Mi' },
    requests: { cpu: '10m', memory: '30Mi' },
  },
  alertmanager_resources+: {
    limits: { memory: '50Mi' },
    requests: { cpu: '10m', memory: '20Mi' },
  },
  prometheus_resources+: {
    limits: { memory: '3Gi' },
    requests: { cpu: '200m', memory: '1.5Gi' },
  },
  grafana_ingress_annotations: {
    'kubernetes.io/ingress.class': 'traefik-cert-manager',
  },
}
