# K8id Documentation

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

   a. clone the k8id git repo from obmondo
   b. Create a fresh git repo (for better naming, we usually call it k8id-config)

## Installations

* Clusters

  * [AWS Kops Cluster Setup](./aws/kops/cluster.md)
  * [Hetzner Bare Metal Setup](./hetzner/server-setup.md)
  * [AKS Cluster Setup](./azure/aks/cluster.md)

* Helm

  * [Update Helm chart](./helm/update_helm_chart.md)
