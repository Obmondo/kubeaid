{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'SmartMon',
        rules: [
          {
            alert: 'SmartMonUdmaCrcErrorCountRawValue',
            expr: 'sum by (instance, device) (smartctl_device_attribute{attribute_name="UDMA_CRC_Error_Count", attribute_value_type="raw"} >= smartctl_device_attribute{attribute_name="UDMA_CRC_Error_Count", attribute_value_type="worst"})',
            'for': '3h',
            labels: {
              severity: 'critical',
              alert_id: 'SmartMonUdmaCrcErrorCountRawValue',
            },
            annotations: {
              description: 'Disk **{{ .Labels.device }}**  has disk sata failure on instance **{{ .Labels.instance }}**
          UDMA_CRC_Error_Count - The number of errors related to data transfer over the interface. A value of **{{ .Value }}** is concerning and indicates potential issues with the data cable or connections.',
              summary: 'The device has disk sata failures.'
            },
          },
          {
            alert: 'SmartMonDeviceSmartHealthy',
            expr: 'smartmon_device_smart_healthy == 0',
            'for': '3h',
            labels: {
              severity: 'critical',
              alert_id: 'SmartMonDeviceSmartHealthy',
            },
            annotations: {
              description: 'Disk **{{ $labels.disk }}** on **{{ $labels.certname }}** has SMART failure',
              summary: 'Disk has SMART failure.'
            },
          },
          {
            alert: 'SmartMonReallocatedSectorCtRawValue',
            expr: 'smartmon_reallocated_sector_ct_raw_value > smartmon_reallocated_sector_ct_threshold',
            'for': '3h',
            labels: {
              severity: 'critical',
              alert_id: 'SmartMonReallocatedSectorCtRawValue',
            },
            annotations: {
              description: 'Disk **{{ $labels.disk }}** on **{{ $labels.certname }}** has remapped sector too many times,
          instance="**{{ $labels.instance }}**",
          type="**{{ $labels.type }}**",

          Reallocated Sectors Count -  This value is primarily used as a metric of the life expectancy of the drive; a drive which has had any reallocations at all is significantly more likely to fail in the immediate months.',
              summary: 'Disk has remapped disk sector too many times.'
            },
          },
        ],
      },
    ],
  },
}
