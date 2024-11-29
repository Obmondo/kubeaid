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
            alert: 'WatchdogMissing',
            expr: 'changes(watchdog_alerts_total[65m]) == 0',
            'for': '10m',
            labels: {
              severity: 'critical',
              alert_id: 'WatchdogMissing',
            },
            annotations: {
              description: 'Prometheus Stack instance **{{ $labels.exported_instance }}** has stopped sending watchdog alerts',
              summary: 'Prometheus Stack instance has sent less than 1 watchdog alert in the past 35 minutes.',
            },
          },
        ],
      },
    ],
  },
}
