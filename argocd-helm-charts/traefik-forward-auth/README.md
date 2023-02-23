# Traefik Forward Auth

## RBAC Support

* enableRBAC: true needs to be set in values file.
* rbacPassThroughPaths can accept list of url which is open to all the authenticated users.
* Configure the traefik-forward-auth client on keycloak
* Make sure middleware.enabled is set to true (default is true)
* For groups, you will have to prefix group name with `oidc:` in the clusterrolebinding
  so members of the respective group can access the said urls.
* Add required annotation to your ingress object

  ```yaml
  ---
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    traefik.ingress.kubernetes.io/router.middlewares: traefik-traefik-forward-auth@kubernetescrd
  ```

* Create a clusterrole and clusterrolebinding

  ```yaml
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRole
  metadata:
    name: foo-whoami
  rules:
  - nonResourceURLs:
    - /dashboard
    - /admin
    verbs:
    - get

  ---
  # Group
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: sre-whoami-binding
  subjects:
  - kind: Group
    name: oidc:sre
    apiGroup: rbac.authorization.k8s.io
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: foo-whoami

  ---
  # User
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: foo-whoami-binding
  subjects:
  - kind: User
    name: foo@k8id.io
    apiGroup: rbac.authorization.k8s.io
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: foo-whoami
  ```

* Open the link on your browser (whatever domain you have given in your ingress object).
  It should first authenticated you and if the requested endpoint is allowed for that user
  it will give 200 otherwise 404 (Not Authorized)
