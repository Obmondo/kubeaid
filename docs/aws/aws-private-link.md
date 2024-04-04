# AWS Private Link

This document explains the steps and ideas surrounding AWS Private Link and how
to set it up for allowing access to services from a different AWS account.

## Alternatives

Alternative solutions to achieve cross account connectivity

- AWS Transit Gateway
- AWS Site-to-Site VPN
- VPC Peering
- Shared VPCs

[Ref #1](#references)

## Procedure

### AWS Private Link Setup

AWS Private Link is a regional service offered by AWS to allow connection between two VPCs.
Using AWS Private Link, requests can be routed via a Network Load Balancer to target groups
which can then resolve to specific backends serving the request.

AWS Private Link has certain advantages over the traditional cross account connectivity
solutions. The major ones are:

- One way traffic from consumer account to provider account
- No CIDR Overlap
- Traffic remains on AWS network and does not reach Public Internet
- IAM Permissions to fine tune access
- Private DNS
- Reuse of existing VPCs, security groups without significant modifications to existing resources

To keep things clear, we call the provider account - where the service being exposed is running,
and the consumer account - where the service needs to be consumed.

### Configuration on Provider Account

Assuming that the service being exposed is running on K8s, has a classic Load balancer and VPC.

#### Network Load Balancer

- Navigate to EC2 > Load Balancers in the AWS Console.
- Click on Create Load Balancer and select the type as Network Load Balancer.
- Give a Name and select the Scheme as Internal and IP address type as IPv4.
- Under Network Mapping, select the provider VPC where the microservice is hosted.
- Select the availabilty zones, preferably more than 1 and choose the subnet attached.
- Under Security groups, select the security groups that you want to attach to the NLB.
- Under Listeners and routing, select the protocol as TCP and port as 80 for HTTP connections.
- If you don't have a target group already, jump to [this section](#target-group) to create a target group
- Select the target group which will route the TCP packets on port 80 of the NLB.
- Add a new listener with protocol as TCP and port as 443 for HTTPS connections.
- Create/Select and attach target group which will route TCP packets on port 443 of the NLB.
- Click on Create Load Balancer and wait for the NLB to reach active state.

(Note: If you create a new target group, refresh the list on the create NLB page)

[Ref #2](#references)

#### Target Group

- Navigate to EC2 > Target Groups in the AWS Console.
- Click on Create Target Group and choose the target type as IP Addresses.
- Add a target group name, and choose the protocol and port same as the listener on the NLB (TCP:80).
- Select the IP address type as IPv4.
- Select the target VPC where the microservice is hosted.
- Select the protocol version as HTTP1.
- Click on Next at the bottom of the page.
- Add the IP addresses of the classic load balancer which is in front of the microservice. If you don't have
the IP address, use `dig +short my-microservice.example.com` to get the IP addresses associated with the load balancer.
- You will have multiple IPs if it is spread across multiple AZs.
- Add the port 80 or 443 based on what port you selected for the listener earlier and include the IPs in the pending list.
- Click on Create target group.
- Now, you can return back to the create NLB page and refresh the list of target groups.

[Ref #3](#references)

#### Endpoint Service

- Once the Network Load Balancer is active and both the Target Groups are created, verify if the registered targets
are Healthy or not before proceeding.
- Since the NLB is now provisioned, we need to create an Endpoint Service to allow connections to the provider VPC.
- Navigate to VPC > Endpoint Services in the AWS Console.
- Click on Create Endpoint Service.
- Add a name, and select the Load Balancer type as Network.
- Choose the NLB that you created from the Available Load Balancers list.
- Select Acceptance Required and IP address types as IPv4 under Additional Settings.
- Click on Create and wait till it reaches an Available state.
- If you want to whitelist certain accounts, add the ARN of the account under Allow principals. The format is
`arn:aws:iam::<aws-account-id>:<type>/<id>`
- If you want a private DNS name, you can add it via Actions > Modify Private DNS Name.
- Copy the Service Name of the Endpoint Service for later use in the Consumer account.

[Ref #4](#references)

### Configuration on Consumer Account

- Login to the Consumer Account on AWS.
- Navigate to VPC > Enpoints on AWS Console.
- Click on Create Endpoint.
- Add a name, and select Other Endpoint Services
- Paste the Endpoint Service Name from the Provider account and click on Verify.
- Select the consumer VPC from which you will be accessing the microservice.
- Select the security groups.
- Click on Create Endpoint.
- This will provision a VPC Endpoint but it will remain in Pending state until the request is
accepted by the provider account.
- Go to Provider Account and accept the request from VPC > Endpoint Services > Select your Endpoint Service >
Endpoint Connections > Select the connection > Actions > Accept Endpoint Connection Request.
- The Endpoint state will now be Available shortly.

[Ref #5](#references)

### Verification

To verify if we can connect to the microservice:

Spin up an EC2 instance in the consumer VPC.
Run these commands to find out if DNS is resolved correctly and connection can be established.
The DNS names are available in the VPC Endpoint, the first one would be the regional DNS name,
the remaining will be specific to AZ.

```shell
# Check if DNS is resolved correctly
$ dig +short vpce-0e12e5943757874a7-nv543yxu.vpce-svc-0102abd9edd3d2187.eu-west-1.vpce.amazonaws.com

# Check if network connection is possible on port 80
$ nc -zv vpce-0e12e5943757874a7-nv543yxu.vpce-svc-0102abd9edd3d2187.eu-west-1.vpce.amazonaws.com 80

# Check if network connection is possible on port 443
$ nc -zv vpce-0e12e5943757874a7-nv543yxu.vpce-svc-0102abd9edd3d2187.eu-west-1.vpce.amazonaws.com 443

# Do a curl request with Server Name Indication
$ host=my-microservice.example.com
$ target=vpce-0e12e5943757874a7-nv543yxu.vpce-svc-0102abd9edd3d2187.eu-west-1.vpce.amazonaws.com
$ ip=$(dig +short $target | head -n1)
$ curl -sv --resolve $host:443:$ip https://$host
```

## Cost Savings

- Load balance the requests to the same AZ.
- Have an subnet per AZ to save on cross AZ data costs.

Pricing per VPC endpoint per AZ ($/hour): $0.011
Data Processed per month ($/GB): $0.01

[Ref #6](#references)

## Caveats

- Endpoint services are available in the AWS Region in which they are created and can be accessed in
remote AWS Regions using inter-Region VPC peering.
- The private DNS of the endpoint does not resolve outside of the Amazon VPC.
- Availability Zone names in a customer account might not map to the same locations as Availability
Zone names in another account.
- Traffic will be sourced from the Network Load Balancer inside the service provider Amazon VPC. When
service consumers send traffic to a service through an interface endpoint, the source IP addresses
provided to the application are the private IP addresses of the
Network Load Balancer nodes, and not the IP addresses of the service consumers.
- 20 VPC endpoints per VPC (you can increase this to 40)
- 10 Gbps throughput per VPC endpoint elastic network interface, although this can burst higher upto 40Gbps

## Further Reading

- [AWS Private Link](https://docs.aws.amazon.com/vpc/latest/privatelink/what-is-privatelink.html)
- [Best Practices for AWS Private Link](https://www.youtube.com/watch?v=85DbVGLXw3Y)
- [Securely Access with AWS Private Link](https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/aws-privatelink.html)
- [Use Case with Route53 Resolver and Transit Gateway](https://aws.amazon.com/blogs/networking-and-content-delivery/integrating-aws-transit-gateway-with-aws-privatelink-and-amazon-route-53-resolver/)
- [Cross Account VPC access](https://tomgregory.com/aws/cross-account-vpc-access-in-aws/)
- [IAM with AWS Private Link](https://docs.aws.amazon.com/vpc/latest/privatelink/security_iam_service-with-iam.html)
- [AWS Private Link Quotas](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-limits-endpoints.html)
- [Sharing Services using AWS Private Link](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html)
- [Architecture and Use Case Patterns](https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/use-case-examples.html)
- [Considerations while deploying AWS Private Link](https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/deploying-aws-privatelink.html)
- [High Availablity for Endpoint Services](https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/creating-highly-available-endpoint-services.html)
- [Private DNS Names for Endpoint Services](https://docs.aws.amazon.com/vpc/latest/privatelink/manage-dns-names.html)

## References

1) [Connecting service across AWS accounts](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/networking-connecting-services-crossaccount.html)
2) [Network Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancers.html)
3) [Target Groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html)
4) [Endpoint Service](https://docs.aws.amazon.com/vpc/latest/privatelink/privatelink-share-your-services.html)
5) [VPC Endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html)
6) [AWS Private Link Pricing](https://aws.amazon.com/privatelink/pricing/)
