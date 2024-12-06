#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -c <cluster-name> -r <new-target-revision>"
    exit 1
}

# Function to add labels to high priority app
add_label_to_high_priority_app() {
    
  local search_app=$1
  local found=false

  # List of critical priority apps
  critical_priority_apps=("sealed-secrets" "argo-cd" "cert-manager" "cilium" "cluster-autoscaler" "haproxy" "keycloakx" "traefik" "teleport-cluster" "prometheus-adapter")

  # Loop through the list and check for the app
  for item in "${critical_priority_apps[@]}"; do
    if [[ "$item" == "$search_app" ]]; then
      found=true
      break
    fi
  done

  # Execute command if the app is found
  if $found; then
    echo "$search_app found in the list of priority apps."
    yq eval -i ".metadata.labels.\"kubeaid.io/priority\" = \"critical\"" "$2"
    else
    yq eval -i ".metadata.labels.\"kubeaid.io/priority\" = \"default\"" "$2"
  fi
}
# Parse command-line options
while getopts ":c:r:" opt; do
    case ${opt} in
        c )
            CLUSTER_NAME="$OPTARG"
            ;;
        r )
            NEW_TARGET_REVISION="$OPTARG"
            ;;
        \? )
            usage
            ;;
    esac
done

# Check if all required arguments are provided
if [ -z "$CLUSTER_NAME" ] || [ -z "$NEW_TARGET_REVISION" ]; then
    usage
fi

TEMPLATES_DIR="${CLUSTER_NAME}/argocd-apps/templates"

if [ ! -f "$CLUSTER_NAME/kube-prometheus/argocd-application-prometheus-rulesprometheusRuleExample.yaml" ]; then
  echo "File $CLUSTER_NAME/kube-prometheus/argocd-application-prometheus-rulesprometheusRuleExample.yaml does not exist. Exiting."
  echo "We need above file, to get the list of kubeaid managed apps"
  exit 1
fi

# Extract labels.name using yq
mapfile -t LABELS_NAMES < <(yq eval '.spec.groups[].rules[].labels.name' "$CLUSTER_NAME/kube-prometheus/argocd-application-prometheus-rulesprometheusRuleExample.yaml")

# Loop through each label name and update the corresponding YAML file
for label_name in "${LABELS_NAMES[@]}"; do
    yaml_file="${label_name}.yaml"  # Assuming the YAML files are named after the labels
    file_path="${TEMPLATES_DIR}/${yaml_file}"

    # Check if the file exists
    if [[ -f "$file_path" ]]; then
        echo "Updating targetRevision in $file_path"

        # Use yq to update the targetRevision only if the repoURL contains kubeaid.git or k8id.git
        yq eval -i "(.spec.sources[] | select(.repoURL | test(\"kubeaid\\.git|k8id\\.git|KubeAid\\.git\")) | .targetRevision) = \"$NEW_TARGET_REVISION\"" "$file_path"
        
        # Use yq to update project for kubeAid managed apps
       yq eval -i '( select(.kind | test("Application")) | .spec.project) = "kubeaid"' "$file_path"
        
        # Use yq to add custom labels
        yq eval -i ".metadata.labels.\"kubeaid.io/version\" = \"$NEW_TARGET_REVISION\" | .metadata.labels.\"kubeaid.io/managed-by\" = \"kubeaid\"" "$file_path"
        add_label_to_high_priority_app "$label_name" "$file_path"
        
        echo "Updated targetRevision in $file_path"
    else
        echo "File $file_path does not exist, skipping."
    fi
done

echo "All specified YAML files have been processed."
