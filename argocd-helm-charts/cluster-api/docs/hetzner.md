# Syself Hetzner CAPH (Robot + Cloud)

## Background

* CCM (Cloud Controller Manager) from syself which talks to Hetzner api

* CAPH (Cluster API Provider Hetzner) which will takecare of node lifecycle (which it does via above CCM)

* Syself has developed CAPH which works with hetzner robot, the official only supported the cloud.
  But good news is that syself changes are merged into official
  [here is the PR](https://github.com/hetznercloud/hcloud-cloud-controller-manager/pull/561/)

  **NOTE** The official ccm didn't worked for me, so currently we are using ccm from syself (v1.18.0-0.0.5)

* This ccm-hetzner helm chart will setup both for you in same NS

  **NOTE** charts/cluster-api-provider-hetzner is manually maintained based on this [file](https://github.com/syself/cluster-api-provider-hetzner/releases/download/v1.0.0-beta.33/infrastructure-components.yaml)

## Pre-Requisites

* Create webservice user on Hetzner Goto [Settings](https://robot.hetzner.com/preferences/index) and
  follow more instruction
  [here](https://github.com/syself/cluster-api-provider-hetzner/blob/main/docs/topics/preparation.md#preparing-hetzner-robot)

* Generate API Token [here](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/)

## Setup

* Setup required envs

  ```sh
  #!/bin/bash

  export HCLOUD_SSH_KEY="cluster" \
  export CLUSTER_NAME="kcm.obmondo.com" \
  export HCLOUD_TOKEN="xxx" \
  export HETZNER_ROBOT_USER="xxx" \
  export HETZNER_ROBOT_PASSWORD="xxx" \
  export HETZNER_SSH_PUB_PATH= "/home/foo/.ssh/robot_id_rsa.pub" \
  export HETZNER_SSH_PRIV_PATH="/home/foo/.ssh/robot_id_rsa"
  ```

* Install clusterapi

  ```sh
  clusterctl init --core cluster-api --bootstrap kubeadm --control-plane kubeadm --infrastructure hetzner # pinned to v1.0.0-beta.33
  ```

* Create required secrets

  ```sh
  kubectl -n caph-system create secret generic hetzner --dry-run=client --from-literal=hcloud=$HCLOUD_TOKEN --from-literal=robot-user=$HETZNER_ROBOT_USER --from-literal=robot-password=$HETZNER_ROBOT_PASSWORD -o yaml | kubeseal --controller-name sealed-secrets --controller-namespace system -o yaml > hetzner.yaml

   kubectl create secret generic robot-ssh --dry-run=client -n capi-system --from-literal=sshkey-name=cluster --from-file=ssh-privatekey=$HETZNER_SSH_PRIV_PATH --from-file=ssh-publickey=$HETZNER_SSH_PUB_PATH -o yaml | kubeseal --controller-name sealed-secrets --controller-namespace system -o yaml > robot-ssh.yaml
  ```

* Generate argocd application using one of the [examples](./examples/argocd-application.yaml)

* Added a value file as show in this [example](./examples/hetzner-robot-control-plane.yaml) Sync it in argocd (sync root app and then the actual application **dev-capi-hetzner**)

## Improvements

* It's strictly binded to caph-system namespace for now and runs on v1.0.0-beta.33 [added support in helm chart]

## Troubleshootings

* Node will be restart again and again, simply delete the machine from cluster, for forcefull, remove the finalizers

* SSH failed even after successfull installation, it seems it reboot twice (haven't confirmed)
  but it comes up eventually, if manual ssh works.

* Some more detail that I faced [here](https://github.com/syself/cluster-api-provider-hetzner/issues/252)

## Guide

[Quickstart](https://github.com/syself/cluster-api-provider-hetzner/blob/main/docs/topics/quickstart.md)