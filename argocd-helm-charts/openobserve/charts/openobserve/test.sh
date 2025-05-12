#!/bin/bash
export TERM=xterm-256color

# Configuration
NAMESPACE="${1:-openobserve}"    # Use first argument as namespace, default to 'openobserve' if not provided
RELEASE_NAME="${2:-o2}"          # Use second argument as release name, default to 'o2' if not provided
NAMESPACE="o3"
RELEASE_NAME="o2"
# Function to check pod status
check_pods() {
    local namespace=$1
    local timeout=180  # 3 minutes timeout
    local start_time=$(date +%s)
    
    echo "Waiting for pods to be ready in namespace '${namespace}' (timeout: ${timeout}s)..."
    
    while true; do
        current_time=$(date +%s)
        elapsed=$((current_time - start_time))
        
        if [ $elapsed -gt $timeout ]; then
            echo "Timeout reached. Checking final pod status..."
            break
        fi
        
        if kubectl get pods -n "$namespace" | grep -q "Running"; then
            all_running=true
            while read -r pod status restarts age; do
                if [[ "$status" != "Running" && "$pod" != "NAME" ]]; then
                    all_running=false
                    break
                fi
            done < <(kubectl get pods -n "$namespace" | awk '{print $1, $3}')
            
            if $all_running; then
                echo "All pods are running successfully!"
                return 0
            fi
        fi
        
        sleep 5
    done
    
    # Print status of all pods if there are issues
    echo "Pod status after ${timeout} seconds:"
    kubectl get pods -n "$namespace"
    
    # Check for any non-running pods
    kubectl get pods -n "$namespace" | grep -v "Running" | grep -v "NAME" > /dev/null
    if [ $? -eq 0 ]; then
        echo "ERROR: Some pods failed to reach Running state"
        return 1
    fi
}

uninstall() {
    local namespace=$1
    local release_name=$2
    
    echo "Uninstalling OpenObserve..."
    helm --namespace "$namespace" uninstall "$release_name"
    if [ $? -ne 0 ]; then
        echo "Failed to uninstall OpenObserve"
        return 1
    fi
    echo "OpenObserve uninstalled successfully"
}

# Function to cleanup resources
cleanup() {
    local namespace=$1
    local release_name=$2
    local exit_code=$3
    
    echo -e "\nStarting cleanup..."
    
    # Delete namespace
    echo "Deleting namespace: ${namespace}"
    kubectl delete namespace "$namespace"
    
    # Delete CloudNative PostgreSQL Operator
    echo "Removing CloudNative PostgreSQL Operator..."
    kubectl delete -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.22/releases/cnpg-1.22.1.yaml
    
    echo "Cleanup completed."
    
    # Exit with the original exit code
    exit $exit_code
}

setup() {

    # Check if CloudNative PostgreSQL Operator is already installed
    if kubectl get deployment -n cnpg-system cloudnative-pg-controller-manager &> /dev/null; then
        echo "CloudNative PostgreSQL Operator is already installed."
    else
        # Install CloudNative PostgreSQL Operator (prerequisite)
        echo "Installing CloudNative PostgreSQL Operator..."
        kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.22/releases/cnpg-1.22.1.yaml
    fi

    # wait for the operator to get ready
    echo "Waiting for PostgreSQL Operator to be ready..."
    while true; do
        if kubectl get pods -n cnpg-system | grep -q "Running"; then
            echo "PostgreSQL Operator is ready!"
            break
        else
            echo "Waiting for PostgreSQL Operator to be ready..."
            sleep 5
        fi
    done

    local namespace=$1
    local release_name=$2

    # Check if the namespace already exists
    if kubectl get namespace "$namespace" > /dev/null 2>&1; then
        echo "Namespace '${namespace}' already exists. Skipping creation."
    else
        echo "Creating namespace '${namespace}'..."
        kubectl create namespace "$namespace"
    fi

    # Check if OpenObserve is already installed
    if helm --namespace "$namespace" list | grep -q "$release_name"; then
        echo "OpenObserve is already installed. Skipping installation."
        return 0
    fi
}

# Function to install OpenObserve and its dependencies
test_basic() {
    local namespace=$1
    local release_name=$2

    # Create namespace
    echo "Creating namespace: ${namespace}"
    kubectl create namespace "$namespace"

    # Install OpenObserve helm chart
    echo "Installing OpenObserve helm chart (Release: ${release_name}) in namespace: ${namespace}"
    helm --namespace "$namespace" upgrade --install "$release_name" . -f values.yaml

    return $?
}

# Function to install OpenObserve external_secret
test_with_external_secret() {
    local namespace=$1
    local release_name=$2

    # Create namespace
    echo "Creating namespace: ${namespace}"
    kubectl create namespace "$namespace"
    
    kubectl -n "$namespace" apply -f test_secret.yaml

    # Install OpenObserve helm chart
    echo "Installing OpenObserve helm chart (Release: ${release_name}) in namespace: ${namespace}"
    helm --namespace "$namespace" upgrade --install "$release_name" . -f test_values_external_secret.yaml

    return $?
}

# Print configuration
echo "Using configuration:"
echo "  Namespace: ${NAMESPACE}"
echo "  Release Name: ${RELEASE_NAME}"
echo -e "-------------------\n"

# Setup basic prerequisites
setup "$namespace" "$release_name"
if [ $? -ne 0 ]; then
    echo "Failed to setup prerequisites. Exiting."
    return 1
fi

# Test 1 - Install basic installation of OpenObserve and dependencies
# test_basic "$NAMESPACE" "$RELEASE_NAME"
# # Check pod status
# check_pods "$NAMESPACE"
# exit_status=$?

# if [ $exit_status -eq 0 ]; then
#     echo -e "\033[1;92m OpenObserve deployment completed successfully in namespace: ${NAMESPACE}  \033[0m"
# else
#     echo -e "\033[1;31m OpenObserve deployment encountered issues in namespace: ${NAMESPACE} . Please check the pod status above. \033[0m"
# fi

# uninstall "$namespace" "$release_name"


# Test #2 - Install OpenObserve with external secret
test_with_external_secret "$NAMESPACE" "$RELEASE_NAME"
# Check pod status
check_pods "$NAMESPACE"
exit_status=$?

if [ $exit_status -eq 0 ]; then
    echo -e "\033[1;92m OpenObserve deployment completed successfully in namespace: ${NAMESPACE}  \033[0m"
else
    echo -e "\033[1;31m OpenObserve deployment encountered issues in namespace: ${NAMESPACE} . Please check the pod status above. \033[0m"
fi

# uninstall "$namespace" "$release_name"

# Setup trap for Ctrl+C
# trap 'cleanup "$NAMESPACE" "$RELEASE_NAME" $exit_status' INT

# Pause to show results before cleanup
# echo -e "\nTest completed. Press Enter to cleanup or Ctrl+C to keep the deployment..."
# read -r

# Perform cleanup
# cleanup "$NAMESPACE" "$RELEASE_NAME" $exit_status
