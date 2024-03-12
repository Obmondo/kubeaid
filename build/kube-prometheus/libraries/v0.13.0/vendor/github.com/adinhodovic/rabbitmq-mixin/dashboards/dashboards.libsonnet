local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local statPanel = grafana.statPanel;

{
  grafanaDashboards+:: {

    local prometheusTemplate =
      template.datasource(
        'datasource',
        'prometheus',
        'Prometheus',
        hide='',
      ),

    local namespaceTemplate =
      template.new(
        name='namespace',
        label='Namespace',
        datasource='$datasource',
        query='label_values(rabbitmq_identity_info, namespace)',
        current='',
        hide='',
        refresh=1,
        multi=false,
        includeAll=false,
        sort=1
      ),

    local clusterTemplate =
      template.new(
        name='rabbitmq_cluster',
        label='Cluster',
        datasource='$datasource',
        query='label_values(rabbitmq_identity_info{namespace="$namespace"}, rabbitmq_cluster)',
        current='',
        hide='',
        refresh=1,
        multi=true,
        includeAll=true,
        sort=1
      ),

    local vhostTemplate =
      template.new(
        name='vhost',
        label='Virtual Host',
        datasource='$datasource',
        query='label_values(rabbitmq_queue_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"}, vhost)',
        current='',
        hide='',
        refresh=1,
        multi=true,
        includeAll=true,
        sort=1
      ),

    local queueTemplate =
      template.new(
        name='queue',
        label='Queue',
        datasource='$datasource',
        query='label_values(rabbitmq_queue_info{vhost=~"$vhost", rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"}, queue)',
        current='',
        hide='',
        refresh=1,
        multi=true,
        includeAll=true,
        sort=1
      ),

    local queueDashboardTemplates = [
      prometheusTemplate,
      namespaceTemplate,
      clusterTemplate,
      vhostTemplate,
      queueTemplate,
    ],

    // Overview
    local overViewRow =
      row.new(
        title='Overview'
      ),

    local queueCountQuery = |||
      count(rabbitmq_detailed_queue_consumers{vhost=~"$vhost"}
      * on(instance) group_left(rabbitmq_cluster) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"})
    ||| % $._config,
    local queueCountStatPanel =
      statPanel.new(
        'Queues',
        datasource='$datasource',
        unit='short',
        reducerFunction='last',
        noValue='0'
      )
      .addTarget(prometheus.target(queueCountQuery))
      .addThresholds([
        { color: 'red', value: 0 },
        { color: 'green', value: 0.1 },
      ]),

    local queuesWithReadyMessagesCountQuery = |||
      count(rabbitmq_detailed_queue_messages_ready{vhost=~"$vhost"}
      * on(instance) group_left(rabbitmq_cluster) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"} > 0)
    ||| % $._config,
    local queuesWithReadyMessagesCountStatPanel =
      statPanel.new(
        'Queues with Messages Ready',
        datasource='$datasource',
        reducerFunction='last',
        noValue='0'
      )
      .addTarget(prometheus.target(queuesWithReadyMessagesCountQuery))
      .addThresholds([
        { color: 'green', value: 0 },
        { color: 'yellow', value: 0.1 },
      ]),

    local queuesWithUnackedMessagesCountQuery = |||
      count(rabbitmq_detailed_queue_messages_unacked{vhost=~"$vhost"}
      * on(instance) group_left(rabbitmq_cluster) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"} > 0)
    ||| % $._config,
    local queuesWithUnackedMessagesCountStatPanel =
      statPanel.new(
        'Queues with Messages Unacked',
        datasource='$datasource',
        reducerFunction='last',
        noValue='0'
      )
      .addTarget(prometheus.target(queuesWithUnackedMessagesCountQuery))
      .addThresholds([
        { color: 'green', value: 0 },
        { color: 'red', value: 0.1 },
      ]),

    // Virtual Host
    local vhostRow =
      row.new(
        title='Virtual Host Overview'
      ),

    local vhostMessagesReadyQuery = |||
      sum(
        increase(
          rabbitmq_detailed_queue_messages_ready{namespace="$namespace", vhost=~"$vhost"}[$__rate_interval]
        )
      ) by (instance, vhost)
      * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"}
    ||| % $._config,
    local vhostMessagesUnackedQuery = |||
      sum(
        increase(
          rabbitmq_detailed_queue_messages_unacked{namespace="$namespace", vhost=~"$vhost"}[$__rate_interval]
        )
      ) by (instance, vhost)
      * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"}
    ||| % $._config,
    local vhostMessagesReadyUnackedGraphPanel =
      graphPanel.new(
        'Virtual Host Ready & Unacked Messages',
        datasource='$datasource',
        format='short',
        fill='0',
        linewidth='3',
        legend_show=true,
        legend_values=true,
        legend_alignAsTable=true,
        legend_rightSide=true,
        legend_avg=true,
        legend_max=true,
        legend_hideZero=false,
      )
      .addTarget(
        prometheus.target(
          vhostMessagesReadyQuery,
          legendFormat='Ready - {{ vhost }}',
        )
      )
      .addTarget(
        prometheus.target(
          vhostMessagesUnackedQuery,
          legendFormat='Unacked - {{ vhost }}',
        )
      ),

    // Queue
    local queueRow =
      row.new(
        title='Queue Overview'
      ),

    // Table
    local queueConsumersQuery = |||
      sum by (instance, vhost, queue) (rabbitmq_detailed_queue_consumers{vhost=~"$vhost", namespace="$namespace", queue=~"$queue"})
      * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"}
    ||| % $._config,
    local queueMessagesQuery = std.strReplace(queueConsumersQuery, 'rabbitmq_detailed_queue_consumers', 'rabbitmq_detailed_queue_messages'),

    local queueLengthConsumersTable =
      grafana.tablePanel.new(
        'Queue Length & Consumers',
        datasource='$datasource',
        sort={
          col: 1,
          desc: false,
        },
        styles=[
          {
            alias: 'Time',
            dateFormat: 'YYYY-MM-DD HH:mm:ss',
            type: 'hidden',
            pattern: 'Time',
          },
          {
            pattern: 'rabbitmq_cluster',
            type: 'hidden',
          },
          {
            pattern: 'instance',
            type: 'hidden',
          },
          {
            pattern: 'rabbitmq_node',
            type: 'hidden',
          },
          {
            pattern: 'namespace',
            type: 'hidden',
          },
          {
            alias: 'Queue',
            pattern: 'queue',
          },
          {
            alias: 'Virtual Host',
            pattern: 'vhost',
          },
          {
            alias: 'Consumers',
            pattern: 'Value #A',
            type: 'number',
            unit: 'short',
          },
          {
            alias: 'Queue Length',
            pattern: 'Value #B',
            type: 'number',
            unit: 'short',
          },
        ]
      )
      .addTarget(prometheus.target(queueConsumersQuery, format='table', instant=true))
      .addTarget(prometheus.target(queueMessagesQuery, format='table', instant=true)),

    local queueMessagesReadyQuery = |||
      sum(
        increase(
          rabbitmq_detailed_queue_messages_ready{namespace="$namespace", vhost=~"$vhost", queue=~"$queue"}[$__rate_interval]
        )
      ) by (instance, vhost, queue)
      * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"}
    ||| % $._config,
    local queueMessagesUnackedQuery = |||
      sum(
        increase(
          rabbitmq_detailed_queue_messages_unacked{namespace="$namespace", vhost=~"$vhost", queue=~"$queue"}[$__rate_interval]
        )
      ) by (instance, vhost, queue)
      * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) rabbitmq_identity_info{rabbitmq_cluster=~"$rabbitmq_cluster", namespace="$namespace"}
    ||| % $._config,
    local queueMessagesReadyUnackedGraphPanel =
      graphPanel.new(
        'Queue Ready & Unacked Messages',
        datasource='$datasource',
        format='short',
        fill='0',
        linewidth='3',
        legend_show=true,
        legend_values=true,
        legend_alignAsTable=true,
        legend_rightSide=true,
        legend_avg=true,
        legend_max=true,
        legend_hideZero=false,
      )
      .addTarget(
        prometheus.target(
          queueMessagesReadyQuery,
          legendFormat='Ready - {{ queue }}/{{ vhost }}',
        )
      )
      .addTarget(
        prometheus.target(
          queueMessagesUnackedQuery,
          legendFormat='Unacked - {{ queue }}/{{ vhost }}',
        )
      ),

    'rabbitmq-queue.json':
      // Queue dashboard
      dashboard.new(
        'RabbitMQ / Queue',
        description='A dashboard that monitors RabbitMQ. It is created using the (rabbitmq-mixin)[https://github.com/adinhodovic/rabbitmq-mixin].',
        uid=$._config.queueDashboardUid,
        tags=$._config.tags,
        time_from='now-6h',
        time_to='now',
        editable='true',
        timezone='utc'
      )
      .addPanel(overViewRow, gridPos={ h: 1, w: 24, x: 0, y: 0 })
      .addPanel(queueCountStatPanel, gridPos={ h: 4, w: 8, x: 0, y: 1 })
      .addPanel(queuesWithReadyMessagesCountStatPanel, gridPos={ h: 4, w: 8, x: 8, y: 1 })
      .addPanel(queuesWithUnackedMessagesCountStatPanel, gridPos={ h: 4, w: 8, x: 16, y: 1 })
      .addPanel(vhostRow, gridPos={ h: 1, w: 24, x: 0, y: 5 })
      .addPanel(vhostMessagesReadyUnackedGraphPanel, gridPos={ h: 6, w: 24, x: 0, y: 6 })
      .addPanel(queueRow, gridPos={ h: 1, w: 24, x: 0, y: 12 })
      .addPanel(queueLengthConsumersTable, gridPos={ h: 8, w: 24, x: 0, y: 13 })
      .addPanel(queueMessagesReadyUnackedGraphPanel, gridPos={ h: 8, w: 24, x: 0, y: 21 })
      + { templating+: { list+: queueDashboardTemplates } },
  },
}
