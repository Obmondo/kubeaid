Need s3 full perms, so attach the s3 policy to particular user

## These are some sane default
```
## Defaults
cluster_name           = "k8s.staging.example.dk"
domain_name            = "example.dk" # tld
region                 = "eu-west-1"
cidr                   = "10.0.0.0/16"
azs                    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
environment            = "staging"
kops_state_bucket_name = "companyid-kops-state"
ingress_ips            = ["10.0.0.100/32", "10.0.0.101/32"]
```

terraform init
terraform plan --var-file /path/to/values.tfvars
terraform apply --var-file /path/to/values.tfvars

## NOTE:
The above command fails due to following reason.

* your laptop can not access k8s directly
* so helm install would fails

Solution

kops export kubeconfig --name <cluster_name> --admin
ssh -D 9094 ubuntu@bastion.<cluster_name>
edit the .kube/config
add proxy-url: socks5://localhost:9094

kubectl get pods -A
kops validate cluster --wait 10m

