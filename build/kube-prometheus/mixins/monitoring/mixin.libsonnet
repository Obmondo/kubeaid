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
            expr: 'changes(watchdog_alerts_total[65m]) == 0',
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
