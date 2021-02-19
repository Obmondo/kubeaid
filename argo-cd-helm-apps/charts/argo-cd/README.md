#Docs on argo-cd yaml config
https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/

# creating secret with ssh public key (for use in f.ex. repositories in argocd)
kubectl create secret generic ssh-key-secret --from-file=ssh-privatekey=/path/to/.ssh/id_rsa --from-file=ssh-publickey=/path/to/.ssh/id_rsa.pub
