{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ceph-node-alert.rules',
        rules: [
          {
            alert: 'CephNodeDown',
            expr: |||
              cluster:ceph_node_down:join_kube == 0
            ||| % $._config,
            'for': $._config.cephNodeDownAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage node {{ $labels.node }} went down',
              description: 'Storage node {{ $labels.node }} went down. Please check the node immediately.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
        ],
      },
    ],
  },
}
