#!/bin/bash
echo "load env.txt"
source env.txt

echo "download anaconda"
curl https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh -o util/Anaconda3-2020.02-Linux-x86_64.sh

echo "building container image"
docker build -t $CONTAINER_NAME -t $CONTAINER_NAME:latest  .

echo "run build container"
docker run -d --rm --network=host --device=/dev/kfd --device=/dev/dri --ipc=host --shm-size 16G --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $MOUNT_PATH:/data:rw --name $CONTAINER_NAME $CONTAINER_TAG
