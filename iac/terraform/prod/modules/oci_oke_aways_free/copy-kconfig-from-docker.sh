#!/bin/bash

## Script to copy kubeconfig from docker container to host machine
## Run this on the HOST machine after executing get-kconfig.sh in the docker container

CONTAINER_NAME="${1:-cloud-cli}"  # Default container name, pass as argument if different
HOST_KUBE_DIR="${HOME}/.kube"

# Create .kube directory if it doesn't exist
mkdir -p "$HOST_KUBE_DIR"

echo "=== Copying kubeconfig from docker container to host ==="
echo "Container: $CONTAINER_NAME"
echo "Destination: $HOST_KUBE_DIR/config"
echo ""

# Copy kubeconfig from container to host
docker cp "$CONTAINER_NAME":/root/.kube/config "$HOST_KUBE_DIR/config"

if [ $? -eq 0 ]; then
    echo "✓ kubeconfig copied successfully!"
    echo "Location: $HOST_KUBE_DIR/config"
    echo ""
    echo "You can now use kubectl:"
    kubectl cluster-info
else
    echo "✗ Failed to copy kubeconfig"
    echo "Make sure the container is running: docker ps"
    exit 1
fi
