{
  prometheusRules+:: {
    groups+: [
      {
        name: 'ceph.rules',
        rules: [
          {
            record: 'cluster:ceph_node_down:join_kube',
            expr: |||
              kube_node_status_condition{condition="Ready",job="kube-state-metrics",status="true"} * on (node) group_right() max(label_replace(ceph_disk_occupation{%(cephExporterSelector)s},"node","$1","exported_instance","(.*)")) by (node, namespace)
            ||| % $._config,
          },
          {
            record: 'cluster:ceph_disk_latency:join_ceph_node_disk_irate1m',
            expr: |||
              avg(topk by (ceph_daemon) (1, label_replace(label_replace(ceph_disk_occupation{job="rook-ceph-mgr"}, "instance", "$1", "exported_instance", "(.*)"), "device", "$1", "device", "/dev/(.*)")) * on(instance, device) group_right(ceph_daemon) topk by (instance,device) (1,(irate(node_disk_read_time_seconds_total[1m]) + irate(node_disk_write_time_seconds_total[1m]) / (clamp_min(irate(node_disk_reads_completed_total[1m]), 1) + irate(node_disk_writes_completed_total[1m])))))
            ||| % $._config,
          },
        ],
      },
      {
        name: 'telemeter.rules',
        rules: [
          {
            record: 'job:ceph_osd_metadata:count',
            expr: |||
              count(ceph_osd_metadata{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:kube_pv:count',
            expr: |||
              count(kube_persistentvolume_info * on (storageclass)  group_left(provisioner) kube_storageclass_info {provisioner=~"(.*rbd.csi.ceph.com)|(.*cephfs.csi.ceph.com)"})
            ||| % $._config,
          },
          {
            record: 'job:ceph_pools_iops:total',
            expr: |||
              sum(ceph_pool_rd{%(cephExporterSelector)s}+ ceph_pool_wr{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_pools_iops_bytes:total',
            expr: |||
              sum(ceph_pool_rd_bytes{%(cephExporterSelector)s}+ ceph_pool_wr_bytes{%(cephExporterSelector)s})
            ||| % $._config,
          },
          {
            record: 'job:ceph_versions_running:count',
            expr: |||
              count(count(ceph_mon_metadata{%(cephExporterSelector)s} or ceph_osd_metadata{%(cephExporterSelector)s} or ceph_rgw_metadata{%(cephExporterSelector)s} or ceph_mds_metadata{%(cephExporterSelector)s} or ceph_mgr_metadata{%(cephExporterSelector)s}) by(ceph_version))
            ||| % $._config,
          },
        ],
      },
    ],
  },
}

//List of backup metrics which might be useful later
// {
//   record: 'job:ceph_osd_in:count',
//   expr: |||
//     count(ceph_osd_in{%(cephExporterSelector)s} == 1)
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_osd_up:count',
//   expr: |||
//     count(ceph_osd_up{%(cephExporterSelector)s} == 1)
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_osd_metadata:count_bluestore',
//   expr: |||
//     count(ceph_osd_metadata{%(cephExporterSelector)s, objectstore = 'bluestore'})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_osd_metadata:count_filestore',
//   expr: |||
//     count(ceph_osd_metadata{%(cephExporterSelector)s, objectstore = 'filestore'})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_osd_metadata:count_ssd',
//   expr: |||
//     count(ceph_osd_metadata{%(cephExporterSelector)s, device_class = 'ssd'})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_osd_metadata:count_hdd',
//   expr: |||
//     count(ceph_osd_metadata{%(cephExporterSelector)s, device_class = 'hdd'})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_pool_rd:total',
//   expr: |||
//     sum(ceph_pool_rd{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_pool_wr:total',
//   expr: |||
//     sum(ceph_pool_wr{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_pool_rd_bytes:total',
//   expr: |||
//     sum(ceph_pool_rd_bytes{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_pool_wr_bytes:total',
//   expr: |||
//     sum(ceph_pool_wr_bytes{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_mds_metadata:count',
//   expr: |||
//     count(ceph_mds_metadata{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_mon_metadata:count',
//   expr: |||
//     count(ceph_mon_metadata{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_mgr_metadata:count',
//   expr: |||
//     count(ceph_mgr_metadata{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_rgw_metadata:count',
//   expr: |||
//     count(ceph_rgw_metadata{%(cephExporterSelector)s})
//   ||| % $._config,
// },
// {
//   record: 'job:ceph_mon_metadata:distinct',
//   expr: |||
//     count(count(ceph_mon_metadata{%(cephExporterSelector)s}) by (ceph_version))
//   ||| % $._config,
// },
