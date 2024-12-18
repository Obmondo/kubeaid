## Hetzner K8s cluster via cluster-api

## Setup

```sh
kubeaid-bootstrap
```

## Improvements

* Floating IP should be automatically pointing to current working node (the first node that got provisioned) [Comlpeted]
* Add option in kubeadmcontrolplane to remove taints (its supported in crd)
