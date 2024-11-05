{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'kubernetes-version-info',
        rules: [
          {
            alert: 'KubernetesVersionInfoEOS',
            expr: 'count by (certname, current_version, end_of_support_date) (kubernetes_version_info_eos <= 30 and kubernetes_version_info_eos > 0)',
            'for': '15m',
            labels: {
              severity: 'warning',
              alert_id: 'KubernetesVersionInfoEOS',
            },
            annotations: {
              description: 'The Kubernetes version on the cluster **{{ .Labels.certname }}** (that is version **{{ .Labels.current_version }}**) is **{{ .Value }}** days away from its end of support date which is **{{ .Labels.end_of_support_date }}**. You really should upgrade to ensure you will still get security updates. Please visit https://kubernetes.io/releases/patch-releases/ for more version related information.',
              summary: 'Kubernetes version is close to end of support',
            },
          },
          {
            alert: 'KubernetesVersionInfoEOS',
            expr: 'count by (certname, current_version, end_of_support_date) (kubernetes_version_info_eos < 0 )',
            'for': '15m',
            labels: {
              severity: 'critical',
              alert_id: 'KubernetesVersionInfoEOS',
            },
            annotations: {
              description: 'The Kubernetes version on the cluster **{{ .Labels.certname }}** (that is version **{{ .Labels.current_version }}**) reached its end of support date on **{{ .Labels.end_of_support_date }}**. You really should upgrade to ensure you will still get security updates. Please visit https://kubernetes.io/releases/patch-releases/ for more version related information.',
              summary: 'Kubernetes version has reached its end of support',
            },
          },
          {
            alert: 'KubernetesVersionInfoEOL',
            expr: 'count by (certname, current_version, end_of_life_date) (kubernetes_version_info_eol <= 60 and kubernetes_version_info_eol > 0)',
            'for': '15m',
            labels: {
              severity: 'warning',
              alert_id: 'KubernetesVersionInfoEOL',
            },
            annotations: {
              description: 'The Kubernetes version on the cluster **{{ .Labels.certname }}** (that is version **{{ .Labels.current_version }}**) is **{{ .Value }}** days away from its end of life date which is **{{ .Labels.end_of_life_date }}**. You really should upgrade soon. Please visit https://kubernetes.io/releases/patch-releases/ for more version related information.',
              summary: 'Kubernetes version is close to end of life',
            },
          },
          {
            alert: 'KubernetesVersionInfoEOL',
            expr: 'count by (certname, current_version, end_of_life_date) (kubernetes_version_info_eol < 0)',
            'for': '15m',
            labels: {
              severity: 'critical',
              alert_id: 'KubernetesVersionInfoEOL',
            },
            annotations: {
              description: 'The Kubernetes version on the cluster **{{ .Labels.certname }}** (that is version **{{ .Labels.current_version }}**) reached its end of life on **{{ .Labels.end_of_life_date }}**. It is now vital to upgrade. Please visit https://kubernetes.io/releases/patch-releases/ for more version related information.',
              summary: 'Kubernetes version has reached its end of life',
            },
          },
        ],
      },
    ],
  },
}
