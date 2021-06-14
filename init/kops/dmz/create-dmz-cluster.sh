#! /bin/bash

# For version comparison
function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

KOPS=$(kops version | cut -d ' ' -f 2)

if [ "$(version "$KOPS")" -ge "$(version "1.20")" ]; then
  echo "Kops version $KOPS is good"
else
  echo "This script needs at least kops 1.20"
fi

set -x

kops create cluster --zones=eu-west-1c --name=k8s.dmz.blackwoodseven.com\
 --state=s3://kops.blackwoodseven.com/ --networking=calico --topology=private\
 --api-loadbalancer-type=internal --api-loadbalancer-class=network\
 --ssh-access=10.0.0.0/8,172.16.0.0/12 --ssh-public-key=kops.pub\
 --cloud-labels Cost\ Center=team-site-reliability,Maintaining\ Team=team-site-reliability,Purpose=BW7\ DMZ\
 --network-cidr=10.5.0.0/16
