# Keycloak Client Setup

## Install krew plugin manager

https://krew.sigs.k8s.io/docs/user-guide/setup/install/

In case you are interested.
https://krew.sigs.k8s.io/docs/user-guide/quickstart


## Install the oidc-login client

kubectl krew install oidc-login

Details about setup if you are interested:

* https://github.com/int128/kubelogin/blob/master/docs/setup.md

## Setup the Kubernetes client

* Log into the keycloak server as admin.
* Go to [clients](http://localhost:8888/auth/admin/master/console/#/realms/master/clients) and click on `Create`.
* Provide the `Client ID` as `kubernetes`, leave `Client Protocol ` as `openid-connect`, `Root URL` as blank, and click on save.

## Setup the client

* Run the below
    ```
    bash -u

    export KEYCLOAK_URL="https://keycloak.kam.obmondo.com/auth/realms/master"
    export CLIENT_ID=kubernetes
    export CLIENT_SECRET=kubernetes

    kubectl oidc-login setup --oidc-issuer-url=$KEYCLOAK_URL --oidc-client-id=$CLIENT_ID --oidc-client-secret=$CLIENT_SECRET
    ```

* Bind a cluster role
  1. After you ran the above command, you would be getting a output which will include the below command, just correct the clusterrolebinding `name` here.
  2. The url should be exactly same from the output of the above command.
        ```
        kubectl create clusterrolebinding <your-username>-oidc-cluster-admin --clusterrole=cluster-admin --user='$KEYCLOAK_URL#<your-keycloak-userID>'
        ```

* Set up the Kubernetes API server. Add the following options to the kube-apiserver:
    ```
    --oidc-issuer-url=$KEYCLOAK_URL
    --oidc-client-id=$CLIENT_ID
    ```
    > k8s admin should have already done it via puppet/kops (get it confirmed by the k8s admin)

* Set up the kubeconfig

  1. Run the following command to add the oidc user in your `kubeconfig` file.
      ```
      kubectl config set-credentials oidc \
        --exec-api-version=client.authentication.k8s.io/v1beta1 \
        --exec-command=kubectl \
        --exec-arg=oidc-login \
        --exec-arg=get-token \
        --exec-arg=--oidc-issuer-url=$KEYCLOAK_URL \
        --exec-arg=--oidc-client-id=$CLIENT_ID \
        --exec-arg=--oidc-client-secret=$CLIENT_SECRET
      ```

  2.  Or directly copy below in your `kubeconfig` file.
      ```
      users:
      - name: oidc
        user:
          exec:
            apiVersion: client.authentication.k8s.io/v1beta1
            args:
            - oidc-login
            - get-token
            - --oidc-issuer-url=$KEYCLOAK_URL
            - --oidc-client-id=$CLIENT_ID
            - --oidc-client-secret=$CLIENT_SECRET
            command: kubectl
            env: null
            provideClusterInfo: false
      ```

  3. Once done set the `oidc` user for current context.
      ```
      kubectl config set-context --user oidc $(kubectl config get-contexts -o name)
      ```

* Verify cluster access
  ```
  kubectl get nodes
  ```
## Create Keycloak Group based Cluster RBAC autherization

* Login to keycloak as admin

* Go to your client(kubernetes in this case)

* In your client go to `mappers` & click on `create`

* Create a new mapper as shown below:

  ![new mapper](static/mapper.png)

* Once done, you can go ahead create all the respective groups you want in keycloak.
  1. From [Keycloak homepage](https://keycloak.kam.obmondo.com/auth/admin/master/console/) go to [groups](https://keycloak.kam.obmondo.com/auth/admin/master/console/#/realms/master/groups) and click on `new`
  2. Provide the new group's name and click save.

* Add the users to the group
  1. From [Keycloak homepage](https://keycloak.kam.obmondo.com/auth/admin/master/console/) go to [users](https://keycloak.kam.obmondo.com/auth/admin/master/console/#/realms/master/users) and click on `View all users`
  2. Go `Groups`
  3. Select the group you want to add the user to from the `Available Groups` table
  4. Click on `Join`

* Create the respective RBAC policy in kubernetes cluster
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: sre-admin
    subjects:
    - kind: Group
      name: <Keycloak groups name>
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: <clusterRole name that you want to map the group to>
      apiGroup: rbac.authorization.k8s.io
    ```
* Refresh your `id-token` retrived from keycloak and you are good to go.

---

## How to give a user an admin access in [Keycloak](https://keycloak.kam.obmondo.com/auth/admin/master/console/) and not in k8s
login as admin, password is in `pass` git repo

Click on user -> "Role Mappings" -> put `admin` into assigned role

## Troubleshooting

* Remove all cache session and run all the steps in the Setup the client.
  ```
  # rm -fr ~/.kube/cache/oidc-login

  # kubectl delete clusterrolebinding <your-username>-oidc-cluster-admin
  ```

## Disaster Recovery

The keycloak recovery/reconfiguration can also be done by exporting the realm and later importing it. Steps:

* Login to keycloack as admin
* Go to `https://<keycloack-url>/auth/admin/master/console/#/realms/master/partial-export`
* `Export groups and roles` -> ON
* `clients` -> ON
* Click on `Export`

This will download the real and the respective settings as a `.json` file which can later be used to import the settings from `https://<keycloack-url>/auth/admin/master/console/#/realms/master/partial-import`.

The same can also be done through the argocd UI. You can go ahead and delete the app from the argocd UI which wdoesn't seem to delete the PVC, therefore when you sync the root app and the keycloak app next it will use the same PVC.
Restoring itself to the point previously setup and configured to.