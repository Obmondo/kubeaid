local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local dashboard = g.dashboard;
local row = g.panel.row;
local grid = g.util.grid;

local variable = dashboard.variable;
local datasource = variable.datasource;
local query = variable.query;
local prometheus = g.query.prometheus;

local statPanel = g.panel.stat;
local timeSeriesPanel = g.panel.timeSeries;
local tablePanel = g.panel.table;
local pieChartPanel = g.panel.pieChart;

// Stat
local stOptions = statPanel.options;
local stStandardOptions = statPanel.standardOptions;
local stQueryOptions = statPanel.queryOptions;

// Timeseries
local tsOptions = timeSeriesPanel.options;
local tsStandardOptions = timeSeriesPanel.standardOptions;
local tsQueryOptions = timeSeriesPanel.queryOptions;
local tsFieldConfig = timeSeriesPanel.fieldConfig;
local tsCustom = tsFieldConfig.defaults.custom;
local tsLegend = tsOptions.legend;

// Table
local tbOptions = tablePanel.options;
local tbStandardOptions = tablePanel.standardOptions;
local tbQueryOptions = tablePanel.queryOptions;
local tbFieldConfig = tablePanel.fieldConfig;
local tbPanelOptions = tablePanel.panelOptions;
local tbOverride = tbStandardOptions.override;

// Pie Chart
local pieOptions = pieChartPanel.options;
local pieStandardOptions = pieChartPanel.standardOptions;
local pieQueryOptions = pieChartPanel.queryOptions;

