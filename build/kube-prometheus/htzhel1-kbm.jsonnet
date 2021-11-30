local ingress(name, namespace, rules, tls) = {
  apiVersion: 'networking.k8s.io/v1',
  kind: 'Ingress',
  metadata: {
    name: name,
    namespace: namespace,
    annotations: {
      'cert-manager.io/cluster-issuer': 'letsencrypt',
      'kubernetes.io/ingress.class': 'traefik-cert-manager',
    },
  },
  spec: { 
    rules: rules,
    [if tls!=null then 'tls']: tls,
  },
};

local kp =
  (import 'kube-prometheus/main.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  
  {
    values+:: {
      common+: {
        platform: 'kubeadm',
      },
    },
  } +  
  {
    values+:: {
      common+: {
        namespace: 'monitoring',
      },
      alertmanager+: {
        config: importstr 'alertmanager-config.yaml',
      },
      "prometheusOperator"+: {
        resources: {
          limits: { cpu: '100m', memory: '80Mi' },
          requests: { cpu: '10m', memory: '30Mi' },
        },
      },
      grafana+:{
        config+: {
            sections: {
              date_formats: { default_timezone: 'UTC' },
              "auth": {
                "disable_login_form": true,
                "oauth_auto_login": true,
                "disable_signout_menu": false,
                "signout_redirect_url": "https://keycloak.kbm.obmondo.com/auth/realms/devops/protocol/openid-connect/logout?redirect_uri=https://grafana.kbm.obmondo.com"
              },
              "analytics": {
                "check_for_updates": false
              },
              "server": {
                "root_url": "https://grafana.kbm.obmondo.com"
              },
              "auth.generic_oauth": {
                "enabled": true,
                "allow_sign_up": true,
                "scopes": "openid profile email",
                "name": "Keycloak",
                "auth_url": "https://keycloak.kbm.obmondo.com/auth/realms/devops/protocol/openid-connect/auth",
                "token_url": "https://keycloak.kbm.obmondo.com/auth/realms/devops/protocol/openid-connect/token",
                "api_url": "https://keycloak.kbm.obmondo.com/auth/realms/devops/protocol/openid-connect/userinfo",
                "client_id": "grafana",
                "role_attribute_path": "contains(not_null(roles[*],''), 'Admin') && 'Admin' || contains(not_null(roles[*],''), 'Editor') && 'Editor' || contains(not_null(roles[*],''), 'Viewer') && 'Viewer'|| ''"

            }
          } 
        }
      }
    },

    ingress+:: {
      grafana: ingress(
        'grafana',
        $.values.common.namespace,
        [{
          host: 'grafana.kbm.obmondo.com',
          http: {
            paths: [{
              path: '/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: 'grafana',
                  port: {
                    name: 'http',
                  },
                },
              },
            }],
          },
        }],
        [{
          secretName: 'kube-prometheus-grafana-tls',
          hosts: [
            'grafana.kbm.obmondo.com'
          ]
        }]
      ),
    },

    alertmanager+: {
      alertmanager+: {
        spec+: {
          "resources": {
            "limits": {
              "cpu" : "100m",
              "memory": "50Mi"
            },
            "requests": {
              "cpu": "10m",
              "memory": "20Mi"
            }
          },
          logLevel: 'debug',  // So firing alerts show up in log
          "useExistingSecret": true,
          "secrets": [
            "obmondo-clientcert"
          ]
        },
      },
    },
    prometheus+:: {
      prometheus+: {
        spec+: { 
          "resources": {
            "limits": {
              "memory": "1Gi"
            },
            "requests": {
              "cpu": "100m",
              "memory": "200Mi"
            }
          }, 
          storage: {  
            volumeClaimTemplate: { 
              apiVersion: 'v1',
              kind: 'PersistentVolumeClaim',
              spec: {
                accessModes: ['ReadWriteOnce'],
                resources: { requests: { storage: '10Gi' } },
                storageClassName: 'rook-ceph-block',
              },
            },
          },  
        },  
      },
    },
  };

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) }
{ [name + '-ingress']: kp.ingress[name] for name in std.objectFields(kp.ingress) }
