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
            expr: |||
              (
                ((time() - velero_backup_last_successful_timestamp{schedule=~".*6hrly.*"}) + on(schedule) group_left velero_backup_attempt_total > (60 * 60 * 6) and ON() hour() >= 6.30 <= 18.30) or
                ((time() - velero_backup_last_successful_timestamp{schedule=~".*daily.*"}) + on(schedule) group_left velero_backup_attempt_total > (60 * 60 * 24) and ON() day_of_week() != 0) or
                ((time() - velero_backup_last_successful_timestamp{schedule=~".*weekly.*"}) + on(schedule) group_left velero_backup_attempt_total > (60 * 60 * 24 * 7))
              )
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              description: 'Velero backup was not successful for {{ $labels.schedule }}.',
              summary: 'Velero backup for schedule was unsuccessful.',
            },
          },
          {
            alert: 'VeleroNoSuccessfulBackups',
            expr: |||
              (
                (velero_backup_last_status{schedule=~".*6hrly.*"} != 1) or
                (velero_backup_last_status{schedule=~".*daily.*"} != 1) or
                (velero_backup_last_status{schedule=~".*weekly.*"} != 1)
              )
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              description: 'No succesfull Velero backup exists for {{ $labels.schedule }} schedule.',
              summary: 'No successful Velero backup exists',
            },
          },
        ],
      },
    ],
  },
}
