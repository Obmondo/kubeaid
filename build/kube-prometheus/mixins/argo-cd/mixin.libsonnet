{
  _config+:: {
    selector: '',
  },

  prometheusAlerts+:: {
    groups+: [
      {
        name: 'argocd-sync-state',
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
              description: 'The application **{{ .Labels.argocd_application_name }}**/**{{ .Labels.application_namespace }}** has been out of sync for more than 30 minutes.',
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
              description: 'Argo CD WhiteListed Application **{{ .Labels.argocd_application_name }}**/**{{ .Labels.application_namespace }}** sync failed.',
              summary: 'The application**{{ .Labels.argocd_application_name }}**/**{{ .Labels.application_namespace }}** has been out of sync for more than 15 minutes.',
            },
          },
          // Inspiration from here https://github.com/adinhodovic/argo-cd-mixin/blob/main/alerts/alerts.libsonnet
          {
            alert: 'ArgoCdAppOutOfSync',
            expr: 'sum by (job, dest_server, project, sync_status) (argocd_app_info{job=~".*",sync_status!="Synced"}) >= 1',
            labels: {
              severity: 'warning',
            },
            'for': '15m',
            annotations: {
              summary: 'ArgoCD Application is Out Of Sync.',
              description: 'Multiple application under {{ .Labels.project }} is out of sync with the sync status {{ .Labels.sync_status }} for the past 15m',
            },
          },
          {
            alert: 'ArgoCdAppUnhealthy',
            expr: 'sum by (job, project, dest_server, health_status) (argocd_app_info{health_status!~"Healthy|Progressing"}) >= 1',
            labels: {
              severity: 'warning',
            },
            'for': '15m',
            annotations: {
              summary: 'ArgoCD Application is not healthy.',
              description: 'Multiple application under {{ .Labels.project }} is not healthy with the health status {{ .Labels.health_status }} for the past 15m',
            },
          },
        ],
      },
    ],
  },
}
