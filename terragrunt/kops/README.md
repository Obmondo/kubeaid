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
