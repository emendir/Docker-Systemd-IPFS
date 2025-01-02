#!/bin/bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

cd $script_dir
docker build -t emendir/systemd-ipfs .

## Run with:
# docker run --cap-add SYS_ADMIN --privileged emendir/systemd-ipfs

## If you want to access its shell, you can run with the -it flag
## and log in with the credentials set in the Dockerfile 
# docker run -it --privileged emendir/systemd-ipfs


## If you have no other docker containers running, you can access its shell with:
# docker exec -it $(docker ps -q) /bin/bash