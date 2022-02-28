# Cert Manager setup

* cert manager needs a clusterissuer object, which is usually present in argocd-k8sconfig
* the ClusterIssuer object refers to a privateKeySecretRef which is sealed and needs to be pushed to the git repo
* you can use the existing cert from other cluster and re kubeseal and push it to git repo

NOTE: Havent looked onto how to get the tls cert, but here is the doc for Route53 https://cert-manager.io/docs/configuration/acme/dns01/route53/
