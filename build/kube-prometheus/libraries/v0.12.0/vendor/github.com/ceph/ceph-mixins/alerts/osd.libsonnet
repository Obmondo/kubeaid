{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'osd-alert.rules',
        rules: [
          {
            alert: 'CephOSDCriticallyFull',
            expr: |||
              (ceph_osd_metadata * on (ceph_daemon) group_right(device_class,hostname) (ceph_osd_stat_bytes_used / ceph_osd_stat_bytes)) >= 0.80
            ||| % $._config,
            'for': $._config.osdUtilizationAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Back-end storage device is critically full.',
              description: 'Utilization of storage device {{ $labels.ceph_daemon }} of device_class type {{$labels.device_class}} has crossed 80% on host {{ $labels.hostname }}. Immediately free up some space or add capacity of type {{$labels.device_class}}.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephOSDFlapping',
            expr: |||
              changes(ceph_osd_up[5m]) >= 10
            ||| % $._config,
            'for': $._config.osdFlapAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Ceph storage osd flapping.',
              description: 'Storage daemon {{ $labels.ceph_daemon }} has restarted 5 times in last 5 minutes. Please check the pod events or ceph status to find out the cause.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephOSDNearFull',
            expr: |||
              (ceph_osd_metadata * on (ceph_daemon) group_right(device_class,hostname) (ceph_osd_stat_bytes_used / ceph_osd_stat_bytes)) >= 0.75
            ||| % $._config,
            'for': $._config.osdUtilizationAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Back-end storage device is nearing full.',
              description: 'Utilization of storage device {{ $labels.ceph_daemon }} of device_class type {{$labels.device_class}} has crossed 75% on host {{ $labels.hostname }}. Immediately free up some space or add capacity of type {{$labels.device_class}}.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephOSDDiskNotResponding',
            expr: |||
              label_replace((ceph_osd_in == 1 and ceph_osd_up == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation,"host","$1","exported_instance","(.*)")
            ||| % $._config,
            'for': $._config.osdDiskNotRespondingTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Disk not responding',
              description: 'Disk device {{ $labels.device }} not responding, on host {{ $labels.host }}.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephOSDDiskUnavailable',
            expr: |||
              label_replace((ceph_osd_in == 0 and ceph_osd_up == 0),"disk","$1","ceph_daemon","osd.(.*)") + on(ceph_daemon) group_left(host, device) label_replace(ceph_disk_occupation,"host","$1","exported_instance","(.*)")
            ||| % $._config,
            'for': $._config.osdDiskUnavailableTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Disk not accessible',
              description: 'Disk device {{ $labels.device }} not accessible on host {{ $labels.host }}.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephOSDSlowOps',
            expr: |||
              ceph_healthcheck_slow_ops > 0
            ||| % $._config,
            'for': $._config.osdSlowOpsTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'OSD requests are taking too long to process.',
              description: '{{ $value }} Ceph OSD requests are taking too long to process. Please check ceph status to find out the cause.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephDataRecoveryTakingTooLong',
            expr: |||
              ceph_pg_undersized > 0
            ||| % $._config,
            'for': $._config.osdDataRecoveryAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Data recovery is slow',
              description: 'Data recovery has been active for too long. Contact Support.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephPGRepairTakingTooLong',
            expr: |||
              ceph_pg_inconsistent > 0
            ||| % $._config,
            'for': $._config.PGRepairAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Self heal problems detected',
              description: 'Self heal operations taking too long. Contact Support.',
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
        ],
      },
    ],
  },
}
