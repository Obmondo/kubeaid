local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local annotation = g.dashboard.annotation;

{
  _config+:: {
    local this = self,
    // Bypasses grafana.com/dashboards validator
    bypassDashboardValidation: {
      __inputs: [],
      __requires: [],
    },

    openCostSelector: 'job=~"opencost"',

    grafanaUrl: 'https://grafana.com',

    openCostOverviewDashboardUid: 'opencost-mixin-kover-jkwq',
    openCostOverviewDashboardUrl: '%s/d/%s/opencost-overview' % [this.grafanaUrl, this.openCostOverviewDashboardUid],
    openCostNamespaceDashboardUid: 'opencost-mixin-namespace-jkwq',
    openCostNamespaceDashboardUrl: '%s/d/%s/opencost-namespace' % [this.grafanaUrl, this.openCostNamespaceDashboardUid],

    alerts: {
      budget: {
        enabled: true,
        monthlyCostThreshold: 200,
      },
      anomaly: {
        enabled: true,
        anomalyPercentageThreshold: 20,
      },
    },

    tags: ['opencost', 'opencost-mixin'],

    // Custom annotations to display in graphs
    annotation: {
      enabled: false,
      name: 'Custom Annotation',
      datasource: '-- Grafana --',
      iconColor: 'green',
      tags: [],
    },

    customAnnotation:: if $._config.annotation.enabled then
      annotation.withName($._config.annotation.name) +
      annotation.withIconColor($._config.annotation.iconColor) +
      annotation.withHide(false) +
      annotation.datasource.withUid($._config.annotation.datasource) +
      annotation.target.withMatchAny(true) +
      annotation.target.withTags($._config.annotation.tags) +
      annotation.target.withType('tags')
    else {},
  },
}
