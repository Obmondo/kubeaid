{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'rabbitmq',
        rules: [
          {
            alert: 'RabbitmqTooManyMessagesInQueue',
            expr: |||
              sum by (rabbitmq_cluster, instance, vhost, queue) (rabbitmq_detailed_queue_messages * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) max(rabbitmq_identity_info) by (rabbitmq_cluster, instance, rabbitmq_node)) > %(queueMessageThreshold)s
            ||| % $._config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'RabbitMQ too many messages in queue.',
              description: 'More than %(queueMessageThreshold)s messages in the queue {{ $labels.rabbitmq_cluster }}/{{ $labels.vhost }}/{{ $labels.queue }} for the past 2 minutes.' % $._config,
              dashboard_url: '%(grafanaUrl)s/d/%(queueDashboardUid)s/rabbitmq-queue' % $._config,
            },
          },
          {
            alert: 'RabbitmqNoConsumer',
            expr: |||
              sum by (rabbitmq_cluster, instance, vhost, queue) (rabbitmq_detailed_queue_consumers{queue!~".*%(deadLetterQueueName)s.*"} * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) max(rabbitmq_identity_info) by (rabbitmq_cluster, instance, rabbitmq_node)) == 0
            ||| % $._config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'RabbitMQ queue has no consumers.',
              description: 'The queue {{ $labels.rabbitmq_cluster }}/{{ $labels.vhost }}/{{ $labels.queue }} has 0 consumers for the past 2 minutes.',
              dashboard_url: '%(grafanaUrl)s/d/%(queueDashboardUid)s/rabbitmq-queue' % $._config,
            },
          },
          {
            alert: 'RabbitmqUnroutableMessages',
            expr: |||
              sum by(rabbitmq_node, rabbitmq_cluster) (rate(rabbitmq_channel_messages_unroutable_dropped_total[1m]) * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) max(rabbitmq_identity_info) by (rabbitmq_cluster, instance, rabbitmq_node)) > 0 or
              sum by(rabbitmq_node, rabbitmq_cluster) (rate(rabbitmq_channel_messages_unroutable_returned_total[1m]) * on(instance) group_left(rabbitmq_cluster, rabbitmq_node) max(rabbitmq_identity_info) by (rabbitmq_cluster, instance, rabbitmq_node)) > 0
            |||,
            'for': '2m',
            labels: {
              severity: 'info',
            },
            annotations: {
              summary: 'The Rabbitmq cluster has unroutable messages.',
              description: 'The Rabbitmq cluster {{ $labels.rabbitmq_cluster }} has unroutable messages for the past 2 minutes.',
              dashboard_url: '%(grafanaUrl)s/d/%(queueDashboardUid)s/rabbitmq-queue' % $._config,
            },
          },
        ],
      },
    ],
  },
}
