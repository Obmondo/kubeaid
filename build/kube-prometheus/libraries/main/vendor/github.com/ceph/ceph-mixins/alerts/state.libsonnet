{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'cluster-state-alert.rules',
        rules: [
          {
            alert: 'CephClusterErrorState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} > 1
            ||| % $._config,
            'for': $._config.clusterStateAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage cluster is in error state',
              description: 'Storage cluster is in error state for more than %s.' % $._config.clusterStateAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephClusterWarningState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} == 1
            ||| % $._config,
            'for': $._config.clusterWarningStateAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage cluster is in degraded state',
              description: 'Storage cluster is in warning state for more than %s.' % $._config.clusterStateAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephOSDVersionMismatch',
            expr: |||
              count(count(ceph_osd_metadata{%(cephExporterSelector)s}) by (ceph_version, namespace)) by (ceph_version, namespace) > 1
            ||| % $._config,
            'for': $._config.clusterVersionAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'There are multiple versions of storage services running.',
              description: 'There are {{ $value }} different versions of Ceph OSD components running.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephMonVersionMismatch',
            expr: |||
              count(count(ceph_mon_metadata{%(cephExporterSelector)s, ceph_version != ""}) by (ceph_version)) > 1
            ||| % $._config,
            'for': $._config.clusterVersionAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'There are multiple versions of storage services running.',
              description: 'There are {{ $value }} different versions of Ceph Mon components running.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
