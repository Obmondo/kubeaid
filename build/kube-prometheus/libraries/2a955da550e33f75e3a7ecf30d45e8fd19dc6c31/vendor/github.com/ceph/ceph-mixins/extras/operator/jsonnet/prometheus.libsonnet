local k = import 'ksonnet/ksonnet.beta.3/k.libsonnet';

{
  _config+:: {
    namespace: 'default',

    prometheus+:: {
      name: 'k8s',
      rules: {},
      renderedRules: {},
      namespaces: $._config.namespace,
    },
  },
  prometheus+:: {
    [if $._config.prometheus.rules != null && $._config.prometheus.rules != {} then 'rules']:
      {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'PrometheusRule',
        metadata: {
          labels: {
            prometheus: $._config.prometheus.name,
            role: 'alert-rules',
          },
          name: 'prometheus-ceph-rules',
          namespace: $._config.namespace,
        },
        spec: {
          groups: $._config.prometheus.rules.groups,
        },
      },
  },
}
