# Helm Variables

```sh
k8s_client_certificate: This the cert of your aks cluster. If you created the cluster using terraform/terragrunt then you just `terraform output
client_certificate`. Else if you have the existing aks cluster - then you can find this in the kube_config file

k8s_client_key: This the key of your aks cluster. If you created the cluster using terraform/terragrunt then you just `terraform output client_key`. Else if you have the existing aks cluster - then you can find this in the kube_config file

k8s_cluster_ca_certificate: This the key of your cluster ca cert.If you created the cluster using terraform/terragrunt then you just `terraform output cluster_ca_certificate`. Else if you have the existing aks cluster - then you can find this in the kube_config file

k8s_host: This the key of your cluster host address.If you created the cluster using terraform/terragrunt then you just `terraform output private_fqdn`. Else if you have the existing aks cluster - then you can find this in the kube_config file
```
