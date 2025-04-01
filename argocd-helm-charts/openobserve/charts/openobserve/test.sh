#!/bin/bash
export TERM=xterm-256color

# Configuration
NAMESPACE="${1:-openobserve}"    # Use first argument as namespace, default to 'openobserve' if not provided
RELEASE_NAME="${2:-o2}"          # Use second argument as release name, default to 'o2' if not provided
NAMESPACE="o2"
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

# Function to cleanup resources
cleanup() {
    local namespace=$1
    local release_name=$2
    local exit_code=$3
    
    echo -e "\nStarting cleanup..."
    
    # Uninstall helm release
    echo "Uninstalling OpenObserve helm release: ${release_name}..."
    helm --namespace "$namespace" uninstall "$release_name"
    
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

# Print configuration
echo "Using configuration:"
echo "  Namespace: ${NAMESPACE}"
echo "  Release Name: ${RELEASE_NAME}"
echo -e "-------------------\n"

# Start minikube
echo "Starting minikube cluster..."
# minikube start
# if [ $? -ne 0 ]; then
#     echo "Failed to start minikube cluster"
#     exit 1
# fi

# Install CloudNative PostgreSQL Operator (prerequisite)
echo "Installing CloudNative PostgreSQL Operator..."
kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.22/releases/cnpg-1.22.1.yaml

# wait for the operator to get ready by sleeping
sleep 60

# Add OpenObserve helm repository
# echo "Adding OpenObserve helm repository..."
# helm repo add openobserve https://charts.openobserve.ai
# helm repo update

# Create namespace
echo "Creating namespace: ${NAMESPACE}"
kubectl create namespace "$NAMESPACE"

# Install OpenObserve helm chart
echo "Installing OpenObserve helm chart (Release: ${RELEASE_NAME}) in namespace: ${NAMESPACE}"
helm --namespace "$NAMESPACE" upgrade --install "$RELEASE_NAME" . -f values.yaml

# Check pod status
check_pods "$NAMESPACE"
exit_status=$?

if [ $exit_status -eq 0 ]; then
    echo -e "\033[1;92m OpenObserve deployment completed successfully in namespace: ${NAMESPACE}  \033[0m"
else
    echo -e "\033[1;31m OpenObserve deployment encountered issues in namespace: ${NAMESPACE} . Please check the pod status above. \033[0m"
fi

# Setup trap for Ctrl+C
trap 'cleanup "$NAMESPACE" "$RELEASE_NAME" $exit_status' INT

# Pause to show results before cleanup
# echo -e "\nTest completed. Press Enter to cleanup or Ctrl+C to keep the deployment..."
# read -r

# Perform cleanup
cleanup "$NAMESPACE" "$RELEASE_NAME" $exit_status
