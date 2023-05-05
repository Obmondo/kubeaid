{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'quorum-alert.rules',
        rules: [
          {
            alert: 'CephMonQuorumAtRisk',
            expr: |||
              count(ceph_mon_quorum_status{%s} == 1) by (namespace) <= (floor(count(ceph_mon_metadata{%s}) by (namespace) / 2) + 1)
            ||| % [$._config.cephExporterSelector, $._config.cephExporterSelector],
            'for': $._config.monQuorumAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage quorum at risk',
              description: 'Storage cluster quorum is low. Contact Support.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephMonQuorumLost',
            expr: |||
              count(kube_pod_status_phase{pod=~"rook-ceph-mon-.*", phase=~"Running|running"} == 1) by (namespace) < 2
            |||,
            'for': $._config.monQuorumLostTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage quorum is lost',
              description: 'Storage cluster quorum is lost. Contact Support.',
              storage_type: $._config.storageType,
              severity_level: 'critical',
            },
          },
          {
            alert: 'CephMonHighNumberOfLeaderChanges',
            expr: |||
              (ceph_mon_metadata{%(cephExporterSelector)s} * on (ceph_daemon) group_left() (rate(ceph_mon_num_elections{%(cephExporterSelector)s}[5m]) * 60)) > 0.95
            ||| % $._config,
            'for': $._config.monQuorumLeaderChangesAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage Cluster has seen many leader changes recently.',
              description: 'Ceph Monitor {{ $labels.ceph_daemon }} on host {{ $labels.hostname }} has seen {{ $value | printf "%.2f" }} leader changes per minute recently.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
