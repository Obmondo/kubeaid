# Prometheus Kubernetes Stack

Includes alertmanager, grafana etc.


## Integrate Keycloak with Grafana

* Steps to configure grafana client on keycloak
https://github.com/Obmondo/Note-integrate-SSO-grafana

* Create secret with the token you get from the grafana client on keycloak
```bash
kubectl create secret generic kube-prometheus-stack-grafana -n monitoring --dry-run=client --from-literal=grafana-keycloak-secret=i_love_k8s -o json | kubeseal --controller-name sealed-secrets --controller-namespace system - > sealed-secrets/cluster_name/monitoring/kube-prometheus-stack-grafana.json
```

## Activate support from K8id Support team
```bash
# You will get the private key and cert from K8id Support team.

kubectl create secret tls obmondo-clientcert --namespace monitoring --dry-run=client --key=./private.key --cert=./cert.pem --output=yaml | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml -
```

```bash
# copy the existing template from the example-alertmanager-config dir, the filename is alertmanager-main
cp alertmanager-main-slack.yaml /to/your/k8id-config/k8s/your-cluster/sealed-secret/monitoring/alertmanager-main.yaml

# add your slack url with this command.
kubectl create secret generic alertmanager-main --dry-run=client --from-literal=slack-url="https://hooks.slack.com/services/lol/my/token" -o yaml | kubeseal --controller-namespace system --controller-name sealed-secrets --format yaml --merge-into alertmanager-main.yaml
```

## Troubleshooting

* You have deployed the kube stack and now want to change the password of grafana.

  * You created a sealed secret and pushed it to the git repo and sync'd the secret app in argocd and i
    you can check your password is correct or not in k8s, by this command.

      ```bash
      kubectl get secret  kube-prometheus-stack-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
      ```

  * The password would be correct, but when you try to login it won't work, why ? cause the stack has already
    deployed the grafana and has no idea how to change the existing password in grafana.

  * To reproduce this, delete the kube stack and run the get secret command and you would see the password is i
    changed to the default one, which it shouldn't.

* Timeout Error while connecting to keycloak

  ```raw
  lvl=eror msg=login.OAuthLogin(NewTransportWithCode) logger=context userId=0 orgId=0 uname= error="Post \"https://keycloak.example.com/auth/realms/devops/protocol/openid-connect/token\": dial tcp 10.2.43.194:443: connect: connection timed out"                                                                                    │
  ```

* Relogin does not work as expected. (Happens randomly)

* Currently when you login and logout and login again (it fails here)
* The second login works (confirmed by looking at the logging session in keycloak)
* FIX:
    a. Logout all the session from the keycloak
    b. closed the browser (Now I was testing it in 'Private Mode')
    c. start a new browser and login again