{
  grafanaDashboards+:: {

    local datasourceVariable =
      datasource.new(
        'datasource',
        'prometheus',
      ) +
      datasource.generalOptions.withLabel('Data source') +
      {
        current: {
          selected: true,
          text: $._config.datasourceName,
          value: $._config.datasourceName,
        },
      },

    local clusterVariable =
      query.new(
        $._config.clusterLabel,
        'label_values(opencost_build_info{}, cluster)' % $._config,
      ) +
      query.withDatasourceFromVariable(datasourceVariable) +
      query.withSort() +
      query.generalOptions.withLabel('Cluster') +
      query.refresh.onLoad() +
      query.refresh.onTime() +
      (
        if $._config.showMultiCluster
        then query.generalOptions.showOnDashboard.withLabelAndValue()
        else query.generalOptions.showOnDashboard.withNothing()
      ),

    local jobVariable =
      query.new(
        'job',
        'label_values(opencost_build_info{%(clusterLabel)s="$cluster"}, job)' % $._config,
      ) +
      query.withDatasourceFromVariable(datasourceVariable) +
      query.withSort(1) +
      query.generalOptions.withLabel('Job') +
      query.refresh.onLoad() +
      query.refresh.onTime(),

    local variables = [
      datasourceVariable,
      clusterVariable,
      jobVariable,
    ],

    local openCostDailyCostQuery = |||
      sum(
        node_total_hourly_cost{
          %(clusterLabel)s="$cluster",
          job=~"$job"
        }
      ) * 24
      +
      sum(
        sum(
          kube_persistentvolume_capacity_bytes{
            %(clusterLabel)s="$cluster",
            job=~"$job"
          } / (1024 * 1024 * 1024)
        ) by (persistentvolume)
        * on(persistentvolume) group_left()
        sum(
          pv_hourly_cost{
            %(clusterLabel)s="$cluster",
            job=~"$job"
          }
        ) by (persistentvolume)
      ) * 24
    ||| % $._config,

    local openCostDailyCostStatPanel =
      statPanel.new(
        'Daily Cost',
      ) +
      stQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostDailyCostQuery,
        )
      ) +
      stStandardOptions.withUnit('currencyUSD') +
      stStandardOptions.withDecimals(2) +
      stOptions.reduceOptions.withCalcs(['lastNotNull']) +
      stOptions.withGraphMode('none') +
      stOptions.withShowPercentChange(true) +
      stOptions.withPercentChangeColorMode('inverted') +
      stStandardOptions.thresholds.withSteps([
        stStandardOptions.threshold.step.withValue(0) +
        stStandardOptions.threshold.step.withColor('red'),
        stStandardOptions.threshold.step.withValue(0.1) +
        stStandardOptions.threshold.step.withColor('green'),
      ]),


    local openCostHourlyCostQuery = std.strReplace(openCostDailyCostQuery, '* 24', ''),

    local openCostHourlyCostStatPanel =
      statPanel.new(
        'Hourly Cost',
      ) +
      stQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostHourlyCostQuery,
        )
      ) +
      stStandardOptions.withUnit('currencyUSD') +
      stStandardOptions.withDecimals(2) +
      stOptions.reduceOptions.withCalcs(['lastNotNull']) +
      stOptions.withGraphMode('none') +
      stOptions.withShowPercentChange(true) +
      stOptions.withPercentChangeColorMode('inverted') +
      stStandardOptions.thresholds.withSteps([
        stStandardOptions.threshold.step.withValue(0) +
        stStandardOptions.threshold.step.withColor('red'),
        stStandardOptions.threshold.step.withValue(0.1) +
        stStandardOptions.threshold.step.withColor('green'),
      ]),

    local openCostMonthlyCostQuery = std.strReplace(openCostDailyCostQuery, '* 24', '* 730'),

    local openCostMonthlyCostStatPanel =
      statPanel.new(
        'Monthly Cost',
      ) +
      stQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostMonthlyCostQuery,
        )
      ) +
      stStandardOptions.withUnit('currencyUSD') +
      stStandardOptions.withDecimals(2) +
      stOptions.reduceOptions.withCalcs(['lastNotNull']) +
      stOptions.withGraphMode('none') +
      stOptions.withShowPercentChange(true) +
      stOptions.withPercentChangeColorMode('inverted') +
      stStandardOptions.thresholds.withSteps([
        stStandardOptions.threshold.step.withValue(0) +
        stStandardOptions.threshold.step.withColor('red'),
        stStandardOptions.threshold.step.withValue(0.1) +
        stStandardOptions.threshold.step.withColor('green'),
      ]),

    local openCostMonthlyRamCostQuery = |||
      sum(
        sum(
          kube_node_status_capacity{
            %(clusterLabel)s="$cluster",
            job=~"$job",
            resource="memory",
            unit="byte"
          }
        ) by (node)
        / (1024 * 1024 * 1024)
        * on(node) group_left()
          sum(
            node_ram_hourly_cost{
              %(clusterLabel)s="$cluster",
              job=~"$job"
            }
          ) by (node)
        * 730
      )
    ||| % $._config,

    local openCostMonthlyRamCostStatPanel =
      statPanel.new(
        'Monthly Ram Cost',
      ) +
      stQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostMonthlyRamCostQuery,
        )
      ) +
      stStandardOptions.withUnit('currencyUSD') +
      stStandardOptions.withDecimals(2) +
      stOptions.reduceOptions.withCalcs(['lastNotNull']) +
      stOptions.withGraphMode('none') +
      stOptions.withShowPercentChange(true) +
      stOptions.withPercentChangeColorMode('inverted') +
      stStandardOptions.thresholds.withSteps([
        stStandardOptions.threshold.step.withValue(0) +
        stStandardOptions.threshold.step.withColor('red'),
        stStandardOptions.threshold.step.withValue(0.1) +
        stStandardOptions.threshold.step.withColor('green'),
      ]),

    local openCostMonthlyCpuCostQuery = |||
      sum(
        sum(
          kube_node_status_capacity{
            %(clusterLabel)s="$cluster",
            job=~"$job",
            resource="cpu",
            unit="core"
          }
        ) by (node)
        * on(node) group_left()
          sum(
            node_cpu_hourly_cost{
              %(clusterLabel)s="$cluster",
              job=~"$job"
            }
          ) by (node)
        * 730
      )
    ||| % $._config,

    local openCostMonthlyCpuCostStatPanel =
      statPanel.new(
        'Monthly CPU Cost',
      ) +
      stQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostMonthlyCpuCostQuery,
        )
      ) +
      stStandardOptions.withUnit('currencyUSD') +
      stStandardOptions.withDecimals(2) +
      stOptions.reduceOptions.withCalcs(['lastNotNull']) +
      stOptions.withGraphMode('none') +
      stOptions.withShowPercentChange(true) +
      stOptions.withPercentChangeColorMode('inverted') +
      stStandardOptions.thresholds.withSteps([
        stStandardOptions.threshold.step.withValue(0) +
        stStandardOptions.threshold.step.withColor('red'),
        stStandardOptions.threshold.step.withValue(0.1) +
        stStandardOptions.threshold.step.withColor('green'),
      ]),

    local openCostMonthlyPVCostQuery = |||
      sum(
        sum(
          kube_persistentvolume_capacity_bytes{
            %(clusterLabel)s="$cluster",
            job=~"$job"
          } / (1024 * 1024 * 1024)
        ) by (persistentvolume)
        * on(persistentvolume) group_left()
          sum(
            pv_hourly_cost{
              %(clusterLabel)s="$cluster",
              job=~"$job"
            }
          ) by (persistentvolume)
      ) * 730
    ||| % $._config,

    local openCostMonthlyPVCostStatPanel =
      statPanel.new(
        'Monthly PV Cost',
      ) +
      stQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostMonthlyPVCostQuery,
        )
      ) +
      stStandardOptions.withUnit('currencyUSD') +
      stStandardOptions.withDecimals(2) +
      stOptions.reduceOptions.withCalcs(['lastNotNull']) +
      stOptions.withGraphMode('none') +
      stOptions.withShowPercentChange(true) +
      stOptions.withPercentChangeColorMode('inverted') +
      stStandardOptions.thresholds.withSteps([
        stStandardOptions.threshold.step.withValue(0) +
        stStandardOptions.threshold.step.withColor('red'),
        stStandardOptions.threshold.step.withValue(0.1) +
        stStandardOptions.threshold.step.withColor('green'),
      ]),

    local openCostNodeMonthlyCpuCostQuery = |||
      sum(
        kube_node_status_capacity{
          %(clusterLabel)s="$cluster",
          job=~"$job",
          resource="cpu",
          unit="core"
        }
      ) by (node)
      * on(node) group_left(cluster, instance_type, arch)
        sum(
          node_cpu_hourly_cost{
            %(clusterLabel)s="$cluster",
            job=~"$job"
          }
        ) by (node, instance_type, arch)
      * 730
    ||| % $._config,

    local openCostNodeMonthlyRamCostQuery = |||
      sum(
        kube_node_status_capacity{
          %(clusterLabel)s="$cluster",
          job=~"$job",
          resource="memory",
          unit="byte"
        }
      ) by (node)
      / (1024 * 1024 * 1024)
      * on(node) group_left(cluster, instance_type, arch)
        sum(
          node_ram_hourly_cost{
            %(clusterLabel)s="$cluster",
            job=~"$job"
          }
        ) by (node, instance_type, arch)
      * 730
    ||| % $._config,

    local openCostHourlyCostTimeSeriesPanel =
      timeSeriesPanel.new(
        'Hourly Cost',
      ) +
      tsQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostHourlyCostQuery,
          ) +
          prometheus.withLegendFormat('Hourly Cost') +
          prometheus.withInterval('1m'),
        ]
      ) +
      tsStandardOptions.withUnit('currencyUSD') +
      tsLegend.withShowLegend(false) +
      tsCustom.withSpanNulls(false),

    local openCostDailyCostTimeSeriesPanel =
      timeSeriesPanel.new(
        'Daily Cost',
      ) +
      tsQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostDailyCostQuery,
          ) +
          prometheus.withLegendFormat('Daily Cost') +
          prometheus.withInterval('1m'),
        ]
      ) +
      tsStandardOptions.withUnit('currencyUSD') +
      tsLegend.withShowLegend(false) +
      tsCustom.withSpanNulls(false),

    local openCostMonthlyCostTimeSeriesPanel =
      timeSeriesPanel.new(
        'Monthly Cost',
      ) +
      tsQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostMonthlyCostQuery,
          ) +
          prometheus.withLegendFormat('Monthly Cost') +
          prometheus.withInterval('1m'),
        ]
      ) +
      tsStandardOptions.withUnit('currencyUSD') +
      tsLegend.withShowLegend(false) +
      tsCustom.withSpanNulls(false),

    local openCostTotalCostVariance7dQuery = |||
      (
        avg_over_time(
          sum(
            node_total_hourly_cost{%(clusterLabel)s="$cluster", job=~"$job"}
          ) [1d:1h]
        )
        -
        avg_over_time(
          sum(
            node_total_hourly_cost{%(clusterLabel)s="$cluster", job=~"$job"}
          ) [7d:1h]
        )
      )
      /
      avg_over_time(
        sum(
          node_total_hourly_cost{%(clusterLabel)s="$cluster", job=~"$job"}
        ) [7d:1h]
      )
    ||| % $._config,

    local openCostTotalCostVariance30dQuery = |||
      (
        avg_over_time(
          sum(
            node_total_hourly_cost{%(clusterLabel)s="$cluster", job=~"$job"}
          ) [1d:1h]
        )
        -
        avg_over_time(
          sum(
            node_total_hourly_cost{%(clusterLabel)s="$cluster", job=~"$job"}
          ) [30d:1h]
        )
      )
      /
      avg_over_time(
        sum(
          node_total_hourly_cost{%(clusterLabel)s="$cluster", job=~"$job"}
        ) [30d:1h]
      )
    ||| % $._config,

    local openCostTotalCostVarianceTimeSeriesPanel =
      timeSeriesPanel.new(
        'Total Cost Variance',
      ) +
      tsQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostTotalCostVariance7dQuery,
          ) +
          prometheus.withLegendFormat('Current hourly cost vs. 7-day average') +
          prometheus.withInterval('30m'),
          prometheus.new(
            '$datasource',
            openCostTotalCostVariance30dQuery,
          ) +
          prometheus.withLegendFormat('Current hourly cost vs. 30-day average') +
          prometheus.withInterval('30m'),
        ]
      ) +
      tsStandardOptions.withUnit('percentunit') +
      tsLegend.withShowLegend(true) +
      tsOptions.tooltip.withMode('multi') +
      tsOptions.tooltip.withSort('desc') +
      tsCustom.withSpanNulls(false),

    local openCostCpuCostVariance30dQuery = |||
      (
        avg_over_time(
          %s [1d:1h]
        )
        -
        avg_over_time(
          %s [30d:1h]
        )
      )
      /
      avg_over_time(
        %s [30d:1h]
      )
    ||| % [openCostMonthlyCpuCostQuery, openCostMonthlyCpuCostQuery, openCostMonthlyCpuCostQuery],

    local openCostRamCostVariance30dQuery = |||
      (
        avg_over_time(
          %s [1d:1h]
        )
        -
        avg_over_time(
          %s [30d:1h]
        )
      )
      /
      avg_over_time(
        %s [30d:1h]
      )
    ||| % [openCostMonthlyRamCostQuery, openCostMonthlyRamCostQuery, openCostMonthlyRamCostQuery],

    local openCostPVCostVariance30dQuery = |||
      (
        avg_over_time(
          (%s) [1d:1h]
        )
        -
        avg_over_time(
          (%s) [30d:1h]
        )
      )
      /
      avg_over_time(
        (%s) [30d:1h]
      )
    ||| % [openCostMonthlyPVCostQuery, openCostMonthlyPVCostQuery, openCostMonthlyPVCostQuery],

    local openCostResourceCostVarianceTimeSeriesPanel =
      timeSeriesPanel.new(
        'Resource Cost Variance',
      ) +
      tsQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostCpuCostVariance30dQuery,
          ) +
          prometheus.withLegendFormat('Current CPU hourly cost vs. 30-day average') +
          prometheus.withInterval('30m'),
          prometheus.new(
            '$datasource',
            openCostRamCostVariance30dQuery,
          ) +
          prometheus.withLegendFormat('Current RAM hourly cost vs. 30-day average') +
          prometheus.withInterval('30m'),
          prometheus.new(
            '$datasource',
            openCostPVCostVariance30dQuery,
          ) +
          prometheus.withLegendFormat('Current PV hourly cost vs. 30-day average') +
          prometheus.withInterval('30m'),
        ]
      ) +
      tsStandardOptions.withUnit('percentunit') +
      tsOptions.tooltip.withMode('multi') +
      tsOptions.tooltip.withSort('desc') +
      tsLegend.withShowLegend(true) +
      tsCustom.withSpanNulls(false),

    local openCostResourceCostPieChartPanel =
      pieChartPanel.new(
        'Cost by Resource'
      ) +
      pieQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostMonthlyCpuCostQuery,
          ) +
          prometheus.withLegendFormat('CPU') +
          prometheus.withInstant(true),
          prometheus.new(
            '$datasource',
            openCostMonthlyRamCostQuery,
          ) +
          prometheus.withLegendFormat('RAM') +
          prometheus.withInstant(true),
          prometheus.new(
            '$datasource',
            openCostMonthlyPVCostQuery,
          ) +
          prometheus.withLegendFormat('PV') +
          prometheus.withInstant(true),
        ]
      ) +
      pieOptions.withPieType('pie') +
      pieStandardOptions.withUnit('currencyUSD') +
      pieOptions.legend.withAsTable(true) +
      pieOptions.legend.withPlacement('right') +
      pieOptions.legend.withDisplayMode('table') +
      pieOptions.legend.withValues(['value', 'percent']) +
      pieOptions.legend.withSortDesc(true),

    // Keep job label formatting inconsistent due to strReplace
    local openCostNamespaceMonthlyCostQuery = |||
      topk(10,
        sum(
          sum(
            container_memory_allocation_bytes{
              %(clusterLabel)s="$cluster",
              job=~"$job"}
          ) by (namespace, instance)
          * on(instance) group_left()
            (
              node_ram_hourly_cost{
                %(clusterLabel)s="$cluster",
                job=~"$job"} / (1024 * 1024 * 1024) * 730
            )
          +
          sum(
            container_cpu_allocation{
              %(clusterLabel)s="$cluster",
              job=~"$job"}
          ) by (namespace, instance)
          * on(instance) group_left()
            (
              node_cpu_hourly_cost{
                %(clusterLabel)s="$cluster",
                job=~"$job"} * 730
            )
        ) by (namespace)
      )
    ||| % $._config,

    local openCostNamespaceCostPieChartPanel =
      pieChartPanel.new(
        'Cost by Namespace'
      ) +
      pieQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostNamespaceMonthlyCostQuery,
        ) +
        prometheus.withLegendFormat('{{ namespace }}') +
        prometheus.withInstant(true),
      ) +
      pieOptions.withPieType('pie') +
      pieStandardOptions.withUnit('currencyUSD') +
      pieOptions.legend.withAsTable(true) +
      pieOptions.legend.withPlacement('right') +
      pieOptions.legend.withDisplayMode('table') +
      pieOptions.legend.withValues(['value', 'percent']) +
      pieOptions.legend.withSortDesc(true),

    local openCostInstanceTypeCostQuery = |||
      topk(10,
        sum(
          node_total_hourly_cost{
            %(clusterLabel)s="$cluster",
            job=~"$job"
          }
        ) by (instance_type) * 730
      )
    ||| % $._config,

    local openCostInstanceTypeCostPieChartPanel =
      pieChartPanel.new(
        'Cost by Instance Type'
      ) +
      pieQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostInstanceTypeCostQuery,
        ) +
        prometheus.withLegendFormat('{{ instance_type }}') +
        prometheus.withInstant(true),
      ) +
      pieOptions.withPieType('pie') +
      pieStandardOptions.withUnit('currencyUSD') +
      pieOptions.legend.withAsTable(true) +
      pieOptions.legend.withPlacement('right') +
      pieOptions.legend.withDisplayMode('table') +
      pieOptions.legend.withValues(['value', 'percent']) +
      pieOptions.legend.withSortDesc(true),

    local openCostNodeTotalCostQuery = |||
      sum(
        node_total_hourly_cost{
          %(clusterLabel)s="$cluster",
          job=~"$job"
        }
      ) by (node, instance_type, arch)
      * 730
    ||| % $._config,

    local openCostNodeTable =
      tablePanel.new(
        'Nodes Monthly Cost',
      ) +
      tbStandardOptions.withUnit('currencyUSD') +
      tbOptions.withSortBy(
        tbOptions.sortBy.withDisplayName('Total Cost') +
        tbOptions.sortBy.withDesc(true)
      ) +
      tbOptions.footer.withEnablePagination(true) +
      tbQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostNodeMonthlyCpuCostQuery,
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
          prometheus.new(
            '$datasource',
            openCostNodeMonthlyRamCostQuery,
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
          prometheus.new(
            '$datasource',
            openCostNodeTotalCostQuery,
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
        ]
      ) +
      tbQueryOptions.withTransformations([
        tbQueryOptions.transformation.withId(
          'merge'
        ),
        tbQueryOptions.transformation.withId(
          'organize'
        ) +
        tbQueryOptions.transformation.withOptions(
          {
            renameByName: {
              node: 'Node',
              instance_type: 'Instance Type',
              arch: 'Architecture',
              'Value #A': 'CPU Cost',
              'Value #B': 'RAM Cost',
              'Value #C': 'Total Cost',
            },
            indexByName: {
              node: 0,
              instance_type: 1,
              arch: 2,
              'Value #A': 3,
              'Value #B': 4,
              'Value #C': 5,
            },
            excludeByName: {
              Time: true,
              job: true,
            },
          }
        ),
      ]),

    local openCostPVTotalGibQuery = |||
      sum(
        kube_persistentvolume_capacity_bytes{
          %(clusterLabel)s="$cluster",
          job=~"$job"
        }
        / 1024 / 1024 / 1024
      ) by (persistentvolume)
    ||| % $._config,

    local openCostPVMonthlyCostQuery = |||
      sum(
        kube_persistentvolume_capacity_bytes{
          %(clusterLabel)s="$cluster",
          job=~"$job"
        }
        / 1024 / 1024 / 1024
      ) by (persistentvolume)
      *
      sum(
        pv_hourly_cost{
          %(clusterLabel)s="$cluster",
          job=~"$job"
        }
        * 730
      ) by (persistentvolume)
    ||| % $._config,

    local openCostPVTable =
      tablePanel.new(
        'Persistent Volumes Monthly Cost'
      ) +
      tbStandardOptions.withUnit('decgbytes') +
      tbOptions.withSortBy(
        tbOptions.sortBy.withDisplayName('Total Cost') +
        tbOptions.sortBy.withDesc(true)
      ) +
      tbOptions.footer.withEnablePagination(true) +
      tbQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostPVTotalGibQuery,
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
          prometheus.new(
            '$datasource',
            openCostPVMonthlyCostQuery,
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
        ]
      ) +
      tbQueryOptions.withTransformations([
        tbQueryOptions.transformation.withId(
          'merge'
        ),
        tbQueryOptions.transformation.withId(
          'organize'
        ) +
        tbQueryOptions.transformation.withOptions(
          {
            renameByName: {
              persistentvolume: 'Persistent Volume',
              'Value #A': 'Total GiB',
              'Value #B': 'Total Cost',
            },
            indexByName: {
              persistentvolume: 0,
              'Value #A': 1,
              'Value #B': 2,
            },
            excludeByName: {
              Time: true,
              job: true,
            },
          }
        ),
      ]) +
      tbStandardOptions.withOverrides([
        tbOverride.byName.new('Total Cost') +
        tbOverride.byName.withPropertiesFromOptions(
          tbStandardOptions.withUnit('currencyUSD')
        ),
      ]),

    local openCostNamespaceMonthlyCostQueryOffset7d = std.strReplace(openCostNamespaceMonthlyCostQuery, 'job=~"$job"}', 'job=~"$job"} offset 7d'),
    local openCostNamespaceMonthlyCostQueryOffset30d = std.strReplace(openCostNamespaceMonthlyCostQuery, 'job=~"$job"}', 'job=~"$job"} offset 30d'),

    local openCostNamespaceTable =
      tablePanel.new(
        'Namespace Monthly Cost',
      ) +
      tbStandardOptions.withUnit('currencyUSD') +
      tbStandardOptions.thresholds.withSteps([
        tbStandardOptions.threshold.step.withValue(0) +
        tbStandardOptions.threshold.step.withColor('green'),
        tbStandardOptions.threshold.step.withValue(5) +
        tbStandardOptions.threshold.step.withColor('yellow'),
        tbStandardOptions.threshold.step.withValue(10) +
        tbStandardOptions.threshold.step.withColor('red'),
      ]) +
      tbOptions.withSortBy(
        tbOptions.sortBy.withDisplayName('Total Cost (Today)') +
        tbOptions.sortBy.withDesc(true)
      ) +
      tbOptions.footer.withEnablePagination(true) +
      tbQueryOptions.withTargets(
        [
          prometheus.new(
            '$datasource',
            openCostNamespaceMonthlyCostQuery,
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
          prometheus.new(
            '$datasource',
            |||
              %s
              /
              %s
              * 100
              - 100
            ||| % [
              openCostNamespaceMonthlyCostQuery,
              openCostNamespaceMonthlyCostQueryOffset7d,
            ],
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
          prometheus.new(
            '$datasource',
            |||
              %s
              /
              %s
              * 100
              - 100
            ||| % [
              openCostNamespaceMonthlyCostQuery,
              openCostNamespaceMonthlyCostQueryOffset30d,
            ],
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
        ]
      ) +
      tbQueryOptions.withTransformations([
        tbQueryOptions.transformation.withId(
          'merge'
        ),
        tbQueryOptions.transformation.withId(
          'organize'
        ) +
        tbQueryOptions.transformation.withOptions(
          {
            renameByName: {
              namespace: 'Namespace',
              'Value #A': 'Total Cost (Today)',
              'Value #B': 'Cost Difference (7d)',
              'Value #C': 'Cost Difference (30d)',
            },
            indexByName: {
              namespace: 0,
              'Value #A': 1,
              'Value #B': 2,
              'Value #C': 3,
            },
            excludeByName: {
              Time: true,
              job: true,
            },
          }
        ),
      ]) +
      tbStandardOptions.withOverrides([
        tbOverride.byName.new('Cost Difference (7d)') +
        tbOverride.byName.withPropertiesFromOptions(
          tbStandardOptions.withUnit('percent') +
          tbFieldConfig.defaults.custom.withCellOptions(
            { type: 'color-background' }  // TODO(adinhodovic): Use jsonnet lib
          ) +
          tbStandardOptions.color.withMode('thresholds')
        ),
        tbOverride.byName.new('Cost Difference (30d)') +
        tbOverride.byName.withPropertiesFromOptions(
          tbStandardOptions.withUnit('percent') +
          tbFieldConfig.defaults.custom.withCellOptions(
            { type: 'color-background' }  // TODO(adinhodovic): Use jsonnet lib
          ) +
          tbStandardOptions.color.withMode('thresholds')
        ),
      ]) +
      tbStandardOptions.withOverrides([
        tbOverride.byName.new('Namespace') +
        tbOverride.byName.withPropertiesFromOptions(
          tbStandardOptions.withLinks(
            tbPanelOptions.link.withTitle('Go To Namespace') +
            tbPanelOptions.link.withType('dashboard') +
            tbPanelOptions.link.withUrl(
              '/d/%s/opencost-namespace?var-job=$job&var-namespace=${__data.fields.Namespace}' % $._config.openCostNamespaceDashboardUid
            ) +
            tbPanelOptions.link.withTargetBlank(true)
          )
        ),
      ]),

    local openCostClusterSummaryRow =
      row.new(
        title='Cluster Summary',
      ),

    local openCostCloudResourcesRow =
      row.new(
        title='Cloud Resources',
      ),

    local openCostNamespaceSummaryRow =
      row.new(
        title='Namespace Summary',
      ),

    'opencost-mixin-overview.json':
      $._config.bypassDashboardValidation +
      dashboard.new(
        'OpenCost / Overview',
      ) +
      dashboard.withDescription('A dashboard that monitors OpenCost and focuses on giving a overview for OpenCost. It is created using the [opencost-mixin](https://github.com/adinhodovic/opencost-mixin).') +
      dashboard.withUid($._config.openCostOverviewDashboardUid) +
      dashboard.withTags($._config.tags) +
      dashboard.withTimezone('utc') +
      dashboard.withEditable(true) +
      dashboard.time.withFrom('now-2d') +
      dashboard.time.withTo('now') +
      dashboard.withVariables(variables) +
      dashboard.withLinks(
        [
          dashboard.link.dashboards.new('OpenCost', $._config.tags) +
          dashboard.link.link.options.withTargetBlank(true),
        ]
      ) +
      dashboard.withPanels(
        [
          openCostClusterSummaryRow +
          row.gridPos.withX(0) +
          row.gridPos.withY(0) +
          row.gridPos.withW(24) +
          row.gridPos.withH(1),
        ] +
        grid.makeGrid(
          [
            openCostHourlyCostStatPanel,
            openCostDailyCostStatPanel,
            openCostMonthlyCostStatPanel,
            openCostMonthlyCpuCostStatPanel,
            openCostMonthlyRamCostStatPanel,
            openCostMonthlyPVCostStatPanel,
          ],
          panelWidth=4,
          panelHeight=3,
          startY=1
        ) +
        grid.makeGrid(
          [
            openCostHourlyCostTimeSeriesPanel,
            openCostDailyCostTimeSeriesPanel,
            openCostMonthlyCostTimeSeriesPanel,
          ],
          panelWidth=8,
          panelHeight=5,
          startY=5
        ) +
        grid.makeGrid(
          [
            openCostResourceCostPieChartPanel,
            openCostNamespaceCostPieChartPanel,
            openCostInstanceTypeCostPieChartPanel,
          ],
          panelWidth=8,
          panelHeight=5,
          startY=10
        ) +
        grid.makeGrid(
          [
            openCostTotalCostVarianceTimeSeriesPanel,
            openCostResourceCostVarianceTimeSeriesPanel,
          ],
          panelWidth=12,
          panelHeight=5,
          startY=15
        ) +
        [
          openCostCloudResourcesRow +
          row.gridPos.withX(0) +
          row.gridPos.withY(20) +
          row.gridPos.withW(24) +
          row.gridPos.withH(1),
        ] +
        [
          openCostNodeTable +
          tablePanel.gridPos.withX(0) +
          tablePanel.gridPos.withY(21) +
          tablePanel.gridPos.withW(16) +
          tablePanel.gridPos.withH(10),
          openCostPVTable +
          tablePanel.gridPos.withX(16) +
          tablePanel.gridPos.withY(21) +
          tablePanel.gridPos.withW(8) +
          tablePanel.gridPos.withH(10),
          openCostNamespaceSummaryRow +
          row.gridPos.withX(0) +
          row.gridPos.withY(31) +
          row.gridPos.withW(24) +
          row.gridPos.withH(1),
          openCostNamespaceTable +
          tablePanel.gridPos.withX(0) +
          tablePanel.gridPos.withY(32) +
          tablePanel.gridPos.withW(24) +
          tablePanel.gridPos.withH(12),
        ]
      ) +
      if $._config.annotation.enabled then
        dashboard.withAnnotations($._config.customAnnotation)
      else {},
  },
}
