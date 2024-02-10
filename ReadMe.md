# Systemd-IPFS Docker Image

This is a Ubuntu docker image with [systemd](https://systemd.io/) and [IPFS](https://ipfs.tech/), built for testing IPFS-based applications that use systemd for installation.

**See [Security Considerations](./ReadMe.md#security-considerations) below.**

## Running:
The simplest way to create and run a docker container of this image is:
```sh
docker run -d --name MY_IPFS_CONTAINER --privileged emendir/systemd-ipfs
```
Log into your container's shell with:
```sh
docker exec -it MY_IPFS_CONTAINER /bin/bash
```

If you want you can run the container using the following command to watch the system boot up and log into its shell immediately, but it requires authenticating using the user `root` and password `password`:
```sh
docker run -it --privileged emendir/systemd-ipfs
```

## Other Useful Commands

Get your docker container's IPFS peer ID:
```sh
docker exec MY_IPFS_CONTAINER echo $(ipfs id -f="<id>")
```

Check IPFS systemd service status:
```sh
docker exec -it MY_IPFS_CONTAINER systemctl status ipfs
```

## IPFS
In this docker image, IPFS is configured in such a way that each new container generates its own IPFS peer ID.

IPFS runs as a systemd service called `ipfs`, defined in `/etc/systemd/system/ipfs.service`, configured to run at system startup.

### IPFS Options & Config
In this docker image, IPFS is run with [PubSub](https://blog.ipfs.tech/25-pubsub/) and content-to-filesystem-mounting enabled, by running ipfs as follows:
```sh
ipfs daemon --enable-pubsub-experiment --mount
```
Also, the following configurations are applied:
```
Experimental.Libp2pStreamMounting true
Mounts.FuseAllowOther true
Swarm.Transports.Network.TCP false
Swarm.Transports.Network.Websocket false
```

These options and configurations are defined in the [install_ipfs_linux_docker.sh](install_ipfs_linux_docker.sh) file.

To customise these options and configurations, download this repository, search for the above configurations you want to change in that file, make your changes, and then rebuild the docker container by running:
```sh
docker build -t my_images/systemd-ipfs .
```
Then run your customised docker container with:
```sh
docker run -d --name MY_CUSTOMISED_CONTAINER --privileged my_images/systemd-ipfs
```
Check that your configurations have been applied correctly by reading:
```sh
docker exec MY_CUSTOMISED_CONTAINER ipfs config show
```


## Systemd
Docker containers don't usually use systemd, because they're intended to run a single process.
Running systemd inside a docker container allows the management of multilple processes as services, just like on most traditional Linux systems.

### Security Considerations
However, it's important to note that running systemd in a container introduces additional complexity and potential security risks.
The latter is due to the usage of the `--privileged` argument when running the container, which allows the container to have access to all the devices on the host as well as access to certain kernel capabilities that are typically restricted within containers.
Therefore, use this docker image judiciously and with a clear understanding of the implications for your specific use case.

As noted in the description, this docker image was designed for testing systemd-reliant applications, not productively running them.
