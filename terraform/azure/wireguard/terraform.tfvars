#Example of a configuration file

location = "North Europe"
vm_name = "vpn-prod"
vm_size = "Standard_D2_v4"
wg_resource_group = "alz-network-hub"
storage_account = "wireguardprodbucket"
subscription_id = "c7991525-4989-4a96-bafb-1a2d2e9618ca"
domain = "obmondo.net"
tags = {}
admin_account_passwordstore_path = "obmondo/vpn-prod/user/ubuntu"
wg_client_pubkey = "97c6GTiYkGEsEm++U7J4JcgpHFt8xhJethQZ0U0w6HM="
wg_address = "10.0.0.1/24" 
wg_peer_address = "10.0.0.2/24"
public_iface = "wg0"
wg_peers = [ {
    name = "peer1"
    public_key = "97c6GTiYkGEsxdfdfdfeeeeeethQZ0U0w6HM="
    allowed_ips = "10.0.0.2/24"
    }]