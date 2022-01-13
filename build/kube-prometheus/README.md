# kube-prometheus build

I have added the `kube-prometheus` that contains the `build.sh`,
`example.jsonnet` and `obmondo.jsonnet` (with our config).

For the Makefile, run `make setup` to install `jb`, initialize it and fetch the
`build.sh`, vendor and other files, although they have been created in the
`kube-prometheus` folder. `make build` compiles the manifests

The command `./build.sh example.jsonnet` when run, will build the manifest
(YAML) files. `obmondo.jsonnet` is where our config is being added to the
default one. A `./build.sh obmondo.jsonnet` should build it but it isn't
reflecting yet, still working on it.

Any ideas/suggestions are welcomed...

## Running

```sh
./build.sh htzhel1-kbm
```

Example:

```log
$ ./build.sh htzhel1-kbm
INFO: 'libraries/release-0.10/vendor' doesn't exist; executing jsonnet-bundler
GET https://github.com/prometheus-operator/kube-prometheus/archive/42ea595d60265b803ad460a971a7186488f6be7e.tar.gz 200
GET https://github.com/thanos-io/thanos/archive/fb97c9a5ef51849ccb7960abbeb9581ad7f511b9.tar.gz 200
GET https://github.com/prometheus-operator/prometheus-operator/archive/d8ba1c766a141cb35072ae2f2578ec8588c9efcd.tar.gz 200
GET https://github.com/kubernetes-monitoring/kubernetes-mixin/archive/b538a10c89508f8d12885680cca72a134d3127f5.tar.gz 200
GET https://github.com/kubernetes/kube-state-metrics/archive/e080c3ce73ad514254e38dccb37c93bec6b257ae.tar.gz 200
GET https://github.com/kubernetes/kube-state-metrics/archive/e080c3ce73ad514254e38dccb37c93bec6b257ae.tar.gz 200
GET https://github.com/prometheus/prometheus/archive/41f1a8125e664985dd30674e5bdf6b683eff5d32.tar.gz 200
GET https://github.com/prometheus/alertmanager/archive/16fa045db47d68a09a102c7b80b8899c1f57c153.tar.gz 200
GET https://github.com/brancz/kubernetes-grafana/archive/199e363523104ff8b3a12483a4e3eca86372b078.tar.gz 200
GET https://github.com/etcd-io/etcd/archive/7291ed3c4ae7ba61df72e7b610d6c351f995a3db.tar.gz 200
GET https://github.com/prometheus-operator/prometheus-operator/archive/d8ba1c766a141cb35072ae2f2578ec8588c9efcd.tar.gz 200
GET https://github.com/prometheus/node_exporter/archive/a2321e7b940ddcff26873612bccdf7cd4c42b6b6.tar.gz 200
GET https://github.com/grafana/grafonnet-lib/archive/3626fc4dc2326931c530861ac5bebe39444f6cbf.tar.gz 200
GET https://github.com/grafana/jsonnet-libs/archive/b46355107c024e0aa4932adadd939294c3b8260d.tar.gz 200
GET https://github.com/kubernetes-monitoring/kubernetes-mixin/archive/3346c8cbcc1660caeddf2ffc9443dabe583e1a35.tar.gz 200
INFO: compiling jsonnet files into 'htzhel1-kbm'
```

## Upgrading

```sh
make update
```

## Cleaning up

```sh
rm -rf libraries/release-0.10/
```
