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
              ((sum(node_memory_MemTotal_bytes) - sum(node_memory_MemAvailable_bytes)) /sum(node_memory_MemTotal_bytes) * 100) > 85 and ((sum(node_memory_MemTotal_bytes) - sum(node_memory_MemAvailable_bytes)) /sum(node_memory_MemTotal_bytes) * 100) <= 90
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Average nodes memory utilization is greater than 85%.',
              description: 'Average nodes memory utilization is {{ printf "%.2f" $value }}% and is filling up.',
            },
          },
          {
            alert: 'NodesMemoryFillingUp',
            expr: |||
              ((sum(node_memory_MemTotal_bytes) - sum(node_memory_MemAvailable_bytes)) / sum(node_memory_MemTotal_bytes) * 100) > 90
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
