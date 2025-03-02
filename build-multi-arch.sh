#!/bin/bash
set -e

# Set image name
IMAGE_NAME="calvinberndt/my-calculator-flex"
IMAGE_TAG="latest"

echo "Setting up Docker buildx for multi-architecture builds..."
# Create a new builder instance if it doesn't exist
if ! docker buildx inspect multi-arch-builder &>/dev/null; then
docker buildx create --name multi-arch-builder --driver docker-container --use
else
docker buildx use multi-arch-builder
fi

# Bootstrap the builder
docker buildx inspect --bootstrap

echo "Building and pushing multi-architecture image: ${IMAGE_NAME}:${IMAGE_TAG}"
# Build and push the image for both amd64 and arm64
docker buildx build \
--platform linux/amd64,linux/arm64 \
--file Dockerfile.multi \
--tag ${IMAGE_NAME}:${IMAGE_TAG} \
--push \
.

echo "Multi-architecture image build complete!"
echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Supported architectures: AMD64, ARM64"

# Make the builder default again
docker buildx use default

