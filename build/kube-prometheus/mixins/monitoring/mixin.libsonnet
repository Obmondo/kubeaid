{
  _config+:: {
    selector: '',
  },
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'monitoring',
        rules: [
          {
            alert: 'monitor::monitoring_stack::watchdog_missing',
            expr: 'increase(watchdog_alerts_total{job="opsmondo"}[35m]) < 1',
            'for': '10m',
            labels: {
              severity: 'critical',
              alert_id: 'monitor::monitoring_stack::watchdog_missing',
            },
            annotations: {
              description: 'Prometheus Stack instance **{{ $labels.exported_instance }}** has stopped sending watchdog alerts',
              summary: 'Prometheus Stack instance **{{ $labels.exported_instance }}** has sent less than 1 watchdog alert in the past 35 minutes.',
            },
          },
        ],
      },
    ],
  },
}
