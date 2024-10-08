# Current options that are supported by terragrunt

```yaml
# Cluster name
cluster_name: "k8s.enableittest.example.com"

# Terraform Bucket name
terraform_bucket: bw7-terraform-kubeaid

# Do you want peering
skip_peering: true

# Domain name
domain_name: "example.com"

# API DN Zone
api_dns_zone: "exampletest.com"

# Env for k8s cluster
environment: "enableittest"

# KOPS bucket name
kops_state_bucket_name: "kops.example.com"

# Kubernetes Version
kubernetes_version: 1.20.10

# Region
region: eu-west-1

# CIDR range
cidr: 10.9.0.0/16

# Private Subnets
private_subnets:
  - 10.9.32.0/19
  - 10.9.64.0/19
  - 10.9.96.0/19

# Public Subnets
public_subnets:
  - 10.9.0.0/22
  - 10.9.4.0/22
  - 10.9.8.0/22

# Ingress IP Block
ingress_ips:
  - 10.9.0.100/32
  - 10.9.0.101/32

# List of ssh pub keys to be added on the server
admin_ssh_keys:
  - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAhxkaT6cj+uRLA/wWu5d+5yun6NQXeUOE0tqGi6H8Dn3ZqC6wlYK7uHwOxZILJGa4X/kzGWHlZ6wfZw6lgbqunkJHLf3oXXI1cJGBkzPVBYkCnJItSP19fAty5C//SxNYlngicf+vowWdlq6O4ECkH7NdmVne4MHYz2DpRMjobjKDB1OW/0ESBlZhxzevwNnNqVdwXoz8852PQqo41w/uUAx5393Wj/VF2WB20HDWy97Ye6m3eV+ZMGiTJkumaNQ7JPdRTeNpl8zPwLJ0X0FS4H8z7wGfrUpVzlGuXjSGN3TxTewEW2WnD5yL0XRZznVBGARH71ut23VtFS8Fo8xsPn1ePjHho2BBviAxQ2ACp4UkzMt40lQNR7jtNZY/e2ZYMRVfJ+3cJgGfiwBfDjo6fgdPZowmGMJa0ydKT/WTt5LjEIiACFUMrMwn8yauXHybZCnUCduY/9AqSqh3ut0fKOsUS4tjj6/UUGDOjHE60nOvv3P7vCHQZqoznxC6oirYbTCCqQAK4Gm7vyNvzA5ep/4xMcp3vJVIKMj9z3sCSuvQYD2NsuC3H128FUYNjQMt2Z8dFO0oWme/x8Ghj9KEPLHGk452gif0JNzAgRRsXVmvGClx5XrrTa0jBAn7uT9DOZYMRPKYM7bluR2RtjHY1creHuH1DXTY3xaoUX65lw== cardno:000604694743 Ashish"
  - "ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgjmqOC7ghLNqK6CkD7YTpCw4rpC5CblAndACCpZ+3xXnT8qrNDxzCVj1O2QnWQw8w0J4WUBKhePClAlF3HUnXPxvBzAFGlxrkdfS6ndAy4T/Ew1healjxDF7mOcuDwoBPuLVEXwPYJ3OFUrOKajRcvP85AGO0MYAbVyVg/ANsiTmVp+T70UfHtYG6MQdTIO+wpcHAgHFV/yotaQTKNA5HpvbxP5qdjrlas1T5XXBoKV9HVXL0ipTBj4OFNFYF+FDKVfdM4MvrktFXzzGHGWtn/QkWxMvPOrnKFRhxvFse0YyKOV5wLtsdjdX23NKgC6skayAFiY/+T2Y5mcnIz3zOm0hCOtdVpaajWfJyIrSKz4UmuGtCfdyX4jqLOgtqByHGwMzHtkjfr3m+eqDvxyRLlEIEpITYdkIe2t5emeBTKHl2NrrC7btvL4Awz4azKkdTDgdXl7FUgL2537N8EYnQ8DHZrImsJkpV+hIwwSuZAGr6enfrObYTzyWbEo0HttXbot9iNWNjcf5aLZTNoPSM+gE/C3BTJs4ykjM9Aq1SC9qQwqeXvvv3x529tOW0SnrohVnNFn/Z41+nfYK6TC5ZNihBdKXkBQUi9YaLJs0jlYg9aDA0fhYDYr8OJOT1xRUwm/zfM7Je6QykS2fqAQRUEWknmfshVHrzY61IeSbWhQ== cardno:000606305931 Klavs`"
  - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQD0xNXDwqOd7g394DitNlxz4YLJ8c8aPEZfPWskuF1s0IC5TLW/ymWtWpgfktU1BgkQWF5xE3QirqEZHdrLPFyBn7EgHq+IdPWUxxfoAHuH1FG7+xkRmfN+HPqgoDSi7PJefJ82NIepCiS78WBgFmgTJTKcF1CRaXangJSKoly5B6rQA8sk+MkotSAhjZhQYBxFbVB6BNjiC6Ui5p2h81crR5MLsPo8RHB4Dk9JkSzC++x+QwgSWCxztuR936h/gP+q6utsRqYT9vRr+BYmgN58uWbDeT1uUWVmQKyN3iWyEDjFa9Z8ZscdQqekb6NaxxUquRVVEhCDho244y7PR4pzHafISiMgaR/MShX2Yh5pAnKGRR5hyNm9bwjtQnXR7+7lTIzKsFgxgqg6DJTxkvqLPCT15MXDKK2SBGZUo9aIRwmPZeA8rLxTYC50adm2Cdn1KgfjtYvomupxBtxQkzNPsaEDiivRbLjMx2uovkXaRfNRr0BX73Of6iBTrzuhnI5iUcRO/lP0x/3aWNl38w4qRtCcWywyf1ugaphG7a6f3NHtvUeYPA3YMpV45tM1cqSQ3lM3qCz9oeH/3JrLNU36PBL0PRPKGDjNhtEALUY7R0GpDDsY6OYtXNAv1cGbOkr+q4rZg1qwOjAnm0q/0//yiocxxiH3Z4cZSPTUX95Q== cardno:000606914847 Aman"

# Master node configuration
master:
  machine_type: t4g.small
  image_id: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-20220404
  max_size: 1
  min_size: 1

# Worker node Configuration

worker:
  machine_type: t2.micro
  image_id: 099720109477/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220404
  max_size: 2
  min_size: 1
```
