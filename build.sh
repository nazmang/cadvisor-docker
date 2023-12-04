#/bin/bash

TAG="$1"

prepare_repo() {
    # Clone from Cadvisor repository and prepare for build
    git clone https://github.com/google/cadvisor.git && cd cadvisor
    cp deploy/Dockerfile .   
    TAG="$(git describe --tags $(git rev-list --tags --max-count=1))" 
}

prepare_buildx() {
    # Prepare Buildx
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    docker buildx rm mybuilder
    docker buildx create --use --name mybuilder --driver docker-container
    docker buildx inspect --bootstrap
}

build_images() {
    # Build multi-platform images
    echo "Build using tag: $TAG"
    docker buildx build --build-arg CADVISOR_VERSION="$TAG" --pull . -t nazman/cadvisor:"$TAG" -t nazman/cadvisor:latest \
    --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 --push
}

prepare_repo
prepare_buildx
build_images
