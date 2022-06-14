#! /bin/bash

echo "Installing WireGuard"
sudo apt update && apt -y install net-tools wireguard
echo "WireGuard installed"

# Inspiration taken from https://github.com/vainkop/terraform-aws-wireguard/blob/master/templates/user-data.txt
echo "Creating WireGuard configuration"
sudo mkdir -p /etc/wireguard
sudo cat > /etc/wireguard/wg0.conf <<- EOF
[Interface]
PrivateKey = ${wg_server_private_key}
ListenPort = ${wg_server_port}
Address = ${client_network_cidr}
PostUp = sysctl -w -q net.ipv4.ip_forward=1
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ENI -j MASQUERADE
PostDown = sysctl -w -q net.ipv4.ip_forward=0
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ENI -j MASQUERADE

${wg_peers}
EOF

# Make sure we replace the "ENI" placeholder with the actual network interface name
export ENI=$(ip route get 8.8.8.8 | grep 8.8.8.8 | awk '{print $5}')
sudo sed -i "s/ENI/$ENI/g" /etc/wireguard/wg0.conf

echo "WireGuard configuration created at /etc/wireguard/wg0.conf"

# Launch the WireGuard server
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0
echo "WireGuard launched"
