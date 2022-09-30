# AWS EBS CSI

## Migration from in-tree [kops]

NOTE: Tested on k8s 1.21.14 and kops 1.23.2

* Add the below settings in the kops cluster

```yaml
# kops edit cluster --name k8s.enableittest.example.com

# https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/hack/kops-patch.yaml

kubeAPIServer:
  featureGates:
    CSIInlineVolume: "true"
    CSIMigration: "true"
    CSIMigrationAWS: "true"
    ExpandCSIVolumes: "true"
    VolumeSnapshotDataSource: "true"
kubeControllerManager:
  featureGates:
    CSIInlineVolume: "true"
    CSIMigration: "true"
    CSIMigrationAWS: "true"
    ExpandCSIVolumes: "true"
kubelet:
  anonymousAuth: false
  featureGates:
    CSIInlineVolume: "true"
    CSIMigration: "true"
    CSIMigrationAWS: "true"
    ExpandCSIVolumes: "true"
```

* Setup aws-ebs-csi

  NOTE: you can choose argocd and install it, for testing I'm using direct helm install

  * Create an `aws` NS

    ```raw
    $ cat <EOF | kubectl apply -f -
    apiVersion: v1
    kind: Namespace
    metadata:
      annotations:
        iam.amazonaws.com/allowed-roles: |
          [ "arn:aws:iam::<account-id-no>:role/enableittest-aws-ebs-csi"]
      name: aws
    spec:
      finalizers:
        - kubernetes
    EOF
    ```

  * Install kube2iam

    ```raw
    $ helm install kube2iam -n aws .
    NAME: kube2iam
    LAST DEPLOYED: Thu Sep 29 12:48:57 2022
    NAMESPACE: aws
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    ```

  * Install aws-ebs-csi-driver

    ```raw
    $ helm install aws-ebs-csi -n aws . --set aws-ebs-csi-driver.node.podAnnotations.'iam\.amazonaws\.com/role'=arn:aws:iam::<account-id-no>:role/enableittest-aws-ebs-csi --set aws-ebs-csi-driver.controller.podAnnotations.'iam\.amazonaws\.com/role'=arn:aws:iam::<account-id-no>:role/enableittest-aws-ebs-csi
    NAME: aws-ebs-csi
    LAST DEPLOYED: Thu Sep 29 11:46:41 2022
    NAMESPACE: mongodb
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    ```

NOTE: you can choose argocd and install it, for testing I'm using direct helm install

* Create an `aws` NS

```raw
$ cat <EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    iam.amazonaws.com/allowed-roles: |
      [ "arn:aws:iam::<account-id-no>:role/enableittest-aws-ebs-csi"]
  name: aws
spec:
  finalizers:
    - kubernetes
EOF
```

* Install kube2iam

```raw
$ helm install kube2iam -n aws .
NAME: kube2iam
LAST DEPLOYED: Thu Sep 29 12:48:57 2022
NAMESPACE: aws
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

* Install aws-ebs-csi-driver

```raw
$ helm install aws-ebs-csi -n aws . --set aws-ebs-csi-driver.node.podAnnotations.'iam\.amazonaws\.com/role'=arn:aws:iam::<account-id-no>:role/enableittest-aws-ebs-csi --set aws-ebs-csi-driver.controller.podAnnotations.'iam\.amazonaws\.com/role'=arn:aws:iam::<account-id-no>:role/enableittest-aws-ebs-csi
NAME: aws-ebs-csi
LAST DEPLOYED: Thu Sep 29 11:46:41 2022
NAMESPACE: mongodb
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

* Verify the installation

```raw
kubectl get csinodes -o yaml
```

* Testing the new provisioner [README](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/examples/kubernetes/dynamic-provisioning/README.md)

```raw
git clone git@github.com:kubernetes-sigs/aws-ebs-csi-driver.git

cd aws-ebs-csi-driver/examples/kubernetes/dynamic-provisioning/

kubectl apply -f manifests

kubectl get pvc ebs-claim

kubectl delete -f manifests
```

## Troubleshooting

Q1. could not create volume in EC2: UnauthorizedOperation: You are not authorized to perform this operation

* Verify if your role and policies are correct. You can see something like if you have used terraform to deploy the cluster

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::438423213058:role/nodes.k8s.staging.blackwoodseven.com",
                    "arn:aws:iam::438423213058:role/masters.k8s.staging.blackwoodseven.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

## Docs

[Migration doc](https://kubernetes.io/blog/2019/12/09/kubernetes-1-17-feature-csi-migration-beta/)
