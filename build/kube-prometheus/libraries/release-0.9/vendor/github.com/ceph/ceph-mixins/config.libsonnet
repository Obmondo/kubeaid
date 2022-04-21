{
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.
    cephExporterSelector: 'job="rook-ceph-mgr"',

    // Expected number of Ceph Managers which are reporting metrics
    cephMgrCount: 1,
    // Expected number of Ceph Mds which are reporting metrics
    cephMdsCount: 2,

    // Duration to raise various Alerts
    cephNodeDownAlertTime: '30s',
    clusterStateAlertTime: '10m',
    clusterWarningStateAlertTime: '15m',
    clusterVersionAlertTime: '10m',
    clusterUtilizationAlertTime: '5s',
    clusterReadOnlyAlertTime: '0s',
    poolQuotaUtilizationAlertTime: '1m',
    monQuorumAlertTime: '15m',
    monQuorumLostTime: '5m',
    monQuorumLeaderChangesAlertTime: '5m',
    osdDataRebalanceAlertTime: '15s',
    osdDataRecoveryAlertTime: '2h',
    osdDataRecoveryInProgressAlertTime: '30s',
    osdDiskNotRespondingTime: '15m',
    osdDiskUnavailableTime: '1m',
    osdDiskAlertTime: '1m',
    osdDownAlertTime: '5m',
    osdFlapAlertTime: '0s',
    osdSlowOpsTime: '30s',
    osdUtilizationAlertTime: '40s',
    PGRepairAlertTime: '1h',
    pvcUtilizationAlertTime: '5s',
    mgrMissingReplicasAlertTime: '5m',
    mgrIsAbsentAlertTime: '5m',
    mdsMissingReplicasAlertTime: '5m',

    // Constants
    storageType: 'ceph',

    // For links between grafana dashboards, you need to tell us if your grafana
    // servers under some non-root path.
    grafanaPrefix: '',

    // We build alerts for the presence of all these jobs.
    jobs: {
      CephExporter: $._config.cephExporterSelector,
    },
  },
}
