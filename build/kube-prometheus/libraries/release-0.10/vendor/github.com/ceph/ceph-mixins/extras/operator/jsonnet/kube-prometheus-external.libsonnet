local k = import 'ksonnet/ksonnet.beta.3/k.libsonnet';
local configMapList = k.core.v1.configMapList;

(import 'prometheus.libsonnet') +
(import 'ceph-mixins/mixin-external.libsonnet') + {
  kubePrometheus+:: {
    namespace: k.core.v1.namespace.new($._config.namespace),
    name: 'prometheus-ceph-rules-external',
  },
} + {
  _config+:: {
    namespace: 'default',

    prometheus+:: {
      rules: $.prometheusAlerts,
    },
  },
}
