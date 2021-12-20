Example config 
```
opensearch:
  opensearchJavaOpts: "-Xms4g -Xmx4g"
  replicas: 3

  rbac:
    create: true

  # https://github.com/opensearch-project/helm-charts/pull/69/files
  majorVersion: 7

  resources:
    limits:
      memory: 6Gi
    requests:
      cpu: 200m
      memory: 4Gi

  persistence:
    enabled: true
    labels:
      enabled: false
    accessModes:
      - ReadWriteOnce
    size: 500Gi
    annotations: {}

  config:
    opensearch.yml: |
      cluster.name: opensearch-cluster
      # Bind to all interfaces because we don't know what IP address Docker will assign to us.
      network.host: 0.0.0.0
      # # minimum_master_nodes need to be explicitly set when bound on a public IP
      # # set to 1 to allow single node clusters
      # discovery.zen.minimum_master_nodes: 1
      # Setting network.host to a non-loopback address enables the annoying bootstrap checks. "Single-node" mode disables them again.
      # discovery.type: single-node
      # Start OpenSearch Security Demo Configuration
      # WARNING: revise all the lines below before you go into production
      indices.query.bool.max_clause_count: 4096

      # Report as elasticsearch 7.10 - for graylog not to complain (until v4.3 of graylog with opensearch support is released)
      compatibility.override_main_response_version: true
      
      # https://archivedocs.graylog.org/en/2.4/pages/faq.html#how-do-i-fix-the-deflector-exists-as-an-index-and-is-not-an-alias-error-message
      action.auto_create_index: false
      plugins:
        security:
          ssl:
            transport:
              pemcert_filepath: esnode.pem
              pemkey_filepath: esnode-key.pem
              pemtrustedcas_filepath: root-ca.pem
              enforce_hostname_verification: false
            http:
              enabled: false
              pemcert_filepath: esnode.pem
              pemkey_filepath: esnode-key.pem
              pemtrustedcas_filepath: root-ca.pem
          allow_unsafe_democertificates: true
          allow_default_init_securityindex: true
          authcz:
            admin_dn:
              - CN=kirk,OU=client,O=client,L=test,C=de
          audit.type: internal_opensearch
          enable_snapshot_restore_privilege: true
          check_snapshot_restore_write_privileges: true
          restapi:
            roles_enabled: ["all_access", "security_rest_api_access"]
          system_indices:
            enabled: true
            indices:
              [
                ".opendistro-alerting-config",
                ".opendistro-alerting-alert*",
                ".opendistro-anomaly-results*",
                ".opendistro-anomaly-detector*",
                ".opendistro-anomaly-checkpoints",
                ".opendistro-anomaly-detection-state",
                ".opendistro-reports-*",
                ".opendistro-notifications-*",
                ".opendistro-notebooks",
                ".opendistro-asynchronous-search-response*",
              ]

```