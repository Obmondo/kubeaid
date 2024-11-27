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
            alert: 'HostRaidDiskFailure',
            expr: '(node_md_disks{state="failed"} > 0) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}',
            'for': '30m',
            labels: {
              severity: 'critical',
              alert_id: 'HostRaidDiskFailure',
            },
            annotations: {
              summary: 'Host RAID disk failure (instance {{ $labels.instance }})',
              description: 'At least one device in RAID array on {{ $labels.instance }} failed. Array {{ $labels.md_device }} needs attention and possibly a disk swap\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}',
            },
          },
        ],
      },
    ],
  },
}
