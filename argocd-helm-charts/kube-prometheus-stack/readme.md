# Prometheus Kubernetes Stack

Includes alertmanager, grafana etc.

## Resetting password for grafana admin user

shell into grafana pod and run:

```
grafana-cli admin reset-admin-password <newpassword>
```

## Setup the admin account password.

Run the below two command and push the result json file to respective git repo and sync the `secret` app in the argocd

```
echo -n 'blahblew' | kubectl create secret generic kube-prometheus-stack-grafana -n monitoring --dry-run=client --from-file=admin-password=/dev/stdin --from-literal=admin-user=admin -o json >grafana_secrets.json

kubeseal --controller-name sealed-secrets --controller-namespace system <grafana_secrets.json >grafana-sealed.json
```

## Connecting Alert Manager with Slack/Obmondo/ other chat platforms
Alert manager can be integrated with several chat channels to give real-time alerting based on prometheus metrics. There is a file alertmanager.yml that holds this configuration. You can need private keys and certificates too. Check the official guide for more details: https://prometheus.io/docs/alerting/latest/configuration/

N.B: There will have to be two(2) sealed secrets genetated.
1. For alert-manager:
   Encode the alert-manager in base64 by running:
   # base64 alert-manager.yml 

    Then copy the contents in the secrets, then to seal the secrets, run:
    # kubeseal --controller-name sealed-secrets --controller-namespace system <alert-manager-secret.json >alert-manager-sealedsecret.json
  
2. For certificate and private key 

   # base64 certificate.cer 
   # base64 private-key.pem
   
    Then copy the contents in the secrets, then to seal the secrets, run: 
    # kubeseal --controller-name sealed-secrets --controller-namespace system <alert-manager-secret.json >alert-manager-sealedsecret.json
## Integrate Keycloak with Grafana

* Docs

https://github.com/Crimrose/Note-integrate-SSO-grafana

## Troubleshooting.

1. You have deployed the kube stack and now want to change the password of grafana.
  * You created a sealed secret and pushed it to the git repo and sync'd the secret app in argocd and you can check your password is correct or not in k8s, by this command.
    ```
    kubectl get secret  kube-prometheus-stack-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```
  * The password would be correct, but when you try to login it won't work, why ? cause the stack has already deployed the grafana and has no idea how to change the existing password in grafana.
  * oneliner to generate the sealed-secret
    ```
    kubectl create secret generic kube-prometheus-stack-grafana -n monitoring --dry-run=client --from-literal=grafana-keycloak-secret=i_love_k8s -o json | kubeseal --controller-name sealed-secrets --controller-namespace system - > sealed-secrets/k8s.ops.blackwoodseven.com/monitoring/kube-prometheus-stack-grafana.json
    ```
  * To reproduce this, delete the kube stack and run the get secret command and you would see the password is changed to the default one, which it shouldn't.
  * Fix is to simply add the `keys` from the grafana helm chart into the kube stack value file.
    a. one of option is to use the existing secret (so make sure the sealedsecret has deployed the password before)

2. Timeout Error while connecting to keycloak
  ```
  lvl=eror msg=login.OAuthLogin(NewTransportWithCode) logger=context userId=0 orgId=0 uname= error="Post \"https://keycloak.ops.bw7.io/auth/realms/devops/protocol/openid-connect/token\": dial tcp 10.2.43.194:443: connect: connection timed out"                                                                                    │
  ```

3. Relogin does not work as expected. (Happens randomly)
  * Currently when you login and logout and login again (it fails here)
  * The second login works (confirmed by looking at the logging session in keycloak)
  * FIX:
    a. Logout all the session from the keycloak
    b. closed the browser (Now I was testing it in 'Private Mode')
    c. start a new browser and login again
