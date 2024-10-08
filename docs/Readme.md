# KubeAid Documentation

## Overview

* Configure your kubernetes cluster on Azure (AKS) or on AWS (Kops) for now
  (more cloud provider support are coming soon) with one single command.

* The cluster are private and terragrunt can also setup a wireguard instance,
  which will be the only gateway to access your kubernetes (You can skip the wireguard part as well)

## Prerequisite

1. Need this package to be installed on your local machine

   ```text
   kubectl
   jq
   terragrunt
   terraform
   bcrypt
   wireguard
   yq (https://github.com/mikefarah/yq)
   ```

2. Git repository

   a. clone the kubeaid git repo from obmondo
   b. Create a fresh git repo (for better naming, we usually call it kubeaid-config)

## Installations

* Clusters

  * [AWS Kops Cluster Setup](./aws/kops/cluster.md)
  * [Hetzner Bare Metal Setup](./hetzner/server-setup.md)
  * [AKS Cluster Setup](./azure/aks/cluster.md)

* Helm

  * [Update Helm chart](./helm/update_helm_chart.md)

## Feature and Security Updates

We regularly update our Helm charts from upstream repositories and ensure that you don't miss out on
important security updates. To simplify updates, you can grant write access to your `kubeaid` and `kubeaid-config` repo
created in step 2 above - to the github user `obmondo-pushupdate-user`.

This will enable us to automatically push the latest updates to your repo and allow us to adjust your
cluster and app configuration, which we need to be able to do - if you're a subscriber with us.

Alternatively, you can pull the updates from our repo after cloning it on your systems using:

```sh
git pull origin master
```
