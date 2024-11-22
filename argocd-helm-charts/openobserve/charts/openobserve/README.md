# OpenObserve helm chart

## Amazon EKS

openobserve uses [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) on Amazon EKS to securely access s3.

You must set a minimum of 2 values:

1. S3 bucket where data will be stored
   - config.ZO_S3_BUCKET_NAME
1. IAM role for the serviceAccount to gain AWS IAM credentials to access s3
   - serviceAccount.annotations."eks.amazonaws.com/role-arn"

## Install

Install the Cloud Native PostgreSQL Operator. This is a prerequisite for openobserve helm chart. This helm chart sets up a postgres database cluster (1 primary + 1 replica) and uses it as metadata store of OpenObserve.
```shell
kubectl apply -f \
  https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.22/releases/cnpg-1.22.1.yaml
```

Install the openobserve helm chart
```shell
helm repo add openobserve https://charts.openobserve.ai
helm repo update

kubectl create ns openobserve

helm --namespace openobserve -f values.yaml install o2 openobserve/openobserve
```

## Uninstall

```shell
helm --namespace openobserve delete o2
```

# Development

If you are developing this chart then you should clone the repo and make any modifications.

You can generate output of the chart using below command to verify:

```shell
helm -n openobserve template o2 . > o2.yaml
```

You can then install using:

```shell
helm -n openobserve install o2 .
```

To upgrade

```shell
helm -n openobserve upgrade o2 .
```

To uninstall

```shell
helm -n openobserve uninstall o2 
```
