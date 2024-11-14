# Self Hosted LinuxAid Monitoring (servers + vms) on Kubernetes

## Requirements

NOTE: This is already present - if your cluster is managed by KubeAid, as its part of the KubeAid monitoring setup (kube-prometheus).

* Need prometheus-operator and grafana-operator to be installed and running

## Deployments

* The value file only needs the customer-id and rest everything is fine, unless we want to change anything
  and all the settings are for all the customer, we can fix this easily with helm logics

## Dashboards

* The dashboard are copied over from upstream from these sources and are on latest master/main

node exporter: https://github.com/rfmoz/grafana-dashboards/blob/master/prometheus/node-exporter-full.json
haproxy: https://github.com/rfmoz/grafana-dashboards/blob/master/prometheus/haproxy-2-full.json
docker: https://gitea.obmondo.com/EnableIT/puppet/src/commit/e7f4b744f150345eebc2335929bfc6d6344276f9/envs/production/modules/include/customers/files/enableit/monitoring-stack/grafana/dashboards/obmondo_docker_dashboard.json
postgres: https://grafana.com/oss/prometheus/exporters/postgres-exporter/?tab=dashboards
mysql: https://github.com/percona/grafana-dashboards/blob/main/dashboards/MySQL/MySQL_Query_Response_Time_Details.json

* The dashboard are added as (gzipJson](https://grafana.github.io/grafana-operator/docs/examples/dashboard_gzipped/readme/)

  * WHY ? helm template consider some dashboard function as templateble
    and tries to parse it and fails, and yaml string `| or >` didn't worked for me.

  ```sh
  # cat /tmp/dashboard.json | gzip | base64 -w0
  # cat /tmp/posgres.json | gzip | base64 -w0 | xclip -selection clipboard -i
  ```

## TODO

* fail if no customer-id is given
* validate dashboard maybe ?
* allow customer to add their own dashboard (this is should be top prio)
* promtool rule validate
* grafana pvc is not supported https://github.com/grafana/grafana-operator/issues/296
* grafana resource as well, the crd seems to be little broken when grafana guys migrated from v4 to v5


## How to test new rule
```sh
cd argocd-helm-charts/prometheus-linuxaid

docker run -ti --rm -v $(pwd):/etc/prometheus/:ro --entrypoint /bin/promtool prom/prometheus test rules /etc/prometheus/tests/${NEW_RULE}.yaml
```
