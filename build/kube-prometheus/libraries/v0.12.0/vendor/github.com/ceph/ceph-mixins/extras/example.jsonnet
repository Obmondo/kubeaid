local kp = (import 'operator/jsonnet/kube-prometheus.libsonnet') + {
  _config+:: {
    namespace: 'default',
  },
};

{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) }
