local kp = (import 'operator/jsonnet/kube-prometheus-external.libsonnet') + {
  _config+:: {
    namespace: 'default',
  },
};

{ ['prometheus-' + name + '-external']: kp.prometheus[name] for name in std.objectFields(kp.prometheus) }
