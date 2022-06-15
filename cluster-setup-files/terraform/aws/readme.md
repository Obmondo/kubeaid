# Terraform to setup K8s cluster using Kops (works only with AWS)

## Setup Permissions

https://kops.sigs.k8s.io/getting_started/aws/

## Defaults settings

```sh
cluster_name           = "k8s.staging.example-dev.com"
domain_name            = "example-dev.com"
environment            = "staging"
region                 = "eu-west-1"
cidr                   = "10.0.0.0/16"
azs                    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
environment            = "staging"
kops_state_bucket_name = "companyid-kops-state"
ingress_ips            = ["10.0.0.100/32", "10.0.0.101/32"]

wg_server_public_key   = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# Supports only one key for now1
admin_ssh_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAhxkaT6cj+uRLA/wWu5d+5yun6NQXeUOE0tqGi6H8Dn3ZqC6wlYK7uHwOxZILJGa4X/kzGWHlZ6wfZw6lgbqunkJHLf3oXXI1cJGBkzPVBYkCnJItSP19fAty5C//SxNYlngicf+vowWdlq6O4ECkH7NdmVne4MHYz2DpRMjobjKDB1OW/0ESBlZhxzevwNnNqVdwXoz8852PQqo41w/uUAx5393Wj/VF2WB20HDWy97Ye6m3eV+ZMGiTJkumaNQ7JPdRTeNpl8zPwLJ0X0FS4H8z7wGfrUpVzlGuXjSGN3TxTewEW2WnD5yL0XRZznVBGARH71ut23VtFS8Fo8xsPn1ePjHho2BBviAxQ2ACp4UkzMt40lQNR7jtNZY/e2ZYMRVfJ+3cJgGfiwBfDjo6fgdPZowmGMJa0ydKT/WTt5LjEIiACFUMrMwn8yauXHybZCnUCduY/9AqSqh3ut0fKOsUS4tjj6/UUGDOjHE60nOvv3P7vCHQZqoznxC6oirYbTCCqQAK4Gm7vyNvzA5ep/4xMcp3vJVIKMj9z3sCSuvQYD2NsuC3H128FUYNjQMt2Z8dFO0oWme/x8Ghj9KEPLHGk452gif0JNzAgRRsXVmvGClx5XrrTa0jBAn7uT9DOZYMRPKYM7bluR2RtjHY1creHuH1DXTY3xaoUX65lw== cardno:000604694743"

wg_peers               = [
  {
    name        = "ashish_workstation",
    public_key  = "FNxRMgoHQg2Ovt4mz1yo7aJ/7WN5aRg/qVwYVg5qrl0="
    allowed_ips = "172.16.16.2"
  },
  {
    name        = "aman_workstation",
    public_key  = "HBu2xw9U9plaO6N/ySBcUQIwiOlf1fTSb7sbCAnWSHw="
    allowed_ips = "172.16.16.3"
  },
  {
    name        = "ashish_laptop",
    public_key  = "N9YI8P86ZqEIQKLpI8pAKTtX79LPfDb0+qYC9y1kbzw="
    allowed_ips = "172.16.16.4"
  }
]

argocd_repo            = {
  k8id = {
    url             = "git@github.com:example/k8id.git"
    ssh_private_key = id_ecdsa
  },
  k8id-config = {
    url             = "git@github.com:example/k8id-config.git"
    ssh_private_key = id_ecdsa
  }
}
```

## Installation

```sh
export TF_VAR_wg_server_private_key=your-wg-private-key
export AWS_PROFILE=profile name # your profile name when you did aws configure
export KOPS_STATE_STORE=s3://kops.example.com # S3 bucket name where kops will store the state file

terraform init
terraform plan --var-file /path/to/values.tfvars
terraform apply --var-file /path/to/values.tfvars
```

## How to add your workstation into wireguard

* Generate the pub and private key for client

```sh
sudo apt install wireguard-tools
wg genkey | tee client1-privatekey | wg pubkey > client1-publickey
```

```sh
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = THIS_WOULD_BE_THE_IP_OF_YOUR_CLIENT

[Peer]
PublicKey = WG_SERVER_PUBLIC_KEY
Endpoint  = WG_SERVER_PUBLIC_IP:51820
AllowedIPs = THIS_WOULD_BE_YOUR_VPC_CIDR
```

```sh
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service
```

## Cavets

* It can not support to add more then 1 ssh pub key (it will be fixed in future)
* wireguard ec2 instance has no ssh key added (its added manually for now, will be fixed in future)
  so simply give me your wg public key and I will add it manually
* Argocd is simply deployed, you will have to manually add the repo (it will be fixed in future)

## Troubleshooting

* You might encounter that sometime that cluster is not accessible ?
  Check the wireguard status locally on your client

  ```sh
  curl -L -k -v https://api.k8s.staging.example.com/api/v1/nodes
  ```

  If the above is NOT working, login onto wireguard client
  and run the above command and see if you can reach k8s from wireguard node.

* Wireguard is not working
  You can still access the k8s api using socks5 proxy

  ```sh
  ssh -D 9094 ubuntu@wg.staging.example.com
  ```

  edit the .kube/config
  add proxy-url: socks5://localhost:9094
