{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'kubernetes-eol',
        rules: [
          {
            alert: 'KubernetesVersionInfoAlert',
            expr: "kubernetes_version_info==1",
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              description: 'The Kubernetes version has reached very close to its end of life for the cluster ',
              summary: 'The Kubernetes version info metric has a value 1',
            },
          },
        ],
      },
    ],
  },
}