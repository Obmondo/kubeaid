# Setup Wireguard VPN Server

  NOTE: This is an optional step, if you are using an existing setup for vpn.
  You can skip this step

  1. Configure your AWS profile

     ```sh
     export AWS_PROFILE=default
     ```

  2. Create a sample yaml file config, [value.yaml](./value.yaml)

  3. Export the values.yaml file

     ```sh
     export OBMONDO_VARS_FILE=/path/to/yaml/values/file
     ```

  4. Setup wireguard instance

     ```sh
     # cd terragrunt/wireguard/aws

     # terragrunt apply

     Remote state S3 bucket <some-name>-terraform does not exist or you don't have permissions to access it. Would you like Terragrunt to create it? (y/n) y
     ```

  5. Generate wireguard public and private key

     ```sh
     wg genkey | sudo tee client-private_key | wg pubkey | sudo tee client-public_key
     ```

  6. Setup your wireguard client and make sure it works

     ```sh
     # This below command should work
     sudo wg
     ```
