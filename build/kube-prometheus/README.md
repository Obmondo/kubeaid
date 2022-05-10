# kube-prometheus build

Use `build.sh` to build prometheus manifests for a kubernetes cluster.
See the comment at the top of `build.sh` for how to use it.

For the Makefile, run `make setup` to install `jb`, initialize it and fetch the
`build.sh`, vendor and other files, although they have been created in the
`kube-prometheus` folder. `make build` compiles the manifests

Any ideas/suggestions are welcomed...

## Running

### Install prerequisites

This installs go

```sh
snap install go
export PATH=$PATH:$(go env GOPATH)/bin
```

This installs jsonnet tooling:

```sh
go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/brancz/gojsontoyaml@latest
go install github.com/google/go-jsonnet/cmd/jsonnet@latest
```

### Run the build script

Run this in the root of the argocd-apps repo, with the k8s config repo cloned next to it

```sh
./build/kube-prometheus/build.sh ../kubernetes-config-enableit/k8s/kam.obmondo.com
```

Example:

```log
$ ./build/kube-prometheus/build.sh ../kubernetes-config-enableit/k8s/kam.obmondo.com
INFO: 'build/kube-prometheus/libraries/main/vendor' doesn't exist; executing jsonnet-bundler
GET https://github.com/prometheus-operator/kube-prometheus/archive/64b19b69d5a6d82af8bbfb3a67538b0feca31042.tar.gz 200
GET https://github.com/prometheus/alertmanager/archive/a6d10bd5bc3f651e0ca04d47b981ed66e85a09a6.tar.gz 200
GET https://github.com/thanos-io/thanos/archive/f0e673a2e4860d8cffafba4c97955171e5c6cb2b.tar.gz 200
GET https://github.com/brancz/kubernetes-grafana/archive/1c4d84de1c059b55ce83fdd76fbb4f58530b7d55.tar.gz 200
GET https://github.com/grafana/grafana/archive/8c622c1ef626a6982e0a6353877dd02313988010.tar.gz 200
GET https://github.com/prometheus-operator/prometheus-operator/archive/90e243ea91e4f332d517b0a2c190df9d5c3026a9.tar.gz 200
GET https://github.com/kubernetes/kube-state-metrics/archive/eff2c0ed6d1af04f10773e73aeae8b17f23c2409.tar.gz 200
GET https://github.com/prometheus/prometheus/archive/c7be45d957dd90e605738d8b74482e7579da0db0.tar.gz 200
GET https://github.com/etcd-io/etcd/archive/be2929568f81080b20ef6812992f2e09c8dac91b.tar.gz 200
GET https://github.com/prometheus-operator/prometheus-operator/archive/90e243ea91e4f332d517b0a2c190df9d5c3026a9.tar.gz 200
GET https://github.com/kubernetes-monitoring/kubernetes-mixin/archive/a2196d1b3493c15117550df2fd35dbdf54e4fa0e.tar.gz 200
GET https://github.com/kubernetes/kube-state-metrics/archive/eff2c0ed6d1af04f10773e73aeae8b17f23c2409.tar.gz 200
GET https://github.com/prometheus/node_exporter/archive/9aae303a46c3153b75e4d32b0936b40e4ee0beeb.tar.gz 200
GET https://github.com/kubernetes-monitoring/kubernetes-mixin/archive/a2196d1b3493c15117550df2fd35dbdf54e4fa0e.tar.gz 200
GET https://github.com/grafana/grafonnet-lib/archive/6db00c292d3a1c71661fc875f90e0ec7caa538c2.tar.gz 200
GET https://github.com/grafana/jsonnet-libs/archive/98c3060877aa178f6bdfc6ac618fbe0043fc3de7.tar.gz 200
INFO: compiling jsonnet files into '../kubernetes-config-enableit/k8s/kam.obmondo.com/kube-prometheus'
```

## Upgrading

```sh
make update
```

## Cleaning up

```sh
rm -rf libraries/release-0.10/
```

## Prometheus operator options, set in common-template.jsonnet options

Options available as part of values.alertmanager are listed in
https://github.com/prometheus-operator/kube-prometheus/blob/main/jsonnet/kube-prometheus/components/alertmanager.libsonnet#L1-L72
Additionally ALL options for Alertmanager CR listed in
https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#alertmanagerspec are available
in jsonnet as alertmanager.alertmanager.spec Alertmanager mixin options are inherited from the mixin itself and are
available in https://github.com/prometheus/alertmanager/blob/main/doc/alertmanager-mixin/config.libsonnet

## Adding new mixins

+ Install mixin into `kube-prometheus` release directories (currently manual). In the below we install it only into
  `main`, but this should be repeated for all the versions in use.

   ```sh
   cd build/kube-prometheus/libraries/main
   jb install github.com/bitnami-labs/sealed-secrets/contrib/prometheus-mixin@main
   ```

+ Add the mixin to `common-template.json`. For adding the Bitnami `sealed-secrets` mixin this diff was required:

   ```diff
   @@ -46,6 +46,7 @@ local kp =
      // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
      // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
      // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
   +  (import 'github.com/bitnami-labs/sealed-secrets/contrib/prometheus-mixin/mixin.libsonnet') +

      {
        values+:: {
   ```

  Note that the search path contains the full path of the file from the top of the `vendor` folder.

## Jsonnet debugging

You can dump an entire object to see whats actually there, by wrapping a statement in a call to [`std.trace`](https://jsonnet.org/ref/stdlib.html#trace):

```jsonnet
dashboards+: std.trace(std.toString(CephMixin), CephMixin.grafanaDashboards),
```

You can also simply output an object to a file by adding a line to the bottom of the return value in
`common-template.jsonnet`. The below will write the contents of `mixins` to the file `debug`:

```jsonnet
+ { debug: mixins }
```
