## Prerequisites
* Jsonnet [[Install Jsonnet]](https://github.com/google/jsonnet#building-jsonnet)

   [Jsonnet](https://jsonnet.org/learning/getting_started.html) is a data templating language for app and tool developers.

   The mixin project uses Jsonnet to provide reusable and configurable configs for Grafana Dashboards and Prometheus Alerts.
* Jsonnet-bundler [[Install Jsonnet-bundler]](https://github.com/jsonnet-bundler/jsonnet-bundler#install)

   [Jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler) is a package manager for jsonnet.
*  gojsontoyaml

   `$ go get github.com/brancz/gojsontoyaml`

## How to generate manifests?
1. `$ git clone https://github.com/ceph/ceph-mixins.git`
2. `$ cd ceph-mixins/extras`
3. `$ jb install`
4. `$ ./build.sh example.jsonnet`

Generated files are in `manifests` directory.

## How to apply manifests?
* In K8s cluster,

  `$ kubectl create -f manifests/ || true`

* In OC cluster,

  `$ oc create -f manifests/ || true`

## How to teardown?

* In K8s cluster,

  `$ kubectl delete -f manifests/ || true`

* In OC cluster,

  `$ oc delete -f manifests/ || true`
