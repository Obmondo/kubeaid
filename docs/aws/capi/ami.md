# Demonstrating KubeAid (part 0) - Building a custom ARM64 based Ubuntu 24.04 AMI for ClusterAPI, targetting latest Kubernetes version v1.31.0

When working in AWS, ClusterAPI requires custom AMIs for the VMs that host the Kubernetes cluster. These AMIs must include essential tools like `kubeadm`, `kubelet`, `containerd` etc. pre-installed.

These custom AMIs are built using the the [image-builder](https://github.com/kubernetes-sigs/image-builder) project. While the Kubernetes SIG team provides [pre-built AMIs](https://cluster-api-aws.sigs.k8s.io/topics/images/built-amis), they currently **lack support for ARM CPU architecture and the recent versions of Kubernetes and Ubuntu**.

To address this, we have [forked](https://github.com/Obmondo/image-builder) the image-builder project and added support for the above.

This blog post will guide you through : how to build a custom ARM64 based Ubuntu 24.04 AMI for ClusterAPI, targetting the latest Kubernetes version v1.31.0.

## VPC setup

We need to setup a VPC with a `public subnet`, where the `AMI builder instance` will be spun up.
> You can skip this step, if you already have a similar setup.

We have written up a [Terraform module](https://github.com/Obmondo/kubeaid/tree/master/build/image-builder-vpc-setup), which you can use to create the setup.

First, clone the KubeAid repo and cd into the [image-builder-vpc-setup](https://github.com/Obmondo/kubeaid/tree/master/build/image-builder-vpc-setup) directory :

```sh
git clone https://github.com/Obmondo/KubeAid
cd ./KubeAid/build/image-builder-vpc-setup
```

Specify the Terraform variables by creating a `terraform.tfvars` file.
> You can refer to an example terraform.tfvars file we've added [here](https://github.com/Obmondo/kubeaid/tree/master/build/image-builder-vpc-setup/terraform.tfvars.example).

Next, run these commands :

```sh
terraform init
terraform plan
terraform apply
```

Once done, you'll see the VPC and Subnet ids in the output. Note them down.

## Building the AMI

> Before moving any further, make sure you have your AWS credentials exported as environment variables.

Clone our [image-builder fork](https://github.com/Obmondo/image-builder) locally :

```sh
git clone https://github.com/Obmondo/image-builder
```

To install the prerequisites like Packer and Ansible, run this command :

```sh
make deps-ami
```

Open [image-builder/images/capi/packer/ami/ubuntu-2404-arm64.json](https://github.com/Obmondo/image-builder/blob/main/images/capi/packer/ami/ubuntu-2404-arm64.json) and update the following fields with your specific values :

- `aws_region` : The AWS region where you have the VPC setup.

- `vpc_id` and `subnet_id` : the once that you've copied from the Terraform output in the previous step.

- `ssh_keypair_name` and `ssh_private_key_file`

		You can generate an AWS SSH Keypair using this command :
		```sh
		aws ec2 create-key-pair \
			--key-name kubeaid-demo \
			--query 'KeyMaterial' --output text --region <aws-region> > ./kubeaid-demo.pem
		```

- `ami_regions` - Comma separated AWS regions, where the AMI needs to be available.

- `ami_groups`

		By default it's `none`. You can set it to `all`, if you want to the AMI to be public.

    > To publicly share the AMI, you must call the DisableImageBlockPublicAccess API.

Then cd into [image-builder/images/capi](https://github.com/Obmondo/image-builder/tree/main/images/capi) and run :

```sh
make build-ami-ubuntu-2404-arm64
```

You can view the AMI ID somewhere in the output.

Now, that the custom AMI is ready, we'll head on to [Bootstrapping and upgrading a self-managed K8s cluster in AWS, effortlessly, using ClusterAPI and KubeAid](https://github.com/Obmondo/kubeaid/blob/master/docs/aws/capi/cluster.md).
