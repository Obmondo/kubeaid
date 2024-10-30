#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -c <cluster-name> -s <source-yaml-file> -r <new-target-revision>"
    exit 1
}

# Parse command-line options
while getopts ":c:s:r:" opt; do
    case ${opt} in
        c )
            CLUSTER_NAME="$OPTARG"
            ;;
        s )
            SOURCE_YAML_FILE="$OPTARG"
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
if [ -z "$CLUSTER_NAME" ] || [ -z "$SOURCE_YAML_FILE" ] || [ -z "$NEW_TARGET_REVISION" ]; then
    usage
fi

TEMPLATES_DIR="${CLUSTER_NAME}/argocd-apps/templates"

# Extract labels.name using yq
LABELS_NAMES=($(yq eval '.spec.groups[].rules[].labels.name' "$SOURCE_YAML_FILE"))

# Loop through each label name and update the corresponding YAML file
for label_name in "${LABELS_NAMES[@]}"; do
    yaml_file="${label_name}.yaml"  # Assuming the YAML files are named after the labels
    file_path="${TEMPLATES_DIR}/${yaml_file}"

    # Check if the file exists
    if [[ -f "$file_path" ]]; then
        echo "Updating targetRevision in $file_path"

        # Use yq to update the targetRevision only if the repoURL contains kubeaid.git or k8id.git
        yq eval -i "(.spec.sources[] | select(.repoURL | test(\"kubeaid\\.git|k8id\\.git\")) | .targetRevision) = \"$NEW_TARGET_REVISION\"" "$file_path"

        echo "Updated targetRevision in $file_path"
    else
        echo "File $file_path does not exist, skipping."
    fi
done

echo "All specified YAML files have been processed."

