# Welcome to k8sops

This repository ( https://gitlab.com/Obmondo/k8sops) implements a solution to run any Kubernetes cluster, using gitops principles and allowing for costumization, in a seperate repository.

This way you can always pull the latest commits, and get security updates, fixes, new features etc. - while having your own adjustments still.

This is copyright EnableIT ApS (of Denmark) and released under GPL 3 license of fsf.org.

https://Obmondo.com offers subscriptions, where we manage your Kubernetes cluster, using this code, and react to incidents 24/7/365 if this should be of interest.
In this way, we typicly help out smaller setups, where there is only 1 or 2 operations people, and hence 24/7 operations isn't possible to run reliably - with out subscription, we take care of the 24/7 monitoring and our knowledgeable developers and operations guys are ready to resolve any issues that may arise - while you can work on the day 2 day stuff, as you'd usually do - and still get your vacations, weekends etc. - without having to be on-call.

# Security design goals

This operations design, is designed to deliver a setup, that delivers on all 3 aspects of security Conidentiality, Integrity and Availability.

## Confidentiality

This setup uses Calico CNI - and ensure network filtering - on both ingress and egress - which means we work hard to avoid any pod in this cluster, has (or needs) internet access. In this way, should a compromise of a pod happen - its harder to get data out, or pull necessary code from the internet to further exploit your systems.

You can disable network filtering for any application - but do so at your own peril - with above risk in mind.

## Integrity

### Helm chart security

We store EVERY Helm chart from an application upstream inside this repository. This has the following benefits:
+  You can always install your application / do recovery - with no internet needed. If an upstream chart repo is down - this will not affect you (and this happens quite often when you have many sources/charts in use).
+  On EVERY upgrade, we review the diff of the chart for any unexpected changes, and this way we HOPE to catch a compromised upstream release, before its included in this repository. 
   -  Atleast we can see from how other it has been found that other codebases has been compromised - that this is the structure that enabled it to be detected.
+ We run a CI job, that daily fetches the same charts we have in our repo, from upstream chart repo - and check if upstream matches OUR copy. If it does not:
  - Upstream updated an existing release - which is a VERY BAD idea.
  - Upstream Helm repo suffered a supply-chain attack

### Docker image security

We change EVERY docker image, to use the sha256sum of the docker image instead of the tag. This means if upstream mirror/dockerhub is compromised (and tag pointing to different docker image) - we will still get the original image - or fail.

This repository has a CI job, that on every MR / PR - fetches docker images used and pushes to YOUR docker registry (in gitlab, github docker service or what you prefer) - so your Kubernetes cluster doesn't talk to anything on the internet to pull the necessary docker images for operations.

Here we also run a daily CI job to compare tag to the sha256sum we have, to detect any supply chain attacks (which won't affect those using this setup) - so they can be reported upstream.

We scan docker images used, for known vulnerabilities (software in image with known CVE f.ex.) and report upstream, and if upstream will accept it - we will gladly submit fixes to upstream - to avoid users of this repository deploying vulnerable code.

## Availability

# Repository structure

| `argocd-clusters-managed`      | Primary folder - containing applications and configs for each managed cluster, which MAY make use of common resources, such as `argocd-helm-charts` and `argocd-k8s-config`. Each cluster folder is actually a Helm chart - hence applications are put as YAML in `templates` folder. |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `argocd-helm-charts`           | Contains ArgoCD helm charts, that points to the actual helm charts (as a dependency listed in `Charts.yaml`) - and with the default values we want. Each cluster can add override/extra values by listing an extra valuesfile in their `argocd-clusters-managed/$clustername` folder. |
| `argocd-k8sconfig`             | Kubernetes config objects. Used by all in `common` and per-cluster in their individual `$clustername` folder.                                                                                                                                                                         |
| `argocd-application-templates` | collection of applications, to be optionally modified and copied into `argocd-clusters-managed/$clustername/templates` to be installed on that cluster.                                                                                                                               |

# Install argocd on a cluster and add it to this repository

## PREREQUISITE
* kubectl, helm, kubeseal, bcrypt-tool and pwgen
* you can connect to k8s from your work station/laptop/desktop
  ```
  # To verify
  # kubctx <switch to correct k8s cluster> # there is a switch command as well
  # kubectl get nodes
  ```
* Generate access token for https and for github repo follow [this guide](https://docs.github.com/en/developers/apps/building-github-apps/authenticating-with-github-apps#generating-a-private-key)
  ```
  # https://gitlab.enableit.dk/kubernetes/kubernetes-config-enableit/-/settings/access_tokens
  > Give token name
  > "read_repository" scopes
  > "Maintainer" role
  > submit
  ```
* Generate username and password for OCI
  ```
  # TODO:
  # I haven't setup this, need someone to fill this up
  ```
* create git repo for customer k8s data. it SHOULD be in this format only kubernetes-config-<customer-id> and sits at the same level where your argocd-apps is cloned
  ```
  # https://gitlab.enableit.dk/kubernetes/kubernetes-config-enableit.git
  ```
* Wiki wiki/guides/kuberenetes-desktop-setup.md

## Setup K8s cluster

### Puppet
1. For puppet managed cluster
```
# ./bin/generate-puppet-hiera.sh --cluster-name kam.obmondo.com --version 1.22.5 --san-domains kam.obmondo.com,localhost,176.9.67.43,htzsb44fsn1a.enableit.dk:78.46.72.21,htzsb45fsn1a.enableit.dk:176.9.124.207,htzsb45fsn1b.enableit.dk:85.10.211.48 --customer-id enableit
```
2. Login onto server and run puppet
3. If things got broken refer this doc (Emil's doc)
4. ./bin/setup-k8s-cluster.sh --customer-id enableit --cluster-name kam.obmondo.com --settings-file <path-to-file>/customer-settings.yaml --install-k8s false
5. push all the files to git repo from the kubernetes-config-<customer-id> git repo
6. Add the argocd password in pass repo [you will get the password on step 4]

### KOPS
1. Get the k8s cluster up and running with KOPS with one single command line.
```
./bin/setup-k8s-cluster.sh --customer-id <customer-id> --cluster-name <cluster-name> --settings-file <path-to-settings-file> --k8s-type kops
```
2. Add the argocd password in pass repo [you will get the password on step 1]

## Uninstall script ### NOT TESTED ###
If something goes wrong you can uninstall again with `./bin/uninstall-argocd.sh`. You run it just like that, and it will prompt you for cluster_name and argocd password (which you recieved from the install script.)

## Recovery mode
Both scripts have a recovery mode which you use by calling them like this.
```
./bin/setup-k8s-cluster.sh --customer-id enableit --cluster-name kam.obmondo.com --settings-file customer-settings.yaml --recovery --private-key-path private_keys --public-key-path public_keys --install-k8s false
or
./bin/uninstall-argocd.sh --recovery
```
In recovery mode the uninstall script will remove argocd from kubernetes but not from you local repo clone, and the install script will install argocd using the existing manifests in your local repo clone.

### for SSH access to git repos ### We don't support this

Setup gitlab user and generate SSH keyset (and add public part to that gitlab user).
Grant that user ONLY developer access to the projects it needs. Make sure those have master branch and tags protected in config.

add secret with ssh keys for gitlab argocd SSH access:

```sh
kubectl create secret generic argocd-sshkey --from-file=ssh-privatekey=/path/to/.ssh/id_rsa --from-file=ssh-publickey=/path/to/.ssh/id_rsa.pub
```

Make sure `sshPrivateKeySecret.name` for repositories in `argocd-clusters-managed/$yourclustername/values-argocd.yaml` has this repo
added, matching above secretname.

A command to get the existing ssh private key
```
kubectl get secrets -n argocd argo-cd-enableit-gitlab-ssh -o jsonpath="{.data.ssh-privatekey}" | base64 --decode
```

Login to the UI. To get the credentials refer
[argocd admin credentials](https://argoproj.github.io/argo-cd/getting_started/#4-login-using-the-cli).

## Install root argocd application - that manages the rest
Install argo-cd root app using:

```sh
helm template argo-cd-helm-apps/your-cluster-name --show-only templates/root.yaml | kubectl apply -f -
```

And its `Chart.yaml` points to this repo argo-cd-helm-apps so once Root app is
installed it'll pick up the apps in there and start setting them up.

Now we can remove helm management of argo-cd - as argo-cd manages itself (as argo-cd is one of the apps in above apps folder).

```sh
kubectl delete secret -l owner=helm,name=argo-cd
```

# Secrets handling

+ IF a helm chart creates a secret - ArgoCD will expect it to remain unchanged
  (otherwise complain application is out-of-sync).
+ IF this happens - it means you have a secret thats changed via the application
  (typicly user login password) - and we NEED backup of these.

To resolve out-of-sync complaint in ArgoCD - AND backup/recovery do this:

1. let helm chart create secret and application generate it - so you get out-of-sync complaint from ArgoCD.
2. dump secret in json format, remove unnecessary metadata/Helm labels and
   encode into cluster secrets repo and delete the secret from k8s (before
   pushing to secrets repo).
3. update values for chart as to NOT generate secret. Typically the setting is
   called something like `useExistingSecret: $name-of-secret`

## Debugging
* you might see pods getting evicted, mostly likely disk is used around 70% or you have less disk size (`> 5GB`).
  to fix it increase the disk size

  ```
  root@htzsb44fsn1a ~ # kubectl get pods
  NAME                                                    READY   STATUS    RESTARTS   AGE
  argo-cd-argocd-application-controller-d6c576f5d-4d9bv   0/1     Evicted   0          84m
  argo-cd-argocd-application-controller-d6c576f5d-5xwq5   0/1     Evicted   0          44m
  argo-cd-argocd-application-controller-d6c576f5d-7cm78   0/1     Evicted   0          100m
  ```
* It's important to ensure that: `acme.cert-manager.io/http01-edit-in-place: true` is placed in annotations for ingress when traefik is used

* Please refer: [Wiki for kubernetes](https://gitlab.enableit.dk/obmondo/wiki/-/tree/master/internal/kubernetes)

# Testing applications - before doing a PR / MR

## Test helm values genereate the yaml you want
1. run `helm dep up argocd-helm-charts/<nameofchart>`
2. run `helm template argocd-helm-charts/<nameofchart> --values argocd-clusters-managed/<targetcluster>/values-<nameofchart>.yaml >/tmp/before.yaml`
3. READ yaml and see if you like it.. adjust values to your liking and run 2.
   again - saving to `/tmp/after.yaml`
4. run: `diff -bduNr /tmp/before.yaml /tmp/after.yaml` - verify the changes your
   value update should have caused - did actually happen

## Install the application manually to verify
1. create/copy application YAML and set: `targetRevision` to `$yourbranchname`
   instead of `HEAD`
2. Load that yaml manually (`kubectl create -ns argocd -f yourapplication.yaml`)
3. Work in your branch - adjust values as needed etc.
4. When it works: simply update the application yaml to pointing to
   `targetRevision: HEAD` and make your MR/PR

# General idea/Working of pointing apps to GHRC

1. Main script - `helm-chart-cache.sh`
2. Run `helm-chart-cache.sh` script.

```sh
bash helm-chart-cache.sh -u <Username> -p <Password> -r <Registry>
```
Here
```
u - Username to login to your registry. Eg - Obmondo
p - Password. Here you need to pass the PA token which you can create on your Github profile
r - Name of the registry. Eg - ghcr.io/Obmondo
```

This script will first download the charts from Upstream repo and then save and
push it your registry. When the script has run without any issues it will update
the `Chart.lock` file of your charts to point it your OCI repo path. So, you
need to just commit and push the Chart.lock file and then your apps will start
pointing to GHCR.

Remember: the lock file will only change for charts which are still not in your
registry.

## Fix ssh mismatch key when the Change/Update of git server

* Repository which are configured via ssh might end up not working, since the ssh known_host key is changed.
* To fix
  1. ssh-keyscan -p <your-port-number> <git-server>
  2. Copy the `ecdsa-sha2-nistp256` other sha might work, but haven't tried it.
  3. Now the argocd won't be working, since it can't connect to the git server.
  4. Goto repository and click on 'Certificates' and remove the old entery and create a new one and add the key that you got from the ssh-keyscan
  5. Goto application and click on the `argo-cd` and sync the `argocd-ssh-known-hosts-cm` and then it should work
