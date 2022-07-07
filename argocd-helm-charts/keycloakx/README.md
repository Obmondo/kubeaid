# Keycloak Server Setup

### NOTE: Do not give admin password from the webUI, add the password via an ENV variable. 'KEYCLOAK_PASSWORD'

* There are bunch of ways to do this, I have did it in this way.

```
# Regular way
kubectl create secret generic keycloak-admin --from-file=KEYCLOAK_PASSWORD=./keycloak_password -n keycloak

# Sealed Secret way
kubectl create secret generic keycloak-admin -n keycloak --dry-run=client --from-file=KEYCLOAK_PASSWORD=./keycloak_password -o json >mysecret.json
kubeseal --controller-name sealed-secrets --controller-namespace system <mysecret.json >keycloak-admin.json
```

# Keycloak Client Setup

## Install krew plugin manager

https://krew.sigs.k8s.io/docs/user-guide/setup/install/

In case you are interested.
https://krew.sigs.k8s.io/docs/user-guide/quickstart

```sh
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)
```

Change your shell init scripts to amend `PATH`:

```sh
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
```

## Install the oidc-login client

```sh
kubectl krew install oidc-login
```

Details about setup if you are interested:

* https://github.com/int128/kubelogin/blob/master/docs/setup.md

## Basic Keycloak setup

* Log into the keycloak server as admin: https://keycloak.ops.bw7.io/auth/admin/
  * The password can be extracted from the `keycloak-admin` secret.
* Make sure that you are in the `Master` realm
* Create a personal admin user account
  * Manage -> Users -> Add user
  * Fill out `Username`, `Email`, `First name` and `Last name`
  * Email Verified: `On`
  * Click `save`
  * Give the user admin rights
    * Role mappings -> Available Roles -> `admin` -> Add selected
* Set a password for you personal admin account
  * Click `Credentials`
  * Enter your unique password in both fields
  * Temporary: `Off`
  * Click `Set Password`

* Create a new realm
  * Skip this if the `<customer_name>` realm already exists
  * Move the pointer to the `Master  ∨` in the top left corner, and click `Add realm`
  * Name: `<customer_name>`  - without any " " character

## Setup Keycloak with Google as it's identity provider

* Log into the keycloak server, using your personal admin account
* Switch to the `<customer_name>` realm
* Follow this description:
  * https://access.redhat.com/documentation/en-us/red_hat_single_sign-on/7.3/html/server_administration_guide/identity_broker#google
    * There is a backup of the documentation [here](static/GoogleSetup.pdf).
  * Google project name: `Keycloak`
  * Hint: Enable `Trust Email`
* Create roles: Configure -> Roles -> Add Role
  * Create `kube_admin` role
  * Create `kube_developer` role
  * *ToDo*: Add more user roles
* Create groups, and their role mappings
  * Manage -> Groups -> New
  * Create `SRE` group, with role mappings to `kube_admin`
  * Create `Developer` group, with role mappings to `kube_developer`
  * *ToDo*: Add more user groups

## Setup the Kubernetes client

* Log into the keycloak server using your personal admin user
* Go to the `<customer_name>` realm
* Go to clients and click on `Create`.
* Provide the `Client ID` as `kubernetes`, leave `Client Protocol ` as
  `openid-connect`, `Root URL` as blank, and click on save.
* In the "Kubernetes" client details find "Valid redirect URLs" and add
  `http://localhost` and click "Save.
* Enable Role/Group membership to be included in the tokens
  * Mappers -> Add Builtin
  * Enable `groups` checkbox
  * Click `Add selected`

## Make logins easier for the user

Since we only allow users to login to the <customer_name> using Google oauth, we can make the login flow faster, by setting it as default:

* Log into the keycloak server using your personal admin user
* Go to the `<customer_name>` realm
* Configure -> Authentication -> Flows -> Browser -> Identity Provider Redirector -> Actions -> Config
  * Alias: `google`
  * Default Identity Provider: `google`

## Add normal users to the Keycloak setup

* Have the user access https://keycloak.ops.bw7.io/auth/realms/<customer_name>/account/
  * Click `Personal Info` link
  * The user is now done, and the basic user account has been created
* Add the user to the group, that that describe their access needs
  * Log into the keycloak server using your personal admin user
  * Go to the `<customer_name>` realm
  * Manage -> Users -> View all users
  * Clik `edit`, on the row describing the user
  * Groups -> Available groups
  * Clik the group where the user belong, and click `join`

## Configure Keycloak to send e-mail

* Extract SMTP username and password from Terraform state
  * The account has been created by terraform, as part of the cluster install procedure
  * Go to the directory, where you have checked out the `iac_iam` repository
  * Execute: ```terraform refresh```
  * Execute: ```terraform show -json | jq -e '.values.root_module.child_modules[].resources[] | select(.name=="keycloak-smtp") | select(.type=="aws_iam_access_key")|{cluster:.index,smtp_user:.values.id,smtp_pass:.values.ses_smtp_password_v4}'```
* Log into the keycloak server using your personal admin user
* Go to the `<customer_name>` realm
* Configure -> "Realm Settings" -> Email
  * Host: `email-smtp.eu-west-1.amazonaws.com`
  * Port: `587`
  * From Display Name: `<Customer Name> Keycloak`
  * From: `info@<customer_name>.com`
  * Envelope From: `info@<customer_name>.com`
  * Enable StartTLS: `On`
  * Enable Authentication: `On`
  * Username: &lt;*Extracted from Terraform state*&gt;
  * Password: &lt;*Extracted from Terraform state*&gt;
* Click `Test conection`
  * This has to succeed!
* Click `Save`

## Setup the client

* Run the below

    ```sh
    export KEYCLOAK_URL="https://keycloak.your.domain.com/auth/realms/master"
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
  1. From [Keycloak homepage](https://keycloak.your.domain.com/auth/admin/master/console/) go to [groups](https://keycloak.your.domain.com/auth/admin/master/console/#/realms/master/groups) and click on `new`
  2. Provide the new group's name and click save.

* Add the users to the group
  1. From [Keycloak homepage](https://keycloak.your.domain.com/auth/admin/master/console/) go to [users](https://keycloak.your.domain.com/auth/admin/master/console/#/realms/master/users) and click on `View all users`
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

## Add user in keycloak

* Select realm 'master'

    NOTE: `master` realm is sacred, so add user wisely in this realm and for other purpose just use another realm (most of the cases there will be `devops` realm)
* From [Keycloak homepage](https://keycloak.your.domain.com/auth/admin/master/console/) go to [users](https://keycloak.your.domain.com/auth/admin/master/console/#/realms/master/users) and click on `View all users`
* Click on `Add User`
* Add the relevant details and under `Required User Actions` add `Update Password` (so user can change password on login)
* Click on `Save`
* Click on `Credentials` and give the random password and share it with the end user, make sure `Temporary` is **ON**
* Click on `Role Mappings` and under `Available Roles` select `admin` and click on `Add Selected` (it automatically saves and you should see green colour popup alert toolbox)

    NOTE: `admin` role is quite powerful, so be cautious about this when assigning this role and its only available in `master` realm

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

The same can also be done through the argocd UI. You can go ahead and delete the app from the argocd UI which doesn't seem to delete the PVC/PV, therefore when you sync the root app and the keycloak app next it will use the same PVC/PV.
Restoring itself to the point previously setup and configured to.

## Good "Reads"

* https://medium.com/keycloak/github-as-identity-provider-in-keyclaok-dca95a9d80ca
* https://www.youtube.com/watch?v=duawSV69LDI
