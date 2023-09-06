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
            alert: 'VeleroUnsuccessfulBackup',
            expr:|||
                (velero_backup_last_status{schedule != ""} == 0)
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              description: 'Velero backup was not successful for {{ $labels.schedule }}.',
              summary: 'Velero backup for schedule {{ $labels.schedule }} was unsuccessful.',
            },
          },
        ],
      },
    ],
  },
}
