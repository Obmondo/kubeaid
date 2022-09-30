# Troubleshooting

Q1. How do I validate with debug mode ?

```sh
# kops validate cluster your.cluster.name --wait 2m --logtostderr -v 10
```

Q2. Whats the lowest instance type is required
Instance type should be greater then t4g.small (lower then this, cluster setup would fail)

Q3. My cluster installation failed, what to do ?

- Delete the cluster

```sh
# kops delete cluster k8s.enableittest.example.com --yes
```

- Delete the security group `<environment>-k8s_api_http` from the aws console
- Delete the kops directory from the terraform state bucket (s3) <-- WATCH OUT and don't delete
  anything wrong. if consuded then download the json file :)

Q4. How do I import my existing KOPS s3 bucket ?

```sh
terragrunt import aws_s3_bucket.kops_state kops.example.com
```

Q5. How can I upgrade minor version of k8s cluster

- Just update the kubernetes_version in the yaml file

```sh
cd terragrunt/kops/kops
terragrunt plan
terragrunt apply
```

Q6. How can I upgrade major version of k8s cluster

- You can, just make sure you are on latest version of current major version

Q7. I ran `terragrunt run-all apply` and ended up with this error.

```raw
│ Error: cannot find CA certificate
│
│   with data.kops_kube_config.kube_config,
│   on main.tf line 234, in data "kops_kube_config" "kube_config":
│  234: data "kops_kube_config" "kube_config" {
│
```

- It failed due to missing kube config, but cluster should be ready.
- check the ec2 instance on aws console
- Export the kube config for cluster

```sh
kops export kubecfg k8s.enableittest.example.com --admin`
```

- Check the nodes

```sh
kubectl get nodes -o wide`
```
