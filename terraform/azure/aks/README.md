# Setting up the AKS cluster

```sh
terraform -chdir=aks plan -var-file=aks.tfvars
```

```sh
terraform -chdir=aks apply -var-file=aks.tfvars
```
