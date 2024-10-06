#!/bin/bash

docker build -t emendir/systemd-ipfs .

## Run with:
# docker run --cap-add SYS_ADMIN --privileged emendir/systemd-ipfs

## If you want to access its shell, you can run with the -it flag
## and log in with the credentials set in the Dockerfile 
# docker run -it --privileged emendir/systemd-ipfs


## If you have no other docker containers running, you can access its shell with:
# docker exec -it $(docker ps -q) /bin/bash