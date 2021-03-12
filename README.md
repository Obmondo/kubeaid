# Repository structure

|argocd-clusters-managed | Primary folder - containing applications and configs for each managed cluster, which MAY make use of common resources, such as argocd-helm-charts and argocd-k8s-config. Each clusterfolder is actually a Helm chart - hence applications are put as yaml in ```templates``` folder. |
| --- | --- |
|argocd-helm-charts | Contains ArgoCD helm charts, that points to the actual helm charts (as a dependency listed in Charts.yaml) - and with the default values we want. Each cluster can add override/extra values by listing an extra valuesfile in their argocd-clusters-managed/$clustername folder. |
|argocd-k8sconfig | Kubernetes config objects. Used by all in ```common``` and per-cluster in their indidivual $clustername folder. |
|argocd-application-templates | collection of applications, to be optionally modified and copied into ```argocd-clusters-managed/$clustername/templates``` to be installed on that cluster. |

# Add a new cluster to be managed by this repository/argocd

## Create namespace for argocd installation
```
kubectl create namespace argocd
kubectl config set-context --current --namespace=argocd
```

## Create secret for git repo access

### for https access to git repos

Add secret with a username and a password (a personal-access-token) that is valid and has access to that repo.

* To get the personal-access-token
  1. Go to Profile->Access Tokens
  2. Give any name (argo-cd-microk8s) and select "read_repository, write_repository"
* Create secret via https
  ```
  kubectl create secret generic argo-cd-blackwoodseven-github --from-literal=username=KlavsKlavsen --from-literal=password='234dfaf23rf2323232323232323xxxxxxxxxxxxx'
  ```

### for SSH access to git repos

Setup gitlab user and generate SSH keyset (and add public part to that gitlab user).
Grant that user ONLY developer access to the projects it needs. Make sure those have master branch and tags protected in config.

add secret with ssh keys for gitlab argocd SSH access:
```
kubectl create secret generic argocd-sshkey --from-file=ssh-privatekey=/path/to/.ssh/id_rsa --from-file=ssh-publickey=/path/to/.ssh/id_rsa.pub
```

and make sure `sshPrivateKeySecret.name` for repositories in
`argocd-clusters-managed/$yourclustername/values-argocd.yaml` has this repo added, matching above secretname.


## Install argo-cd
```
helm dep update argocd-helm-charts/argo-cd
helm install -n argocd argo-cd argocd-helm-charts/argo-cd
```
## Get the pods status

```
kubectl  get pods
NAME                                                    READY   STATUS              RESTARTS   AGE
argo-cd-argocd-server-76687b5447-7h5pb                  0/1     ContainerCreating   0          2m20s
argo-cd-argocd-repo-server-6bd696f59b-wwr9r             0/1     ContainerCreating   0          2m20s
argo-cd-argocd-application-controller-d6c576f5d-5q28r   0/1     ContainerCreating   0          2m20s
argo-cd-argocd-redis-7dfd84cf48-wtfvq                   1/1     Running             0          2m20s
```

