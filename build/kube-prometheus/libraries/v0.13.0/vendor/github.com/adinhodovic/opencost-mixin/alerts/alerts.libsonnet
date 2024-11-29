{
  prometheusAlerts+:: {
    groups+: std.prune([
      if $._config.alerts.budget.enabled then {
        name: 'opencost',
        rules: [
          {
            alert: 'OpenCostMonthlyBudgetExceeded',
            expr: |||
              (
                sum(
                  node_total_hourly_cost{
                    %s
                  }
                ) * 730
                or vector(0)
              )
              +
              (
                sum(
                  sum(
                    kube_persistentvolume_capacity_bytes{
                      %s
                    }
                    / 1024 / 1024 / 1024
                  ) by (persistentvolume)
                  *
                  sum(
                    pv_hourly_cost{
                      %s
                    }
                  ) by (persistentvolume)
                ) * 730
                or vector(0)
              )
              > %s
            ||| % [$._config.openCostSelector, $._config.openCostSelector, $._config.openCostSelector, $._config.alerts.budget.monthlyCostThreshold],
            labels: {
              severity: 'warning',
            },
            'for': '30m',
            annotations: {
              summary: 'OpenCost Monthly Budget Exceeded',
              description: 'The monthly budget for the cluster has been exceeded. Consider scaling down resources or increasing the budget.',
              dashboard_url: $._config.openCostOverviewDashboardUrl,
            },
          },
          {
            alert: 'OpenCostAnomalyDetected',
            expr: |||
              1 -
              (
                avg_over_time(
                  sum(
                    node_total_hourly_cost{
                      %s
                    }
                  ) [7d:1h]
                )
                /
                avg_over_time(
                  sum(
                    node_total_hourly_cost{
                      %s
                    }
                  ) [3h:30m]
                )
              ) > %s
            ||| % [$._config.openCostSelector, $._config.openCostSelector, $._config.alerts.anomaly.anomalyPercentageThreshold / 100],
            labels: {
              severity: 'warning',
            },
            'for': '10m',
            annotations: {
              summary: 'OpenCost Cost Anomaly Detected',
              description: 'A significant increase in cluster costs has been detected. The average hourly cost over the 3 hours exceeds the 7-day average by more than %s%%. This could indicate unexpected resource usage or cost-related changes in the cluster.' % $._config.alerts.anomaly.anomalyPercentageThreshold,
              dashboard_url: $._config.openCostOverviewDashboardUrl,
            },
          },
        ],
      },
    ]),
  },
}
