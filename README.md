[![Docker Image CI](https://github.com/nazmang/cadvisor-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/nazmang/cadvisor-docker/actions/workflows/docker-image.yml)
# cAdvisor for ARM (https://github.com/google/cadvisor) 
Forked from https://github.com/ZCube/cadvisor-docker

* arm64, amd64 supported
* Raspberry Pi tested
* latest (v0.47.2) release 

# Usage

* From official readme (https://github.com/google/cadvisor)
```
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  nazman/cadvisor:latest
```

# Build

Build using **docker buildx**
```
TAG=v0.47.2
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx rm mybuilder
docker buildx create --use --name mybuilder --driver docker-container
docker buildx inspect --bootstrap
docker buildx build --build-arg CADVISOR_VERSION="TAG" --pull . \
                    -t nazman/cadvisor:"$TAG" \ 
                    -t nazman/cadvisor:latest 
                    --platform linux/amd64,linux/arm64 \ 
                    --push
```
Build using **build.sh** script
````
TAG=v0.47.2
sh ./build.sh $TAG
````
# Links
* https://hub.docker.com/r/nazman/cadvisor

