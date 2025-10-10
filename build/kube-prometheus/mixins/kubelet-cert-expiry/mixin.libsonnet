{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'kubelet-cert-expiry',
        rules: [
          {
            alert: 'KubeletClientCertExpiry',
            expr: 'kubelet_certificate_manager_client_ttl_seconds < (max_over_time(kubelet_certificate_manager_client_ttl_seconds[15d]) * 0.05)',
            labels: {
              severity: 'critical',
              alert_id: 'KubeletClientCertExpiry',
            },
            annotations: {
              summary: 'Kubelet client certificate is about to expire.',
              description: 'Client certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}',
            },
          },
          {
            alert: 'KubeletServerCertExpiry',
            expr: 'kubelet_certificate_manager_server_ttl_seconds < (max_over_time(kubelet_certificate_manager_server_ttl_seconds[15d]) * 0.05)',
            labels: {
              severity: 'critical',
              alert_id: 'KubeletServerCertExpiry',
            },
            annotations: {
              summary: 'Kubelet server certificate is about to expire.',
              description: 'Server certificate for Kubelet on node {{ $labels.node }} expires in {{ $value | humanizeDuration }}',
            },
          },
        ],
      },
    ],
  },
}