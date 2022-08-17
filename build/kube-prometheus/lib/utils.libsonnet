{
  ingress(name, namespace, rules, tls, annotations):: {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: name,
      namespace: namespace,
      annotations: annotations,
    },
    spec: {
      rules: rules,
      [if tls != null then 'tls']: tls,
    },
  },

}
