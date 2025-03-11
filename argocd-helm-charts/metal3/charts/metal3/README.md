# Prerequisites
There are two dependencies that are not managed through the metal3 chart because are related to applications that have a cluster-wide scope: `cert-manager` and a LoadBalancer Service provider such as `metallb` or `kube-vip`.

## Cert Manager
In order to successfully deploy metal3 the cluster must have already installed the `cert-manager`.

You can install it through `helm` with:
```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
```
, or via `kubectl` with:
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.1/cert-manager.yaml
```

## MetalLB (Optional)
Ironic currently requires a staticIP address and MetalLB is one option to achieve that.

1. If K3s is used as Kubernetes distribution, then it should be started with `--disable=servicelb` flag. Ref https://metallb.universe.tf/configuration/k3s/
2. Find 1 free IP address in the network.
3. Install `MetalLB` through `helm` with:

```bash
helm repo add suse-edge https://suse-edge.github.io/charts
helm install \
  metallb suse-edge/metallb \
  --namespace metallb-system \
  --create-namespace
```

4. Provide the IP pool configuration with:

```bash
export STATIC_IRONIC_IP=<STATIC_IRONIC_IP>

cat <<-EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: ironic-ip-pool
  namespace: metallb-system
spec:
  addresses:
  - ${STATIC_IRONIC_IP}/32
  serviceAllocation:
    priority: 100
    serviceSelectors:
    - matchExpressions:
      - {key: app.kubernetes.io/name, operator: In, values: [metal3-ironic]}
EOF

cat <<-EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: ironic-ip-pool-l2-adv
  namespace: metallb-system
spec:
  ipAddressPools:
  - ironic-ip-pool
EOF
```

5. Create new values.yaml file that will override some of the default properties:

```bash
TMP_DIR=$(mktemp -d)
cat > ${TMP_DIR}/values.yaml << EOF
global:
  ironicIP: "<STATIC_IRONIC_IP>"
EOF
```

# Install

```bash
helm install \
  metal3 suse-edge/metal3 \
  --namespace metal3-system \
  --create-namespace
  -f ${TMP_DIR}/values.yaml
```

# How to upgrade the chart
1. Run `helm dependency update .` in this chart to download/update the dependent charts.

2. Identify the appropriate subchart values settings and create an appropriate override values YAML file.
   * Ensure that the relevant ironic and baremetal-operator settings match.

3. Install the chart using a command like the following:

```console
$ helm upgrade heavy-metal . --namespace metal-cubed --create-namespace --install --values ~/overrides.yaml
```
