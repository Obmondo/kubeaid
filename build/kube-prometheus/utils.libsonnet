

{
	
ingress(name, namespace, rules, tls)::{
  apiVersion: 'networking.k8s.io/v1',
  kind: 'Ingress',
  metadata: {
    name: name,
    namespace: namespace,
    annotations: {
      'cert-manager.io/cluster-issuer': 'letsencrypt',
      'kubernetes.io/ingress.class': 'traefik-cert-manager',
    },
  },
  spec: { 
    rules: rules,
    [if tls!=null then 'tls']: tls,
  },
}

}