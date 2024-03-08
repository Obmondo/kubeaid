# Redisfailover

## Control of Label propogation

upstream doc - https://github.com/spotahome/redis-operator?tab=readme-ov-file#control-of-label-propagation

example file - we have a RedisFailover in KubeAid/argocd-helm-charts/redis-operator/examples to add the label to exclude velero backup

To control what labels the operator propagates to resource is creates you can modify the labelWhitelist option in the spec. If nothing is added, it adds all the labels to the resources it creates.
