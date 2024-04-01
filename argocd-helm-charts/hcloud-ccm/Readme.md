# Hcloud + Syself Hetzner CAPI (Robot + Cloud)

## Background

* Syself has developed capi which works with hetzner robot, the official only supported the cloud. But good news is that syself changes are merged into official [here is the PR](https://github.com/hetznercloud/hcloud-cloud-controller-manager/pull/561/)

* CCM (Cloud Controller Manager) an official from Hetzner which talks to hetzner api
* CAPI (Hetzner Provider) which will takecare of node lifecycle (which it does via above CCM)
* This hcloud-ccm helm chart will setup both for you in same NS

## Pre-Requisites

* Create webservice user on Hetzner Goto [Settings](https://robot.hetzner.com/preferences/index) and follow more instruction [here](https://github.com/syself/cluster-api-provider-hetzner/blob/main/docs/topics/preparation.md#preparing-hetzner-robot)

* Generate API Token [here](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/)

## Setup

1. Setup required envs
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

2. Create required secrets
  ```sh
  kubectl -n caph-system create secret generic hetzner --dry-run=client --from-literal=hcloud=$HCLOUD_TOKEN --from-literal=robot-user=$HETZNER_ROBOT_USER --from-literal=robot-password=$HETZNER_ROBOT_PASSWORD -o yaml | kubeseal --controller-name sealed-secrets --controller-namespace system -o yaml > hetzner.yaml

   kubectl create secret generic robot-ssh --dry-run=client -n capi-system --from-literal=sshkey-name=cluster --from-file=ssh-privatekey=$HETZNER_SSH_PRIV_PATH --from-file=ssh-publickey=$HETZNER_SSH_PUB_PATH -o yaml | kubeseal --controller-name sealed-secrets --controller-namespace system -o yaml > robot-ssh.yaml
  ```

3. Generate cluster using one of the template
  ```sh
  clusterctl generate cluster kcm --target-namespace caph-system --from ./robot-control-node-only.yaml  > $CLUSTER_NAME.yaml
  ```

4. Manually deploy it via kubectly apply -f $CLUSTER_NAME.yaml

## Improvements

1. Accept values for generating cluster from value file, so move this to a helm chart and dynamically generate cluster yaml based on the value file, which is per cluster, so one can manage via argocd easily

## Troubleshootings

1. Node will be restart again and again, simply delete the machine from cluster, for forcefull, remove the finalizers

2. SSH failed even after successfull installation, it seems it reboot twice (haven't confirmed) but it comes up eventually, if manual ssh works.
