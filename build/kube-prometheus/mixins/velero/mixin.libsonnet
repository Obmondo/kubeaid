// based on Prometheus alert by GitHub user raqqun:
// https://github.com/vmware-tanzu/velero/issues/2725#issuecomment-661577500
{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'velero',
        rules: [
          {
            alert: 'VeleroBackupPartialFailures',
            expr: |||
              velero_backup_partial_failure_total{schedule!="", %(selector)s} / velero_backup_attempt_total{schedule!="", %(selector)s} > 0.25
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              description: 'Velero backup {{ $labels.schedule }} has {{ $value | humanizePercentage }} partially failed backups.',
              summary: 'Velero backup {{ $labels.schedule }} has too many partially failed backups',
            },
          },
          {
            alert: 'VeleroBackupFailures',
            expr: |||
              velero_backup_failure_total{schedule!="", %(selector)s} / velero_backup_attempt_total{schedule!="", %(selector)s} > 0.25
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              description: 'Velero backup {{ $labels.schedule }} has {{ $value | humanizePercentage }} failed backups.',
              summary: 'Velero backup {{ $labels.schedule }} has too many failed backups',
            },
          },
        ],
      },
    ],
  },
}
