{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'NodesMemoryFillingUp',
        rules: [
          {
            alert: 'NodesMemoryFillingUp',
            expr: |||
              ((Sum(node_memory_MemTotal_bytes) - Sum(node_memory_MemAvailable_bytes)) / Sum(node_memory_MemAvailable_bytes) * 100) > 80
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Average nodes memory utilization is greater than 80%.',
              description: 'Average nodes memory utilization is {{ printf "%.2f" $value }}% and is filling up.',
            },
          },
          {
            alert: 'NodesMemoryFillingUp',
            expr: |||
              ((Sum(node_memory_MemTotal_bytes) - Sum(node_memory_MemAvailable_bytes)) / Sum(node_memory_MemAvailable_bytes) * 100) > 90
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Average nodes memory utilization is greater than 90%.',
              description: 'Average nodes memory utilization is {{ printf "%.2f" $value }}% and is filling up.',
            },
          },
        ],
      },
    ],
  },
}
