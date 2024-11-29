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
      datasource.generalOptions.withLabel('Data source'),

    local jobVariable =
      query.new(
        'job',
        'label_values(opencost_build_info, job)'
      ) +
      query.withDatasourceFromVariable(datasourceVariable) +
      query.withSort(1) +
      query.generalOptions.withLabel('Job') +
      query.refresh.onLoad() +
      query.refresh.onTime(),

    local namespaceVariable =
      query.new(
        'namespace',
        'label_values(kube_namespace_labels, namespace)'
      ) +
      query.withDatasourceFromVariable(datasourceVariable) +
      query.withSort(1) +
      query.generalOptions.withLabel('Namespace') +
      query.refresh.onLoad() +
      query.refresh.onTime(),

    local variables = [
      datasourceVariable,
      jobVariable,
      namespaceVariable,
    ],

    local openCostHourlyCostQuery = |||
      sum(
        sum(
          container_memory_allocation_bytes{job=~"$job", namespace=~"$namespace"}
        )
        by (namespace, instance)
        * on(instance) group_left() (
          node_ram_hourly_cost{job=~"$job"}
          / 1024 / 1024 / 1024 * 1
          + on(node,instance_type) group_left()
          label_replace
          (
            kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
          ) * 0
        )
        +
        sum(
          container_cpu_allocation{job=~"$job", namespace=~"$namespace"}
        )
        by (namespace,instance)
        * on(instance) group_left() (
          node_cpu_hourly_cost{job=~"$job"}
          * 1
          + on(node, instance_type) group_left()
          label_replace
          (
            kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
          ) * 0
        )
      ) by (namespace)
    |||,

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


    local openCostDailyCostQuery = std.strReplace(openCostHourlyCostQuery, '* 1', '* 24'),

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

    local openCostMonthlyCostQuery = std.strReplace(openCostHourlyCostQuery, '* 1', '* 730'),

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
          container_memory_allocation_bytes{job=~"$job", namespace=~"$namespace"}
        )
        by (namespace, instance)
        * on(instance) group_left() (
          node_ram_hourly_cost{job=~"$job"}
          / 1024 / 1024 / 1024 * 730
          + on(node,instance_type) group_left()
          label_replace
          (
            kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
          ) * 0
        )
      )
    |||,

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
          container_cpu_allocation{job=~"$job", namespace=~"$namespace"}
        )
        by (namespace,instance)
        * on(instance) group_left() (
          node_cpu_hourly_cost{job=~"$job"}
          * 730
          + on(node, instance_type) group_left()
          label_replace
          (
            kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
          ) * 0
        )
      )
    |||,

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
          kube_persistentvolume_capacity_bytes{job=~"$job"}
          / 1024 / 1024 / 1024
        ) by (persistentvolume)
        *
        sum(
          pv_hourly_cost{job=~"$job"}
        ) by (persistentvolume)
        * on(persistentvolume) group_left(namespace) (
          label_replace(
            kube_persistentvolumeclaim_info{job=~"$job", namespace=~"$namespace"},
            "persistentvolume", "$1", "volumename", "(.*)"
          )
        )
      ) * 730
    |||,

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

    local openCostPodMonthlyCostQuery = |||
      topk(10,
        sum(
          sum(container_memory_allocation_bytes{namespace=~"$namespace", job=~"$job"}) by (instance, pod)
          * on(instance) group_left() (
            node_ram_hourly_cost{job=~"$job"} / 1024 / 1024 / 1024 * 730
            + on(node, instance_type) group_left()
            label_replace
            (
              kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
            ) * 0
          )
          +
          sum(container_cpu_allocation{namespace=~"$namespace", job=~"$job"}) by (instance, pod)
          * on(instance) group_left() (
            node_cpu_hourly_cost{job=~"$job"} * 730
            + on(node,instance_type) group_left()
            label_replace
            (
              kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
            ) * 0
          )
        ) by (pod)
      )
    |||,

    local openCostPodMonthlyCostQueryOffset7d = std.strReplace(openCostPodMonthlyCostQuery, 'job=~"$job"}', 'job=~"$job"} offset 7d'),
    local openCostPodMonthlyCostQueryOffset30d = std.strReplace(openCostPodMonthlyCostQuery, 'job=~"$job"}', 'job=~"$job"} offset 30d'),

    local openCostPodTable =
      tablePanel.new(
        'Pod Monthly Cost',
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
            openCostPodMonthlyCostQuery,
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
              openCostPodMonthlyCostQuery,
              openCostPodMonthlyCostQueryOffset7d,
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
              openCostPodMonthlyCostQuery,
              openCostPodMonthlyCostQueryOffset30d,
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
              pod: 'Pod',
              'Value #A': 'Total Cost (Today)',
              'Value #B': 'Cost Difference (7d)',
              'Value #C': 'Cost Difference (30d)',
            },
            indexByName: {
              pod: 0,
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
      ]),

    local openCostPodCostPieChartPanel =
      pieChartPanel.new(
        'Cost by Pod'
      ) +
      pieQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostPodMonthlyCostQuery,
        ) +
        prometheus.withLegendFormat('{{ pod }}') +
        prometheus.withInstant(true),
      ) +
      pieOptions.withPieType('pie') +
      pieStandardOptions.withUnit('currencyUSD') +
      pieOptions.legend.withAsTable(true) +
      pieOptions.legend.withPlacement('right') +
      pieOptions.legend.withDisplayMode('table') +
      pieOptions.legend.withValues(['value', 'percent']) +
      pieOptions.legend.withSortDesc(true),

    local openCostContainerMonthlyCostQuery = |||
      topk(10,
        sum(
          sum(container_memory_allocation_bytes{namespace=~"$namespace", job=~"$job"}) by (instance, container)
          * on(instance) group_left() (
            node_ram_hourly_cost{job=~"$job"} / 1024 / 1024 / 1024 * 730
            + on(node, instance_type) group_left()
            label_replace
            (
              kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
            ) * 0
          )
          +
          sum(container_cpu_allocation{namespace=~"$namespace", job=~"$job"}) by (instance, container)
          * on(instance) group_left() (
            node_cpu_hourly_cost{job=~"$job"} * 730
            + on(node, instance_type) group_left()
            label_replace
            (
              kube_node_labels{job=~"$job"}, "instance_type", "$1", "label_node_kubernetes_io_instance_type", "(.*)"
            ) * 0
          )
        ) by (container)
      )
    |||,

    local openCostContainerMonthlyCostQueryOffset7d = std.strReplace(openCostContainerMonthlyCostQuery, 'job=~"$job"}', 'job=~"$job"} offset 7d'),
    local openCostContainerMonthlyCostQueryOffset30d = std.strReplace(openCostContainerMonthlyCostQuery, 'job=~"$job"}', 'job=~"$job"} offset 30d'),

    local openCostContainerTable =
      tablePanel.new(
        'Container Monthly Cost',
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
            openCostContainerMonthlyCostQuery,
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
              openCostContainerMonthlyCostQuery,
              openCostContainerMonthlyCostQueryOffset7d,
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
              openCostContainerMonthlyCostQuery,
              openCostContainerMonthlyCostQueryOffset30d,
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
              container: 'Container',
              'Value #A': 'Total Cost (Today)',
              'Value #B': 'Cost Difference (7d)',
              'Value #C': 'Cost Difference (30d)',
            },
            indexByName: {
              container: 0,
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
      ]),

    local openCostContainerCostPieChartPanel =
      pieChartPanel.new(
        'Cost by Container'
      ) +
      pieQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostContainerMonthlyCostQuery,
        ) +
        prometheus.withLegendFormat('{{ container }}') +
        prometheus.withInstant(true),
      ) +
      pieOptions.withPieType('pie') +
      pieStandardOptions.withUnit('currencyUSD') +
      pieOptions.legend.withAsTable(true) +
      pieOptions.legend.withPlacement('right') +
      pieOptions.legend.withDisplayMode('table') +
      pieOptions.legend.withValues(['value', 'percent']) +
      pieOptions.legend.withSortDesc(true),

    local openCostPVTotalGibByPvQuery = |||
      sum(
        kube_persistentvolume_capacity_bytes{job=~"$job"}
        / 1024 / 1024 / 1024
      ) by (persistentvolume)
      * on(persistentvolume) group_left(namespace) (
        label_replace(
          kube_persistentvolumeclaim_info{job=~"$job", namespace=~"$namespace"},
          "persistentvolume", "$1", "volumename", "(.*)"
        )
      )
    |||,

    local openCostPVMonthlyCostByPvQuery = std.strReplace(openCostMonthlyPVCostQuery, '* 730', 'by (persistentvolume) * 730'),

    local openCostPvTable =
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
            openCostPVTotalGibByPvQuery,
          ) +
          prometheus.withInstant(true) +
          prometheus.withFormat('table'),
          prometheus.new(
            '$datasource',
            openCostPVMonthlyCostByPvQuery,
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
              namespace: true,
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

    local openCostPvCostPieChartPanel =
      pieChartPanel.new(
        'Cost by PV'
      ) +
      pieQueryOptions.withTargets(
        prometheus.new(
          '$datasource',
          openCostPVMonthlyCostByPvQuery,
        ) +
        prometheus.withLegendFormat('{{ persistentvolume }}') +
        prometheus.withInstant(true),
      ) +
      pieOptions.withPieType('pie') +
      pieStandardOptions.withUnit('currencyUSD') +
      pieOptions.legend.withAsTable(true) +
      pieOptions.legend.withPlacement('right') +
      pieOptions.legend.withDisplayMode('table') +
      pieOptions.legend.withValues(['value', 'percent']) +
      pieOptions.legend.withSortDesc(true),

    local openCostSummaryRow =
      row.new(
        title=' Summary',
      ),

    local openCostPodRow =
      row.new(
        title='Pod Summary',
      ),

    local openCostContainerRow =
      row.new(
        title='Container Summary',
      ),

    local openCostPvRow =
      row.new(
        title='PV Summary',
      ),

    'opencost-mixin-namespace.json':
      $._config.bypassDashboardValidation +
      dashboard.new(
        'OpenCost / Namespace',
      ) +
      dashboard.withDescription('A dashboard that monitors OpenCost and focuses on namespace costs. It is created using the [opencost-mixin](https://github.com/adinhodovic/opencost-mixin).') +
      dashboard.withUid($._config.openCostNamespaceDashboardUid) +
      dashboard.withTags($._config.tags) +
      dashboard.withTimezone('utc') +
      dashboard.withEditable(true) +
      dashboard.time.withFrom('now-7d') +
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
          openCostSummaryRow +
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
        [
          openCostDailyCostTimeSeriesPanel +
          timeSeriesPanel.gridPos.withX(0) +
          timeSeriesPanel.gridPos.withY(4) +
          timeSeriesPanel.gridPos.withW(9) +
          timeSeriesPanel.gridPos.withH(5),
          openCostMonthlyCostTimeSeriesPanel +
          timeSeriesPanel.gridPos.withX(9) +
          timeSeriesPanel.gridPos.withY(4) +
          timeSeriesPanel.gridPos.withW(9) +
          timeSeriesPanel.gridPos.withH(5),
          openCostResourceCostPieChartPanel +
          pieChartPanel.gridPos.withX(18) +
          pieChartPanel.gridPos.withY(4) +
          pieChartPanel.gridPos.withW(6) +
          pieChartPanel.gridPos.withH(5),
        ] +
        [
          openCostPodRow +
          row.gridPos.withX(0) +
          row.gridPos.withY(9) +
          row.gridPos.withW(24) +
          row.gridPos.withH(1),
          openCostPodTable +
          tablePanel.gridPos.withX(0) +
          tablePanel.gridPos.withY(10) +
          tablePanel.gridPos.withW(18) +
          tablePanel.gridPos.withH(10),
          openCostPodCostPieChartPanel +
          pieChartPanel.gridPos.withX(18) +
          pieChartPanel.gridPos.withY(10) +
          pieChartPanel.gridPos.withW(6) +
          pieChartPanel.gridPos.withH(10),
        ] +
        [
          openCostContainerRow +
          row.gridPos.withX(0) +
          row.gridPos.withY(20) +
          row.gridPos.withW(24) +
          row.gridPos.withH(1),
          openCostContainerTable +
          tablePanel.gridPos.withX(0) +
          tablePanel.gridPos.withY(21) +
          tablePanel.gridPos.withW(18) +
          tablePanel.gridPos.withH(10),
          openCostContainerCostPieChartPanel +
          pieChartPanel.gridPos.withX(18) +
          pieChartPanel.gridPos.withY(21) +
          pieChartPanel.gridPos.withW(6) +
          pieChartPanel.gridPos.withH(10),
        ] +
        [
          openCostPvRow +
          row.gridPos.withX(0) +
          row.gridPos.withY(31) +
          row.gridPos.withW(24) +
          row.gridPos.withH(1),
          openCostPvTable +
          tablePanel.gridPos.withX(0) +
          tablePanel.gridPos.withY(32) +
          tablePanel.gridPos.withW(18) +
          tablePanel.gridPos.withH(10),
          openCostPvCostPieChartPanel +
          pieChartPanel.gridPos.withX(18) +
          pieChartPanel.gridPos.withY(32) +
          pieChartPanel.gridPos.withW(6) +
          pieChartPanel.gridPos.withH(10),
        ]
      ) +
      if $._config.annotation.enabled then
        dashboard.withAnnotations($._config.customAnnotation)
      else {},
  },
}
