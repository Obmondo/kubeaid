# What is kube2iam ?

Kube2iam here act as an bridge or an interface between AWS services and pod. It watches
which pods has role defined in annotation for AWS services. If so, then kube2iam
generate an temporary credential and assign to the pod. Therefore, pod able to access S3
bucket.

## How kube2iam is used in kubeaid?

Basically we use PostgreSQL to create logical backups for an application. And Cronjobs
are scheduled to run everyday at particular time to upload those backups in S3 bucket
(which is one of the AWS services). Those cronjob create a job and jobs creates a pod,
and finally pods upload those backups on S3 bucket.

To do so, pods requires access to S3 bucket and technically it is known as IAM roles.
And that IAM roles need to be attached with the pod directly. But from security point of
view, it is avoided or not recommended to directly attached those credentials with the
pod. Hence kube2iam is used to act as an bridge b/w pod and AWS services and to provide
temporary credentials to the pod, whenever pod looks for the access of S3 bucket
service. Before providing credentials it looks for an annotation such as:

```yaml
   annotations:
    iam.amazonaws.com/allowed-roles: ["arn:aws:iam::190493893020:role/k8s-zalando-operator-staging"]
```

In our case, namespace restrictions is there, for more refer[here](<https://github.com/>
jtblin/kube2iam#namespace-restrictions). It means kube2iam will only provide credentials
if the namespace in which pod exist also contains the annotation such as:

```yaml
annotations:
    iam.amazonaws.com/allowed-roles: |
      ["arn:aws:iam::190493893020:role/k8s-zalando-operator-staging"]
```

## Conclusion

kube2iam will provide the credentials if both namespace as well as pods contains the
annotation.
