{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ArgoCDApplicationAlerts',
        rules: [
          {
            alert: 'WhiteListedApplicationOutOfSync',
            expr: 'argocd_application_sync_state{argocd_application_name!="", application_namespace!="", whitelisted="true", result="waiting"} == 1',
            'for': '30m',
            labels: {
              severity: 'critical',
              alert_id: 'WhiteListedApplicationOutOfSync',
            },
            annotations: {
              description: 'The application **{{ Labels.argocd_application_name }}**/**{{ Labels.application_namespace }}** has been out of sync for more than 30 minutes.',
              summary: 'Kubernetes version is close to end of support',
            },
          },
          {
            alert: 'CronSyncFailed',
            expr: 'argocd_application_sync_state{argocd_application_name!="", application_namespace!="", whitelisted="true", result="failed"} == 1',
            'for': '15m',
            labels: {
              severity: 'critical',
              alert_id: 'CronSyncFailed',
            },
            annotations: {
              description: 'ArgoCD WhiteListed Application **{{ Labels.argocd_application_name }}**/**{{ Labels.application_namespace }}** sync failed.',
              summary: 'The application**{{ Labels.argocd_application_name }}**/**{{ Labels.application_namespace }}** has been out of sync for more than 15 minutes.',
            },
          },
        ],
      },
    ],
  },
}
