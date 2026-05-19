#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up CinderOS Development Container (Distrobox) <=="
echo ""

if ! command -v distrobox &> /dev/null; then
    echo "Error: distrobox is not installed."
    echo "Please ensure the system is fully updated or contact support."
    sleep 3
    exit 1
fi

if ! command -v podman &> /dev/null; then
    echo "Error: podman is not installed."
    sleep 3
    exit 1
fi

CONTAINER_NAME="cinder-dev"
IMAGE="docker.io/library/archlinux:latest"

echo "Checking for existing container '$CONTAINER_NAME'..."
if distrobox list | grep -q "$CONTAINER_NAME"; then
    echo "Container '$CONTAINER_NAME' already exists."
    echo "Entering container..."
    distrobox enter "$CONTAINER_NAME"
    exit 0
fi

echo "Creating new container '$CONTAINER_NAME' using image '$IMAGE'..."
distrobox create -n "$CONTAINER_NAME" -i "$IMAGE" -Y

echo ""
echo "Container created successfully!"
echo "Entering container..."
distrobox enter "$CONTAINER_NAME"
