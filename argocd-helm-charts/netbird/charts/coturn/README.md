# coturn

![Version: 9.1.0](https://img.shields.io/badge/Version-9.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.7.0](https://img.shields.io/badge/AppVersion-4.7.0-informational?style=flat-square)

A Helm chart to deploy coturn

**Homepage:** <https://github.com/small-hack/coturn-chart>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| jessebot | <jessebot@linux.com> | <https://github.com/jessebot/> |

## Source Code

* <https://github.com/small-hack/coturn-chart>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | mysql | 13.0.1 |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.7.10 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| certificate.enabled | bool | `false` | Enables auto issuing certificates over cert-manager certificates https://cert-manager.io/docs/concepts/certificate/ |
| certificate.issuerName | string | `"letsencrypt-staging"` | name of cert-manager issuer to use for cert generation. change to production issuer when you're stable |
| certificate.secret | string | `"turn-tls"` | name of secret to create for ssl cert |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` | allow priviledged access |
| containerSecurityContext.capabilities.add | list | `["NET_BIND_SERVICE"]` | linux cabilities to allow for the coturn k8s pod |
| containerSecurityContext.capabilities.drop | list | `["ALL"]` | linux cabilities to disallow for the coturn k8s pod |
| containerSecurityContext.enabled | bool | `true` | Enables Security Context |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` | allow modificatin to root filesystem |
| coturn.auth.existingSecret | string | `""` | existing secret with keys username/password for coturn |
| coturn.auth.password | string | `""` | password for the main user of the turn server |
| coturn.auth.secretKeys.password | string | `"password"` | key in existing secret for turn server user's password |
| coturn.auth.secretKeys.username | string | `"username"` | key in existing secret for turn server user |
| coturn.auth.username | string | `"coturn"` | username for the main user of the turn server |
| coturn.extraTurnserverConfiguration | string | `"verbose\n"` | extra configuration for turnserver.conf |
| coturn.initContainer.image.repository | string | `"mikefarah/yq"` | registry and repository for init container config generator image |
| coturn.initContainer.image.tag | string | `"latest"` | tag for init container config generator image |
| coturn.listeningIP | string | `"0.0.0.0"` | coturn's listening IP address |
| coturn.logFile | string | `"stdout"` | set the logfile. Defaults to stdout for use with kubectl logs |
| coturn.ports.listening | int | `3478` | insecure listening port |
| coturn.ports.max | int | `65535` | maximum ephemeral port for coturn |
| coturn.ports.min | int | `49152` | minimum ephemeral port for coturn |
| coturn.ports.tlsListening | int | `5349` | secure listening port |
| coturn.realm | string | `"turn.example.com"` | hostname for the coturn server realm |
| externalDatabase.database | string | `""` | database to create, ignored if existingSecret is passed in |
| externalDatabase.enabled | bool | `false` | enables the use of postgresql instead of the default sqlite to use the bundled subchart, enable this, and postgresql.enable |
| externalDatabase.existingSecret | string | `""` | name of existing Secret to use for postgresql credentials |
| externalDatabase.hostname | string | `""` | required if externalDatabase.enabled: true and postgresql.enabled: false |
| externalDatabase.image.repository | string | `""` | container registry and repo for database readiness docker image |
| externalDatabase.image.tag | string | `""` | container tag for coturn database readiness docker image |
| externalDatabase.password | string | `""` | password for database, ignored if existingSecret is passed in |
| externalDatabase.secretKeys.database | string | `""` | key in existing Secret to use for the database name |
| externalDatabase.secretKeys.hostname | string | `""` | key in existing Secret to use for the db's hostname |
| externalDatabase.secretKeys.password | string | `""` | key in existing Secret to use for db user's password |
| externalDatabase.secretKeys.username | string | `""` | key in existing Secret to use for the db user |
| externalDatabase.type | string | `"postgresql"` | Currently postgresql and mysql are supported. |
| externalDatabase.username | string | `""` | username for database, ignored if existingSecret is passed in |
| image.pullPolicy | string | `"IfNotPresent"` | image pull policy, set to Always if using image.tag: latest |
| image.repository | string | `"coturn/coturn"` | container registry and repo for coturn docker image |
| image.tag | string | `""` | docker tag for coturn server |
| labels | object | `{"component":"coturn"}` | Coturn specific labels |
| mysql.auth.database | string | `"coturn"` | database to create, ignored if existingSecret is passed in |
| mysql.auth.existingSecret | string | `""` | Use existing secret for password details. The secret has to contain the keys mysql-root-password, mysql-replication-password and mysql-password |
| mysql.auth.password | string | `""` | password for db, autogenerated if empty & existingSecret empty |
| mysql.auth.secretKeys.password | string | `"password"` | key in existing Secret to use for coturn user's password |
| mysql.auth.secretKeys.username | string | `"username"` | key in exsiting Secret to use for the coturn user |
| mysql.auth.username | string | `"coturn"` | username for database, ignored if existingSecret is passed in |
| mysql.enabled | bool | `false` | enables bitnami mysql subchart, you can disable to use external db |
| mysql.initdbScriptsConfigMap | string | `"initdb-scripts-config"` | ConfigMap with the initdb scripts (Note: Overrides initdbScripts) |
| nameOverride | string | `""` | different name for the helm release |
| podSecurityContext.enabled | bool | `true` | Enables Pod Security Context |
| podSecurityContext.fsGroup | int | `1000` | all processes of the container are also part of the supplementary groupID |
| podSecurityContext.runAsGroup | int | `1000` | for all Containers in the Pod, all processes run w/ this GroupID |
| podSecurityContext.runAsNonRoot | bool | `true` | for all Containers in the Pod, all processes run as non-root |
| podSecurityContext.runAsUser | int | `1000` | for all Containers in the Pod, all processes run w/ this userID |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | Filter a process's system calls |
| postgresql.enabled | bool | `false` | enables bitnami postgresql subchart, you can disable to use external db |
| postgresql.global.postgresql.auth.database | string | `"coturn"` | database to create, ignored if existingSecret is passed in |
| postgresql.global.postgresql.auth.existingSecret | string | `""` | name of existing Secret to use for postgresql credentials |
| postgresql.global.postgresql.auth.password | string | `""` | password for db, autogenerated if empty & existingSecret empty |
| postgresql.global.postgresql.auth.secretKeys.adminPasswordKey | string | `"postgresPassword"` | key in existing Secret to use for postgres admin user's password |
| postgresql.global.postgresql.auth.secretKeys.database | string | `"database"` | key in existingSecret for database to create |
| postgresql.global.postgresql.auth.secretKeys.hostname | string | `"hostname"` | key in existingSecret for database to create |
| postgresql.global.postgresql.auth.secretKeys.userPasswordKey | string | `"password"` | key in existing Secret to use for coturn user's password |
| postgresql.global.postgresql.auth.secretKeys.username | string | `"username"` | key in exsiting Secret to use for the coturn user |
| postgresql.global.postgresql.auth.username | string | `"coturn"` | username for database, ignored if existingSecret is passed in |
| postgresql.primary.initdb.scriptsConfigMap | string | `""` | ConfigMap with scripts to be run at first boot |
| replicas | int | `1` |  |
| resources | object | `{}` | ref: kubernetes.io/docs/concepts/configuration/manage-resources-containers |
| service.externalTrafficPolicy | string | `""` | I don't actually know what this is 🤔 open a PR if you know    was originally "Local" |
| service.type | string | `"ClusterIP"` | The type of service to deploy for routing Coturn traffic.   ClusterIP: Recommended for DaemonSet configurations. This will create a              standard Kubernetes service for Coturn within the cluster.              No external networking will be configured as the DaemonSet              will handle binding to each Node's host networking    NodePort:  Recommended for Deployment configurations. This will open              TURN ports on every node and route traffic on these ports to              the Coturn pods. You will need to make sure your cloud              provider supports the cluster config setting,              apiserver.service-node-port-range, as this range must contain              the ports defined above for the service to be created.    LoadBalancer: This was what was originally set for this chart in the                 upstream of this fork, but with no details |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
