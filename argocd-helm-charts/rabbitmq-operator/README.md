# RabbitMQ operator

This chart is based on the Bitnami [RabbitMQ cluster operator helm chart](https://github.com/bitnami/bitnami-docker-rabbitmq-cluster-operator).
It includes both of the [RabbitMQ maintained Kubernetes operators](https://www.rabbitmq.com/kubernetes/operator/operator-overview.html).

## Configuration hints

### Replicated setup

To run a proper RabbitMQ cluster, we need more then one instance of RabbitMQ.
And the cluster operator makes this quite easy.
Just specify 3 replicas, and the operator will setup the replication.
One peculiarity is that we also need to specify the antiAffinity rules.
This results in the following RabbitmqCluster object:

```yaml
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: <Cluster name>
  namespace: <Cluster namespace>
spec:
  replicas: 3
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app.kubernetes.io/name
              operator: In
              values:
              - <Cluster name>
        topologyKey: kubernetes.io/hostname
```

In addition to this, it also makes sense to include a pod disruption budget. Like this one:

```yaml
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: <Cluster name>-rabbitmq
spec:
  maxUnavailable: 1
  selector:
    matchLabels:
      app.kubernetes.io/component: rabbitmq
      app.kubernetes.io/name: <Cluster name>
```

## Adding resource limits

To make the RabbitMQ cluster a proper Kubernetes citizen, we also need to add resource limits.
The following example includes resource limits, resonable for a low traffic cluster, for a high traffic
cluster look [here](https://github.com/rabbitmq/cluster-operator/tree/main/docs/examples/production-ready).

```yaml
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: <Cluster name>
  namespace: <Cluster namespace>
spec:
  resources:
    requests:
      cpu: 500m
      memory: 1Gi
    limits:
      cpu: 800m
      memory: 1Gi
```

## Accessing the RabbitMQ management web UI

While the web interface is enabled by default, we need to add an ingress, to make it available outside the cluster.
The username and password is available in a Kubernetes secret.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    traefik.ingress.kubernetes.io/router.middlewares: traefik-traefik-forward-auth@kubernetescrd
  name: <Cluster name>
  namespace: <Cluster namespace>
spec:
  rules:
  - host: <management interface FQDN>
    http:
      paths:
      - backend:
          service:
            name: <Cluster name>
            port:
              number: 15672
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - <management interface FQDN>
    secretName: <Cluster name>-management-tls
```

## Writing a network policy for a RabbitMQ cluster

You can find some examples [here](https://github.com/rabbitmq/cluster-operator/tree/main/docs/examples/network-policies).

## Create a RabbitMQ user

In this example, we create an administrator user:

```yaml
apiVersion: rabbitmq.com/v1beta1
kind: User
metadata:
  name: <Name of user object>
  namespace: <Cluster namespace>
spec:
  tags:
  - administrator
  rabbitmqClusterReference:
    name: <Cluster name>
```

The different tags are used by the management interface, and are documented [here](https://www.rabbitmq.com/management.html#permissions).
The user credentials will be stored in a secret called ```<Name of user object>-user-credentials```.

## Logging as JSON

When using RabbitMQ >= 3.9, it is possible to log everything as JSON objects, as documented [here](https://github.com/rabbitmq/cluster-operator/tree/main/docs/examples/json-log).

## Disable Velero backup of most of a RabbitMQ cluster

It does not make sense to take backup of most of the RabbitMQ cluster objects.
To disable this, it is possible to add the needed label to the RabbitmqCluster object, like this:

```yaml
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: <Cluster name>
  namespace: <Cluster namespace>
  labels:
    velero.io/exclude-from-backup: "true"
spec:
......
```

This will result in all objects created by the cluster operator, getting this label,
which will make Velero not back them up.
This is not a problem, since it can easily be re-created by adding the RabbitmqCluster object,
from the application helm chart.
This label will not propergate to the PVC, since they are created by the stateful set, which is actually what we want.

This will not affect objects created by the messaging topology operator.
