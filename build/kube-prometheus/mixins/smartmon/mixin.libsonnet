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
          {
            alert: 'SmartMonDevicePercentageUsed',
            expr: 'smartctl_device_percentage_used > 100',
            'for': '3h',
            labels: {
              severity: 'critical',
              alert_id: 'SmartMonDevicePercentageUsed',
            },
            annotations: {
              description: 'Disk **{{ $labels.disk }}** on **{{ $labels.certname }}** has exceeded 100% of NVM subsystem life,
          instance="**{{ $labels.instance }}**",

          Percentage Used: Contains a vendor specific estimate of the percentage of NVM subsystem life used based on the actual usage and the manufacturers prediction of NVM life. A value of 100 indicates that the estimated endurance of the NVM in the NVM subsystem has been consumed, but may not indicate an NVM subsystem failure. The value is allowed to exceed 100, percentages greater than 254 shall be represented as 255, this value shall be updated once per power-on hour (when the controller is not in a sleep state).',
              summary: 'Disk has exceeded 100% of NVM subsystem life.'
            },
          },
        ],
      },
    ],
  },
}