Login to the UI. To get the credentials refer
[argocd admin credentials](https://argoproj.github.io/argo-cd/getting_started/#4-login-using-the-cli).

## Install root argocd application - that manages the rest
Install argo-cd root app using:
```
helm template argo-cd-helm-apps/your-cluster-name --show-only templates/root.yaml | kubectl apply -f -
```

And its Chart.yaml points to this repo argo-cd-helm-apps - so once Root app is installed - it'll pick up the apps in there and start setting them up.

Now we can remove helm management of argo-cd - as argo-cd manages itself (as argo-cd is one of the apps in above apps folder).

```
kubectl delete secret -l owner=helm,name=argo-cd
```

# Secrets handling

IF a helm chart creates a secret - ArgoCD will expect it to remain unchanged (otherwise complain application is out-of-sync). 
IF this happens - it means you have a secret thats changed via the application (typicly user login password) - and we NEED backup of these.
To resolve out-of-sync complaint in ArgoCD - AND backup/recovery do this:
1. let helm chart create secret and application generate it - so you get out-of-sync complaint from ArgoCD.
2. dump secret in json format, remove unnecessary metadata/helm labels and encode into cluster secrets repo and delete the secret from k8s (before pushing to secrets repo).
3. update values for chart as to NOT generate secret. Typicly setting is called something like useExistingSecret: $name-of-secret
## Debugging
* you might see pods getting evicted, mostly likely disk is used around 70% or you have less disk size (> 5GB).
  to fix it increase the disk size
  ```
  root@htzsb44fsn1a ~ # kubectl get pods
  NAME                                                    READY   STATUS    RESTARTS   AGE
  argo-cd-argocd-application-controller-d6c576f5d-4d9bv   0/1     Evicted   0          84m
  argo-cd-argocd-application-controller-d6c576f5d-5xwq5   0/1     Evicted   0          44m
  argo-cd-argocd-application-controller-d6c576f5d-7cm78   0/1     Evicted   0          100m
  ```
* Please refer: [Wiki for kubernetes](https://gitlab.enableit.dk/obmondo/wiki/-/tree/master/internal/kubernetes)


### Install

*  helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh
Downloading https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
```

* k9s
```
wget https://github.com/derailed/k9s/releases/download/v0.24.2/k9s_Linux_x86_64.tar.gz

tar -xvf k9s_Linux_x86_64.tar.gz
LICENSE
README.md
k9s

sudo mv k9s /usr/local/bin/
```

#### Notes

* How to get rid of evicted pods
  ```
  kubectl get pods -n <namespace> | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n <namespace>
  ```

* How to move the /var/lib/docker into different partition
  1. STOP docker
  ```
  # systemctl stop docker
  ```
  2. Copy the content to `/mnt`
  ```
  # cp -a /var/lib/docker/* /mnt/
  ```
  3, Move the existing docker to docker.bad
  ```
  # mv /var/lib/docker /var/lib/docker.bad
  ```
  4. Create new directory and give correct perms
  ```
  # mkdir /var/lib/docker
  # chmod 711 /var/lib/docker
  ```
  5. Mount the new partition
  ```
  # mount /dev/md2 /var/lib/docker
  # ll /var/lib/docker
  total 20
  drwxr-xr-x 14 root root  182 Mar  9 13:37 ./
  drwxr-xr-x 39 root root 4096 Mar  9 13:40 ../
  drwx------  2 root root   24 Feb 26 02:50 builder/
  drwx--x--x  4 root root   92 Feb 26 02:50 buildkit/
  drwx-----x 18 root root 4096 Mar  9 13:04 containers/
  drwx------  3 root root   22 Feb 26 02:50 image/
  drwxr-x---  3 root root   19 Feb 26 02:50 network/
  drwx-----x 83 root root 8192 Mar  9 13:04 overlay2/
  drwx------  4 root root   32 Feb 26 02:50 plugins/
  drwx------  2 root root    6 Feb 26 02:50 runtimes/
  drwx------  2 root root    6 Feb 26 02:50 swarm/
  drwx------  2 root root    6 Mar  9 13:04 tmp/
  drwx------  2 root root    6 Feb 26 02:50 trust/
  drwx-----x  2 root root   25 Mar  9 12:56 volumes/
  ```
  6. Start the docker
  ```
  # systemctl start docker
  ```
  7. check docker containers status
  ```
  # docker ps
  CONTAINER ID   IMAGE                  COMMAND                  CREATED         STATUS         PORTS     NAMES
  d369e1e6dd84   ca9843d3b545           "kube-apiserver --ad…"   3 seconds ago   Up 2 seconds             k8s_kube-apiserver_kube-apiserver-htzsb45fsn1b.enableit.dk_kube-system_71d65010c0f7d404111b770c5dae14e1_9
  1324266a81ba   10cc881966cf           "/usr/local/bin/kube…"   3 seconds ago   Up 1 second              k8s_kube-proxy_kube-proxy-qqzhb_kube-system_634bc852-7f14-4c88-ae8d-a327154df765_1
  e661c3efc006   727de170e4ce           "/opt/cni/bin/calico…"   3 seconds ago   Up 2 seconds             k8s_upgrade-ipam_calico-node-t4j5f_kube-system_dbf46441-2f50-49c7-8559-38354d8143b6_1
  9a26da60d255   b9fa1895dcaa           "kube-controller-man…"   3 seconds ago   Up 2 seconds             k8s_kube-controller-manager_kube-controller-manager-htzsb45fsn1b.enableit.dk_kube-system_037456d6c73313a25d5009a0db8afcf7_3
  0b86e0d1e44f   3138b6e3d471           "kube-scheduler --au…"   3 seconds ago   Up 2 seconds             k8s_kube-scheduler_kube-scheduler-htzsb45fsn1b.enableit.dk_kube-system_81d2d21449d64d5e6d5e9069a7ca99ed_2
  785432ed2d06   k8s.gcr.io/pause:3.2   "/pause"                 6 seconds ago   Up 3 seconds             k8s_POD_calico-node-t4j5f_kube-system_dbf46441-2f50-49c7-8559-38354d8143b6_1
  db8a25a8a464   k8s.gcr.io/pause:3.2   "/pause"                 7 seconds ago   Up 3 seconds             k8s_POD_kube-scheduler-htzsb45fsn1b.enableit.dk_kube-system_81d2d21449d64d5e6d5e9069a7ca99ed_1
  47cae516a012   k8s.gcr.io/pause:3.2   "/pause"                 7 seconds ago   Up 3 seconds             k8s_POD_kube-apiserver-htzsb45fsn1b.enableit.dk_kube-system_71d65010c0f7d404111b770c5dae14e1_1
  8c76ab3f4218   k8s.gcr.io/pause:3.2   "/pause"                 7 seconds ago   Up 3 seconds             k8s_POD_kube-proxy-qqzhb_kube-system_634bc852-7f14-4c88-ae8d-a327154df765_1
  fcab4f0e9d18   k8s.gcr.io/pause:3.2   "/pause"                 7 seconds ago   Up 3 seconds             k8s_POD_kube-controller-manager-htzsb45fsn1b.enableit.dk_kube-system_037456d6c73313a25d5009a0db8afcf7_1
  ```
