# Setup VM with wireguard installed and configured

1. Initialize terraform

   ```sh
   terraform init
   ```

2. Configure your client wg config by creating the public and private key

   ```sh
   wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
   ```

3. Pass this public key as `wg_client_pubkey` variable in `variables.tf` file

4. Plan your terraform

   ```sh
   terraform plan --var-file=terraform.tfvars
   ```

5. If the changes looks good to you then apply the changes

   ```sh
   terraform apply --var-file=terraform.tfvars
   ```

The above will configure the wireguard in the VM you created.
Now, you need to configure a client too so that you can connect to the server.
For that, you need to login to the VM and get its public key.
The public key must be stored in `/etc/wireguard/public.key` file.
Once you have the key you configure your local system. A sample config file will look like

```sh
[Interface]
PrivateKey = PRI-KEY
Address = wg_peer_address

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint  = SERVER_PUBLIC_IP:51820
AllowedIPs = wg_address
```

Here -

1. `PRIV-KEY` is the private key you generated in step 2.
2. `SERVER_PUBLIC_KEY` is the key you copied from server what was stored in server's `/etc/wireguard/public.key` file
3. `SERVER_PUBLIC_IP` is the server's public IP

Once you have configured the wireguard config file you now just enable and start the service

```sh
sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service
```

## Sample terraform vars file -

```text
location = "North Europe"
subnet_id = "/subscriptions/bd59662e-a78e-4/resourceGroups/obmondo-aks/providers/Microsoft.Network/virtualNetworks/obmondo-vnet/subnets/obmondo-subnet"
vm_name = "vpn-az1"
vm_size = "Standard_D2_v4"
resource_group = "obmondo-aks"
storage_account = "obmondo"
subscription_id = "bd59662esnwqoiqno"
domain = "example.com
tags = {}
admin_account_passwordstore_path = server/vpn-az1/admin
wg_client_pubkey = "HBu2xw9U9plaO6N/ySBcU"
wg_address = "10.0.0.1/24"
wg_peer_address = "10.0.0.2/24"
public_iface = "wg0"
```
