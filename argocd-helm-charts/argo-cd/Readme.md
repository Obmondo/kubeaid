# Argo CD

## Setup root argocd application

* After your kube cluster is created - you will need to deploy the root application
  Assuming you have already created the `k8s/<clustername>/argocd-apps` in your k8id-config repo

  ```sh
  helm template k8s/<clustername>/argocd-apps --show-only templates/root.yaml | kubectl apply -f -
  ```sh

## Add Argocd repos

* Git repos

  ```sh
  kubectl create secret generic sample-git --namespace argocd --dry-run=client --from-literal=type='git' --from-literal=name='sample-git' --from-literal=url=https://gitlab.com/Obmondo/sample-website.git --from-literal=username='gitlab+deploy-token-20' --from-literal=password='lolpassword' --output yaml | yq eval '.metadata.labels.["argocd.argoproj.io/secret-type"]="repository"' - | yq eval '.metadata.annotations.["sealedsecrets.bitnami.com/managed"]="true"' - | yq eval '.metadata.annotations.["managed-by"]="argocd.argoproj.io"' - | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml - > sample-website-argocd-repo.yaml
  ```

## Replace admin password

* Run our script to do this:
  Source: https://github.com/argoproj/argo-cd/blob/master/docs/faq.md#i-forgot-the-admin-password-how-do-i-reset-it

  NB. SPACE in front of 'bcrypt-tool' command IS IMPORTANT - as it ensures its NOT stored in your bash history

  ```sh
  # sudo snap install bcrypt-tool

  # <need-space> bcrypt-tool hash "lolyourpassword123" 10

  # kubectl -n argocd patch secret argocd-secret -p '{"stringData": { "admin.password": "<insert-bcrypt-hash>", "admin.passwordMtime": "'$(date +%FT%T%Z)'" }}'
  ```

  and KILL the pod(s) called `argo-cd-argocd-server-*`

## Argocd status stuck in Progressing

* The argocd application in ArgoCD UI remains stuck in Progressing state.

  As per argocd faq, the issue is from Traefik and a few other ingress controllers.
  https://github.com/traefik/traefik/issues/3377
  https://argo-cd.readthedocs.io/en/stable/faq/

  The `status.loadBalancer` field is empty for the argocd ingress, and it seems to be the core reason for this issue.

  ```sh
  kubectl -n argocd get ing argo-cd-argocd-server -o jsonpath={.status}
  ```

## Configure argocd with keycloak

* Doc: https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/keycloak/

  ```sh
  bcrypt-tool hash "lolpassword" 10

  # When creating a new argocd-secret
  kubectl create secret generic argocd-secret --namespace argocd --dry-run=client --from-literal=admin.password='crypt-output-from-above-command' --from-literal=admin.passwordMtime="$(date +%FT%T%Z)" --from-literal=oidc.keycloak.clientSecret='you-get-from-keycloak' --from-literal=server.secretkey='any-random-string-which-is-long-enough' --output=yaml | kubeseal --controller-name sealed-secrets --controller-namespace system -o yaml - > argocd-secret.yaml

  # When updating the existing argocd-secret
  kubectl create secret generic argocd-secret --namespace argocd --dry-run=client --from-literal=oidc.keycloak.clientSecret="you-get-from-keycloak" -o yaml| kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml --merge-into argocd-secret.yaml
  ```

  ```raw
  * To add any new user into argocd as an admin
    login to keycloak
    -> Users
    -> Select User
    -> Under `groups` tab
    -> Select the required group (See values for argocd https://<k8id-config-repo-url>/-/blob/main/k8s/<clustername>/argocd-apps/values-argo-cd.yaml under policy.csv)
    -> done
  ```

## Troubleshooting ArgoCD and Keycloak

* Check whether there is a secret called `argocd-secret` in the `argocd` namespace in the k8s cluster.
* The `argocd-secret` should have a key `oidc.keycloak.clientSecret`.
* Verify your keycloak user roles and group memberships for your username by logging into the keycloak server from UI.
* The URL for keycloak server would be https://keycloak.your.domain.com. Refer [Keycloak readme](../keycloak/README.md).
* Check the `values-argo-cd.yaml` in the k8id-config repo for the k8s cluster. Match policy.csv with the roles in Keycloak
