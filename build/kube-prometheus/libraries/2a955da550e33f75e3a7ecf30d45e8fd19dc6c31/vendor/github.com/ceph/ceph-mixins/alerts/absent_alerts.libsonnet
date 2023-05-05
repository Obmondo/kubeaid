{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ceph-mgr-status',
        rules: [
          {
            alert: 'CephMgrIsAbsent',
            expr: |||
              label_replace((up{%(cephExporterSelector)s} == 0 or absent(up{%(cephExporterSelector)s})), "namespace", "openshift-storage", "", "")
            ||| % $._config,
            'for': $._config.mgrIsAbsentAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage metrics collector service not available anymore.',
              description: 'Ceph Manager has disappeared from Prometheus target discovery.',
              storage_type: $._config.storageType,
              severity_level: 'critical',
            },
          },
          {
            alert: 'CephMgrIsMissingReplicas',
            expr: |||
              sum(kube_deployment_spec_replicas{deployment=~"rook-ceph-mgr-.*"}) by (namespace) < %(cephMgrCount)d
            ||| % $._config,
            'for': $._config.mgrMissingReplicasAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: "Storage metrics collector service doesn't have required no of replicas.",
              description: 'Ceph Manager is missing replicas.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
      {
        name: 'ceph-mds-status',
        rules: [
          {
            alert: 'CephMdsMissingReplicas',
            expr: |||
              sum(ceph_mds_metadata{%(cephExporterSelector)s} == 1) by (namespace) < %(cephMdsCount)d
            ||| % $._config,
            'for': $._config.mdsMissingReplicasAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Insufficient replicas for storage metadata service.',
              description: 'Minimum required replicas for storage metadata service not available. Might affect the working of storage cluster.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
