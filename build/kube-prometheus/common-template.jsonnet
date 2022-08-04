local utils = import 'lib/utils.libsonnet';
local addMixin = (import 'lib/addmixin.libsonnet');

local remove_nulls = (
  function(arr)
    std.filter((function(o) o != null), arr)
);

local ext_vars = std.extVar('vars');

local default_vars = {
  //TODO: add these namespace automatically based on the mixins is enabled
  prometheus_scrape_namespaces: [
    'argocd',
    'velero',
    'sealedsecrets',
    'cert-manager',
    'etcd',
  ],
  prometheus_operator_resources: {
    limits: { cpu: '100m', memory: '80Mi' },
    requests: { cpu: '10m', memory: '30Mi' },
  },
  alertmanager_resources: {
    limits: { cpu: '100m', memory: '50Mi' },
    requests: { cpu: '20m', memory: '30Mi' },
  },
  prometheus_resources: {
    limits: { memory: '3Gi' },
    requests: { cpu: '200m', memory: '1500Mi' },
  },
  node_exporter_resources: {
    limits: { cpu: '500m', memory: '180Mi' },
    requests: { cpu: '102m', memory: '180Mi' },
  },

  kube_state_metrics_kubeRbacProxyMain_resources: {
    limits: { cpu: '320m', memory: '40Mi' },
    requests: { cpu: '20m', memory: '20Mi' },
  },

  kube_state_metrics_kubeRbacProxySelf_resources: {
    limits: { cpu: '80m', memory: '40Mi' },
    requests: { cpu: '10m', memory: '20Mi' },
  },

  grafana_keycloak_enable: false,
  addMixins: {
    ceph: true,
    sealedsecrets: true,
    etcd: true,
    velero: false,
    certmanager: true,
  },
  mixin_configs: {
    // Example:
    //
    // velero+: {
    //   selector: 'schedule=~"^ops.+"',
    // },
  },
};

local vars = default_vars + ext_vars;

local mixins = remove_nulls([
  addMixin(
    'ceph',
    (import 'github.com/ceph/ceph-mixins/mixin.libsonnet'),
    vars,
  ),
  addMixin(
    'sealedsecrets',
    (import 'github.com/bitnami-labs/sealed-secrets/contrib/prometheus-mixin/mixin.libsonnet'),
    vars,
  ),
  addMixin(
    'etcd',
    (import 'github.com/etcd-io/etcd/contrib/mixin/mixin.libsonnet'),
    vars,
  ),
  addMixin(
    'velero',
    (import 'mixins/velero/mixin.libsonnet'),
    vars,
  ),
  addMixin(
    'certmanager',
    (import 'gitlab.com/uneeq-oss/cert-manager-mixin/mixin.libsonnet'),
    vars,
  ),
]);

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
        platform: vars.platform,
      },
    },
  } +
  {
    values+:: {
      // This is ONLY supported in release-0.11+ and main
      kubeStateMetrics+: {
        kubeRbacProxyMain+: {
          resources+: vars.kube_state_metrics_kubeRbacProxyMain_resources,
        },
        kubeRbacProxySelf+: {
          resources+: vars.kube_state_metrics_kubeRbacProxySelf_resources,
        },
      },

      common+: {
        namespace: 'monitoring',
      },
      prometheus+: {
        namespaces+: vars.prometheus_scrape_namespaces,
      },
      prometheusOperator+: {
        resources: vars.prometheus_operator_resources,
      },
      nodeExporter+: {
        resources: vars.node_exporter_resources,
      },
    },
  } + (
    if vars.extra_configs then
      {
        values+:: {
          grafana+: {
            config+: {
              sections: {
                date_formats: { default_timezone: 'UTC' },
                auth: {
                  disable_login_form: false,
                  // oauth_auto_login: true,
                  disable_signout_menu: false,
                  signout_redirect_url: vars.grafana_signout_redirect_url,
                },
                analytics: {
                  check_for_updates: false,
                },
                server: {
                  root_url: vars.grafana_root_url,
                },
              } + (
                if vars.grafana_keycloak_enable then
                  {
                    'auth.generic_oauth': {
                      enabled: true,
                      allow_sign_up: true,
                      scopes: 'openid profile email',
                      name: 'Keycloak',
                      auth_url: vars.grafana_auth_url,
                      token_url: vars.grafana_token_url,
                      api_url: vars.grafana_api_url,
                      client_id: 'grafana',
                      role_attribute_path: "contains(not_null(roles[*],''), 'Admin') && 'Admin' || contains(not_null(roles[*],''), 'Editor') && 'Editor' || contains(not_null(roles[*],''), 'Viewer') && 'Viewer'|| ''",

                    },
                  }
                else {}
              ),
            },
          },
        },

        prometheus+:: {
          prometheus+: {
            spec+: {
              replicas: 1,
              resources: vars.prometheus_resources,
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
      } else {}
  )
  + (
    if std.objectHas(vars, 'connect_obmondo') && vars.connect_obmondo then
      {
        alertmanager+: {
          secret:: {},
          alertmanager+: {
            spec+: {
              replicas: 1,
              resources: vars.alertmanager_resources,
              logLevel: 'debug',  // So firing alerts show up in log
              secrets: ['obmondo-clientcert'],
            },
          },
        },
      }
    else {}
  )
  + (
    if std.objectHas(vars, 'grafana_ingress_host') then
      {
        ingress+:: {
          grafana: utils.ingress(
            'grafana',
            $.values.common.namespace,
            [{
              host: vars.grafana_ingress_host,
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
                vars.grafana_ingress_host,
              ],
            }]
          ),
        },
      } else {}
  );

{
  'setup/0namespace-namespace': kp.kubePrometheus.namespace +
                                ({
                                   metadata+: {
                                     labels:
                                       { monitoring: 'kube-prometheus-stack' },
                                   },
                                 }),
} +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
(if vars['blackbox-exporter'] then { ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } else {}) +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) } +
// Ordering matters! This next absurd object **has** to come after the inclusion
// of `kubernetesControlPlane` above -- otherwise we'll overwrite the object and
// remove our filtering.
{ 'kubernetes-prometheusRule': kp.kubernetesControlPlane.prometheusRule {
  spec+: {
    groups: std.filter((
              function(o)
                std.objectHas(o, 'rules') && o.name != 'kubernetes-system-apiserver'
            ), kp.kubernetesControlPlane.prometheusRule.spec.groups)
            +
            [{
              name: 'kubernetes-system-apiserver',
              rules:
                std.filter(
                  (
                    function(o)
                      std.objectHas(o, 'alert') &&
                      o.alert != 'KubeClientCertificateExpiration'
                  ),
                  std.filter((
                    function(o)
                      std.objectHas(o, 'rules') && o.name == 'kubernetes-system-apiserver'
                  ), kp.kubernetesControlPlane.prometheusRule.spec.groups)[0].rules
                ),
            }],
  },
} } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
(if std.objectHas(vars, 'grafana_ingress_host') then { [name + '-ingress']: kp.ingress[name] for name in std.objectFields(kp.ingress) } else {})
// Rendering prometheusRules object. This is an object compatible with prometheus-operator CRD definition for prometheusRule
+ { [o._config.name + '-prometheus-rules']: o.prometheusRules for o in std.filter((function(o) o.prometheusRules != null), mixins) }
