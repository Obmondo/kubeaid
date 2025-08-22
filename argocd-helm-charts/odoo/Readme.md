# Running Odoo Instances in Kubernetes

We manage configuration of Odoo instances via the `kubeaid-config` repository. For each instance, there is a template file and a values file.

Each Odoo instance has: -

Template file:
`kubeaid-config/k8s/<cluster-name>/argocd-apps/templates/<odoo-cms-name>.yaml`

Values file:
`kubeaid-config/k8s/<cluster-name>/argocd-apps/values-<odoo-cms-name>.yaml`

Example values file: [values.yaml](values.yaml)

## Create a new Odoo Instance

1.  Go to your kubeaid-config repository and copy an existing template and values file to new ones.

2.  Update the values file and template file with the desired configuration.

3.  Access ArgoCD:

    ``` bash
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```

    Get the admin password:

    ``` bash
    kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
    ```

    Open http://localhost:8080 and log in with:

    -   Username: `admin`
    -   Password: output from above command

4.  In ArgoCD UI: go to
    `root application -> sync list -> find the new Odoo instance -> sync`

The new Odoo CMS instance is now running.

## Adding a Hostname/Domain

1.  Open the values file of your instance.

2.  Find the `ingress` section.

3.  Add your domain under the `hostname` field:

    ``` yaml
    ingress:
      enabled: true
      hostname: your-domain.com
    ```

4.  Repeat the ArgoCD sync workflow.

Your domain is now active and pointing to the Odoo CMS.

The values file supports many customization options (e.g., scaling,
resources, storage, secrets).
Update them as needed, then re-sync in ArgoCD to apply changes.
