{
  _config+:: {
    // Selectors are inserted between {} in Prometheus queries.
    rabbitmqSelector: 'job="rabbitmq"',
    grafanaUrl: 'https://grafana.com',
    queueDashboardUid: 'rabbitmq-queue-12mk4klgjweg',
    tags: ['rabbitmq', 'rabbitmq-mixin'],
    queueMessageThreshold: 100,
    deadLetterQueueName: 'dlx',
  },
}
