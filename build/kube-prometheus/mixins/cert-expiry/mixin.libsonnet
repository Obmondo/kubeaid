{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'cert-expiry',
        rules: [
          {
            alert: 'KubeletClientCertificateExpiration',
            expr: 'kubelet_certificate_manager_client_ttl_seconds < (max_over_time(kubelet_certificate_manager_client_ttl_seconds[15d]) * 0.05)',
            labels: {
              severity: 'critical',
              alert_id: 'KubeletClientCertificateExpiration',
            },
            annotations: {
              summary: 'Kubelet client certificate is about to expire',
              description: 'Client certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}',
            },
          },
          {
            alert: 'KubeletServerCertificateExpiration',
            expr: 'kubelet_certificate_manager_server_ttl_seconds < (max_over_time(kubelet_certificate_manager_server_ttl_seconds[15d]) * 0.05)',
            labels: {
              severity: 'critical',
              alert_id: 'KubeletServerCertificateExpiration',
            },
            annotations: {
              summary: 'Kubelet server certificate is about to expire',
              description: 'Server certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}',
            },
          },
        ],
      },
    ],
  },
}
