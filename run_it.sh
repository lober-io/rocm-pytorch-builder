#!/bin/bash
source env.txt
docker run -it --network=host --device=/dev/kfd --device=/dev/dri --ipc=host --shm-size 16G --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /opt/pytorch:/data:rw --name $CONTAINER_NAME $CONTAINER_TAG /bin/bash
