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
        ],
      },
    ],
  },
}
