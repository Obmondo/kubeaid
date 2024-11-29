{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'zfs-pool-status',
        rules: [
          {
            alert: 'ZFSPoolStatus',
            expr: 'node_zfs_zpool_state{state!="online"} > 0',
            'for': '30m',
            labels: {
              severity: 'critical',
              alert_id: 'ZFSPoolStatus',
            },
            annotations: {
              summary: 'ZFS Pool is Degraded.',
              description: 'The zfs pool **{{ .Labels.zpool }}** is {{ .Labels.state }} on {{ .Labels.instance }}',
            },
          },
        ],
      },
    ],
  },
}
