
## Create a VM with gitlab server setup and running

**TODO:** Add an introduction, describing what you are going to do here

Start with initializing your terraform providers

```sh
terraform -chdir=cluster-setup-files/terraform/gitlab-ci-server init
```

```sh
terraform -chdir=<dir location of main.tf file> plan -var-file=<config file location>
```

Check if everything looks good to you, when it does you can go ahead and apply

```sh
terraform -chdir=<dir location of main.tf file> apply -var-file=<config file location> -auto-approve
```

If you are in the same dir as `main.tf` file then you don't need to pass the `chdir` flag

Look at the `variables.tf` file to see what all variables your config file must have.

### Example

Sample config file `example.tfvars`
**TODO:** Describe what the configuration keys mean

```text
gitlab_vm_name = "obmondo-gitlab"
location = "North Europe"
resource_group_name = "obmondo-aks"
create_public_ip = true
vnet_name = "obmondo-vnet"
vnet_address_space = "10.240.0.0/16"
subnet_name = "obmondo-subnet"
subnet_prefixes = "10.240.0.0/16"
vm_size = "Standard_DS2_v2"
dns_label = ""
source_addresses = ["109.238.49.194", "95.216.10.96", "109.238.49.196"]
```

To get all the available locations run

```sh
az account list-locations -o table
```

The config file is present in your respective `kubeaid-config` repo. So, you must clone and provide that file. If I am
standing in the `kubeaid` repo then my commands will be

```sh
terraform -chdir=cluster-setup-files/terraform/gitlab-ci-server plan -var-file=../kubeaid-config/vms/gitlab.tfvars
```

```sh
terraform -chdir=cluster-setup-files/terraform/gitlab-ci-server apply -var-file=../kubeaid-config/vms/gitlab.tfvars -auto-approve
```