# Terragrunt

## Overview

* Configure your kubernetes cluster on Azure (AKS) and on AWS (Kops) for now (more cloud provider support are coming soon)
  with one single command.

  ```sh
  terragrunt run-all apply
  ```

* The cluster are private and terragrunt will setup a wireguard instance, which will be the only gateway i
  to access your kubernetes

## Prerequisite

  1. Need this package to be installed on your local machine

     ```text
      kops
      kubectl
      jq
      terragrunt
      terraform
      bcrypt
      wireguard
     ```

  2. Git repository
     a. clone the k8id git repo from obmondo
     b. Create a fresh git repo (for better naming, we usually call it k8id-config)

### Setup Kubernetes cluster on AWS with Kops

  1. Generate argocd password

     ```sh
     export TF_VAR_argocd_admin_password=lolpass
     ```

  2. Generate a bcrypt hash with the above password and add this in the yaml config file

     ```sh
     bcrypt-tool hash $TF_VAR_argocd_admin_password 10
     ```

  3. Configure your AWS profile

     ```sh
     export AWS_PROFILE=default
     ```

  4. Create a sample yaml file config

     ```yaml
     cluster_name: "k8s.test.your-domain.com"
     argocd_admin_bcrypt_password: $2a$10$HE0QmzaxLGbvDJ5Q105ww.KbO0FWPvORFybRP6MUdMejEBw3A7WL.
     domain_name: "your-domain.com"
     region: eu-west-1
     environment: "test"
     kops_state_bucket_name: "kops.your-domain.com"

     admin_ssh_keys:
       - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAhxkaT6cj+uRLA/wWu5d+5yun6NQXeUOE0tqGi6H8Dn3ZqC6wlYK7uHwOxZILJGa4X/kzGWHlZ6wfZw6lgbqunkJHLf3oXXI1cJGBkzPVBYkCnJItSP19fAty5C//SxNYlngicf+vowWdlq6O4ECkH7NdmVne4MHYz2DpRMjobjKDB1OW/0ESBlZhxzevwNnNqVdwXoz8852PQqo41w/uUAx5393Wj/VF2WB20HDWy97Ye6m3eV+ZMGiTJkumaNQ7JPdRTeNpl8zPwLJ0X0FS4H8z7wGfrUpVzlGuXjSGN3TxTewEW2WnD5yL0XRZznVBGARH71ut23VtFS8Fo8xsPn1ePjHho2BBviAxQ2ACp4UkzMt40lQNR7jtNZY/e2ZYMRVfJ+3cJgGfiwBfDjo6fgdPZowmGMJa0ydKT/WTt5LjEIiACFUMrMwn8yauXHybZCnUCduY/9AqSqh3ut0fKOsUS4tjj6/UUGDOjHE60nOvv3P7vCHQZqoznxC6oirYbTCCqQAK4Gm7vyNvzA5ep/4xMcp3vJVIKMj9z3sCSuvQYD2NsuC3H128FUYNjQMt2Z8dFO0oWme/x8Ghj9KEPLHGk452gif0JNzAgRRsXVmvGClx5XrrTa0jBAn7uT9DOZYMRPKYM7bluR2RtjHY1creHuH1DXTY3xaoUX65lw== cardno:000604694743"

     argocd_admin_bcrypt_password: $2a$10$8oIzQev13jNKTAdRs3GnG.u8fsQtYjd10dXRaDr0uVCA3i5t/rwYm
     wg_peers:
       - name: "ashish_workstation"
         public_key: "FNxRMgoHQg2Ovt4mz1yo7aJ/7WN5aRg/qVwYVg5qrl0="
         allowed_ips: "172.16.16.2"

     argocd_repos:
       k8id:
         url: "git@github.com:org/k8id.git"
         ssh_private_key: "/path/to/your/ssh/private_key/id_ecdsa"
       k8id-config:
         url: "git@github.com:org/k8id-config.git"
         ssh_private_key: "/path/to/your/ssh/private_key/id_ecdsa"
     ```

  5. Create a yaml config file with details

     ```sh
     export OBMONDO_VARS_FILE=/path/to/yaml/values/file
     ```

  6. Setup wireguard instance

     ```sh
     # cd terragrunt/wireguard/aws

     # terragrunt apply

     Remote state S3 bucket <some-name>-terraform does not exist or you don't have permissions to access it. Would you like Terragrunt to create it? (y/n) y
     ```

  7. Generate wireguard public and private key

     ```sh
     wg genkey | sudo tee client-private_key | wg pubkey | sudo tee client-public_key
     ```

  8. Setup your wireguard client and make sure it works

  9. Deploy the cluster

     ```sh
     cd terragrunt/kops

     terragrunt run-all apply
     INFO[0000] The stack at /home/ashish/k8id-all/k8id/terragrunt/kops will be processed in the following order for command apply:
     Group 1
     - Module /home/ashish/k8id-all/k8id/terragrunt/kops/vpc

     Group 2
     - Module /home/ashish/k8id-all/k8id/terragrunt/kops/peering

     Group 3
     - Module /home/ashish/k8id-all/k8id/terragrunt/kops/kops

     Group 4
     - Module /home/ashish/k8id-all/k8id/terragrunt/kops/iam

     Group 5
     - Module /home/ashish/k8id-all/k8id/terragrunt/kops/helm

     Are you sure you want to run 'terragrunt apply' in each folder of the stack described above? (y/n) y
     ```
