{
  prometheusRules+:: {
    groups+: [
      {
        name: 'rabbitmq.rules',
        rules: [
          {
            record: 'rabbitmq_queue_info',
            expr: |||
              rabbitmq_detailed_queue_consumers * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) max(rabbitmq_identity_info) by (rabbitmq_cluster, instance, rabbitmq_node)
            ||| % $._config,
          },
        ],
      },
    ],
  },
}
