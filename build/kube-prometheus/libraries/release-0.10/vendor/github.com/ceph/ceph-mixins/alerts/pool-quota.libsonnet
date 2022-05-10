{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'pool-quota.rules',
        rules: [
          {
            alert: 'CephPoolQuotaBytesNearExhaustion',
            expr: |||
              (ceph_pool_stored_raw * on (pool_id) group_left(name)ceph_pool_metadata) / ((ceph_pool_quota_bytes * on (pool_id) group_left(name)ceph_pool_metadata) > 0) > 0.70
            |||,
            'for': $._config.poolQuotaUtilizationAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage pool quota(bytes) is near exhaustion.',
              description: 'Storage pool {{ $labels.name }} quota usage has crossed 70%.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephPoolQuotaBytesCriticallyExhausted',
            expr: |||
              (ceph_pool_stored_raw * on (pool_id) group_left(name)ceph_pool_metadata) / ((ceph_pool_quota_bytes * on (pool_id) group_left(name)ceph_pool_metadata) > 0) > 0.90
            |||,
            'for': $._config.poolQuotaUtilizationAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage pool quota(bytes) is critically exhausted.',
              description: 'Storage pool {{ $labels.name }} quota usage has crossed 90%.',
              storage_type: $._config.storageType,
              severity_level: 'critical',
            },
          },
        ],
      },
    ],
  },
}
