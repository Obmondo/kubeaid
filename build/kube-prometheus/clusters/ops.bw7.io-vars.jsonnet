{
  platform: 'aws',
  extra_configs: false,
  alertmanager_extra_spec: true,
  'blackbox-exporter': false,

  prometheus_operator_resources: {
    limits: { cpu: '100m', memory: '80Mi' },
    requests: { cpu: '10m', memory: '30Mi' },
  },
  alertmanager_resources: {
    limits: { cpu: '100m', memory: '50Mi' },
    requests: { cpu: '10m', memory: '20Mi' },
  },
  prometheus_resources: {
    limits: { memory: '1Gi' },
    requests: { cpu: '100m', memory: '200Mi' },
  },

}
