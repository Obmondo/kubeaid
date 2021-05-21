# Keycloak Client Setup

# Install krew plugin manager

https://krew.sigs.k8s.io/docs/user-guide/setup/install/

In case you are interested.
https://krew.sigs.k8s.io/docs/user-guide/quickstart


# Install the oidc-login client

kubectl krew install oidc-login

Setup doc:

* https://github.com/int128/kubelogin/blob/master/docs/setup.md

# Setup the client

* Run the below
  1. oidc-client-id (in this case its `kubernetes`) has to be configured by k8s admin.
  2. oidc-client-secret needs to be shared by the k8s admin, so you will need to ask k8s admin for this two details.
```
kubectl oidc-login setup --oidc-issuer-url=https://keycloak.kam.obmondo.com/auth/realms/master --oidc-client-id=kubernetes --oidc-client-secret=xxxxxxxxxxxxxx
```

* Bind a cluster role
  1. After you ran the above command, you would be getting a output which will include the below command, just correct the clusterrolebinding `name` here.
  2. The url should be exactly same from the output of the above command.
```
kubectl create clusterrolebinding <you-username>-oidc-cluster-admin --clusterrole=cluster-admin --user='https://keycloak.kam.obmondo.com/auth/realms/master#xxxxxxxxxxxxxxxxxxxxx'
```

* Set up the Kubernetes API server, Add the following options to the kube-apiserver:
  1. k8s admin should have already done it via puppet/kops (get it confirmed by the k8s admin)
```
  --oidc-issuer-url=https://keycloak.kam.obmondo.com/auth/realms/master
  --oidc-client-id=kubernetes
```

* Set up the kubeconfig
```
kubectl config set-credentials oidc \
  --exec-api-version=client.authentication.k8s.io/v1beta1 \
  --exec-command=kubectl \
  --exec-arg=oidc-login \
  --exec-arg=get-token \
  --exec-arg=--oidc-issuer-url=https://keycloak.kam.obmondo.com/auth/realms/master \
  --exec-arg=--oidc-client-id=kubernetes \
  --exec-arg=--oidc-client-secret=xxxxxxxxxxxxxxxxxxx

or

* Directly copy it in your ~/.kube/config
users:
- name: oidc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url=https://keycloak.kam.obmondo.com/auth/realms/master
      - --oidc-client-id=kubernetes
      - --oidc-client-secret=xxxx
      command: kubectl
      env: null
      provideClusterInfo: false
```

* Verify cluster access
```
kubectl --user=oidc get nodes
```

## How to give a user an admin access in [Keycloak](https://keycloak.kam.obmondo.com/auth/admin/master/console/) and not in k8s
login as admin, password is in `pass` git repo

Click on user -> "Role Mappings" -> put `admin` into assigned role

## Troubleshooting

* Remove all cache session and run all the steps in the Setup the client.
```
# rm -fr ~/.kube/cache/oidc-login

# kubectl delete clusterrolebinding <your-username>-oidc-cluster-admin
```

> The keycloack recovery/reconfiguration can also be done by exporting the realm and later importing it.
>
> Steps:
> * Login to keycloack as admin
> * Go to `https://<keycloack-url>/auth/admin/master/console/#/realms/master/partial-export`
> * `Export groups and roles` -> ON
> * `clients` -> ON
> * Click on `Export`
>
> This will download the real and the respective settings as a `.json` file which can later be used to import the settings from `https://<keycloack-url>/auth/admin/master/console/#/realms/master/partial-import`.