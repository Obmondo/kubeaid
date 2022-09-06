# Open Policy Agent - Gatekeeper

This custom chart depends upon the OPA Gatekeeper upstream Helm chart from
[here](https://github.com/open-policy-agent/gatekeeper/tree/master/charts/gatekeeper).

## How Gatekeeper works

Gatekeeper is project under Open Policy Agent which targets running OPA policies inside Kubernetes clusters.

Gatekeeper requires Constraint Templates and Constraints to impose policies on k8s objects.
A constraint template is a custom CRD which defines the logic and input/output of the policy.
The template uses Open API Schema to register the input structures with Gatekeeper.
It defines the policy logic using a declarative language known as Rego.

Once the constraint template is created, we need to create a constraint to analyse k8s requests.
The constraint defines the parameters for the policy, e.g. - the namespaces it needs to monitor,
the apiGroups it needs to match, etc.
It also provides the actual input to Gatekeeper whose structure is registered in the template.
For e.g - pod labels, container memory limits, etc.

Gatekeeper can be run in `Enforcement Mode` or `Dry run mode`. The latter is better suited
for testing and detecting policy violations. The `Enforcement Mode` is better for production
as it blocks any K8s objects which do not conform to the policy.

Note : The template needs to be created before the actual constraint.

## Constraint Template

The below example defines a sample constraint template that imposes labels on a resource.

```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8srequiredlabels
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredLabels
      validation:
        # Schema for the `parameters` field
        openAPIV3Schema:
          type: object
          properties:
            labels:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8srequiredlabels

        violation[{"msg": msg, "details": {"missing_labels": missing}}] {
          provided := {label | input.review.object.metadata.labels[label]}
          required := {label | label := input.parameters.labels[_]}
          missing := required - provided
          count(missing) > 0
          msg := sprintf("you must provide labels: %v", [missing])
        }
```

## Constraint

This constraint uses the above template to enforce `gatekeeper` label
on all namespaces.

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata:
  name: ns-must-have-gk
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Namespace"]
  parameters:
    labels: ["gatekeeper"]
```

Try creating a namespace without a label `gatekeeper` and k8s will throw an error with the message defined in the above template.

## Policy Examples

- https://github.com/open-policy-agent/gatekeeper-library
- https://github.com/open-policy-agent/gatekeeper/tree/master/demo

## Adding a new Policy

- Write a `.rego` file using the Constraint Framework describing the policy.
Keep the rego file under `argocd-helm-charts/gatekeeper/policies`.
- Add a constraint template which imports the policy.
- Add a constraint describing which Kubernetes objects should the policy be applied to.
- Combine both the yaml spec into a single file and keep it under
`argocd-helm-charts/gatekeeper/templates`.
- Install OPA binary and test the policy using :

```bash
# navigate to the root of gatekeeper chart
cd argocd-helm-charts/gatekeeper

# test using Makefile
make test
```

- Verify whether the template is correctly populated using the `helm template` command.

## References

- [OPA](https://www.openpolicyagent.org/docs/latest/)
- [Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/howto)
- [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/)
- [Constraint Framework](https://github.com/open-policy-agent/frameworks/tree/master/constraint)
- [Gatekeeper Tutorial](https://dustinspecker.com/posts/open-policy-agent-introduction-gatekeeper/)
