{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'cluster-utilization-alert.rules',
        rules: [
          {
            alert: 'CephClusterNearFull',
            expr: |||
              ceph_cluster_total_used_raw_bytes / ceph_cluster_total_bytes > 0.75
            ||| % $._config,
            'for': $._config.clusterUtilizationAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage cluster is nearing full. Data deletion or cluster expansion is required.',
              description: 'Storage cluster utilization has crossed 75% and will become read-only at 85%. Free up some space or expand the storage cluster.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephClusterCriticallyFull',
            expr: |||
              ceph_cluster_total_used_raw_bytes / ceph_cluster_total_bytes > 0.80
            ||| % $._config,
            'for': $._config.clusterUtilizationAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage cluster is critically full and needs immediate data deletion or cluster expansion.',
              description: 'Storage cluster utilization has crossed 80% and will become read-only at 85%. Free up some space or expand the storage cluster immediately.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephClusterReadOnly',
            expr: |||
              ceph_cluster_total_used_raw_bytes / ceph_cluster_total_bytes >= 0.85
            ||| % $._config,
            'for': $._config.clusterReadOnlyAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage cluster is read-only now and needs immediate data deletion or cluster expansion.',
              description: 'Storage cluster utilization has crossed 85% and will become read-only now. Free up some space or expand the storage cluster immediately.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
        ],
      },
    ],
  },
}
