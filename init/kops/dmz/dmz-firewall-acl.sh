#!/usr/bin/env bash

VPCID=$(aws ec2 describe-vpcs | jq -re '.Vpcs[] | select(.CidrBlock=="10.5.0.0/16") | .VpcId')
echo The DMZ VPC is: $VPCID

ACL=$(aws ec2 describe-network-acls | jq --arg vpcid $VPCID -re '.NetworkAcls[] | select(.VpcId==$vpcid) | .NetworkAclId')
ACL_NUM=$(echo $ACL| wc -w)

if [ $ACL_NUM -ne 1 ]; then
  echo We found $ACL_NUM ACL entries in the DMZ VPC. But this script only supports 1
  exit 1
fi

echo The ACL is: $ACL


ENTRIES=$(aws ec2 describe-network-acls --network-acl-ids $ACL | jq -e '.NetworkAcls[0].Entries')

# Delete all existing rules from the ACL
for RULE in $(echo $ENTRIES | jq -e '.[] | select(.Egress==true)  | select(.RuleNumber!=32767) | .RuleNumber'); do
  echo Deleting egress rule $RULE
  aws ec2 delete-network-acl-entry --egress  --network-acl-id $ACL --rule-number $RULE
done
for RULE in $(echo $ENTRIES | jq -e '.[] | select(.Egress==false) | select(.RuleNumber!=32767) | .RuleNumber'); do
  echo Deleting inress rule $RULE
  aws ec2 delete-network-acl-entry --ingress --network-acl-id $ACL --rule-number $RULE
done

echo Adding egress rule 1
aws ec2 create-network-acl-entry --network-acl-id $ACL --egress \
  --protocol 6 --cidr-block "10.2.0.0/16" --port-range From=0,To=1023 \
  --rule-action deny  --rule-number 1

echo Adding egress rule 2
aws ec2 create-network-acl-entry --network-acl-id $ACL --egress \
  --protocol 6 --cidr-block "0.0.0.0/0"   --port-range From=80,To=80 \
  --rule-action allow --rule-number 2

echo Adding egress rule 3
aws ec2 create-network-acl-entry --network-acl-id $ACL --egress \
  --protocol 6 --cidr-block "0.0.0.0/0"   --port-range From=443,To=443 \
  --rule-action allow --rule-number 3

echo Adding egress rule 4
aws ec2 create-network-acl-entry --network-acl-id $ACL --egress \
  --protocol 6 --cidr-block "0.0.0.0/0"   --port-range From=1024,To=65535 \
  --rule-action allow --rule-number 4

echo Adding egress rule 5
aws ec2 create-network-acl-entry --network-acl-id $ACL --egress \
  --protocol 1 --cidr-block "0.0.0.0/0"   --icmp-type-code Code=-1,Type=3 \
  --rule-action allow --rule-number 5



echo Adding ingress rule 1
aws ec2 create-network-acl-entry --network-acl-id $ACL --ingress \
  --protocol 6 --cidr-block "10.255.255.0/24" --port-range From=22,To=22 \
  --rule-action allow --rule-number 1

echo Adding ingress rule 2
aws ec2 create-network-acl-entry --network-acl-id $ACL --ingress \
  --protocol 6 --cidr-block "0.0.0.0/0"   --port-range From=80,To=80 \
  --rule-action allow --rule-number 2

echo Adding ingress rule 3
aws ec2 create-network-acl-entry --network-acl-id $ACL --ingress \
  --protocol 6 --cidr-block "0.0.0.0/0"   --port-range From=443,To=443 \
  --rule-action allow --rule-number 3

echo Adding ingress rule 4
aws ec2 create-network-acl-entry --network-acl-id $ACL --ingress \
  --protocol 6 --cidr-block "0.0.0.0/0"   --port-range From=1024,To=65535 \
  --rule-action allow --rule-number 4

echo Adding ingress rule 5
aws ec2 create-network-acl-entry --network-acl-id $ACL --ingress \
  --protocol 1 --cidr-block "0.0.0.0/0"   --icmp-type-code Code=-1,Type=3 \
  --rule-action allow --rule-number 5

