#! /bin/bash

set -x

export NETWORK_CIDR=10.2.0.0/16

kops create cluster --zones=eu-west-1a --name=k8s.ops.blackwoodseven.com\
 --state=s3://kops.blackwoodseven.com/ --networking=weave --topology=private\
 --api-loadbalancer-type=internal --ssh-access=10.0.0.0/8,172.16.0.0/12\
 --ssh-public-key=~/.ssh/kops.pub\
 --cloud-labels Cost\ Center=team-site-reliability,Maintaining\ Team=team-site-reliability,Purpose=BW7\ operations

