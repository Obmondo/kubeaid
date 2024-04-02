# Setup VM with wireguard installed and configured

## Prequisites

- [Go pass](https://github.com/gopasspw/gopass/blob/master/docs/setup.md#ubuntu-debian-deepin-devuan-kali-linux-pardus-parrot-raspbian)
- [Wireguard](https://wireguard.how/client/debian/)

1. Initialize terraform

   ```sh
   terraform init
   ```

2. Configure your client wg config by creating the public and private key which will be passed to the vm

   ```sh
   wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
   ```

3. Pass the values for `wg_peers` variable in the `terraform.tfvars` file

   ```sh
   wg_peers = [ {
    name = "<Peer name>>"
    public_key = "<Client public key>>"
    allowed_ips = "<Ip range>"
    }]
   ```

   Example [terraform.tfvars.example](./terraform.tfvars.example)

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
vm_name = "vpn-prod"
vm_size = "Standard_D2_v4"
wg_resource_group = "alz-network-hub"
storage_account = "wireguardprodbucket"
subscription_id = ""
domain = "obmondo.net"
tags = {}
admin_account_passwordstore_path = "cluster/vpn-prod/user/ubuntu"
wg_address = "10.0.0.1/24" 
wg_peer_address = "10.0.0.2/24"
public_iface = "wg0"
wg_peers = [ {
    name = "peer1"
    public_key = "97c6GTiYkGxxxxxsthQZ0U0w6HM="
    allowed_ips = "10.0.0.2/24"
    }]
```
