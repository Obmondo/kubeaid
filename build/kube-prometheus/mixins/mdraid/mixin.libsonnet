{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'mdraid-status',
        rules: [
          {
            alert: 'HostRaidDiskDegraded',
            expr: '(node_md_state{state="inactive"} > 0) * on(instance) group_left (pod) node_uname_info{nodename=~".+"}',
            'for': '15m',
            labels: {
              severity: 'critical',
              alert_id: 'HostRaidDiskDegraded',
            },
            annotations: {
              summary: 'RAID Array is degraded.',
              description: 'RAID array {{ $labels.device }} on {{ $labels.instance }} is in degraded state due to one or more disks failures. Number of spare drives is insufficient to fix issue automatically',
            },
          },
          {
            alert: 'HostRaidDiskFailure',
            expr: '(node_md_disks{state="failed"} > 0) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}',
            'for': '15m',
            labels: {
              severity: 'critical',
              alert_id: 'HostRaidDiskFailure',
            },
            annotations: {
              summary: 'Host RAID disk failure on instance.',
              description: 'At least one disk in RAID array {{ $labels.device }} on {{ $labels.instance }} failed. Array {{ $labels.device }} needs attention and possibly a disk swap',
            },
          },
        ],
      },
    ],
  },
}
