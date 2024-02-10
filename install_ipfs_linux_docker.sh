#!/bin/bash

IPFS_VERSION="0.26.0"
# the threshold of RAM in gigabytes under which the lowpower profile is applied
LOW_POWER_RAM_GB=6
# Get the CPU architecture using uname
ARCH=$(uname -m)

# Initialize the variable to store the architecture string
ARCH_STRING=""

# get prerequisites and make directories for IPFS content mounting
apt install -y fuse
mkdir /ipfs
mkdir /ipns

# Check the architecture and set the variable accordingly
if [ "$ARCH" == "i386" ] || [ "$ARCH" == "i686" ]; then
    ARCH_STRING="386"
elif [ "$ARCH" == "x86_64" ]; then
    ARCH_STRING="amd64"
elif [ "$ARCH" == "armv7l" ]; then
    ARCH_STRING="arm"
elif [ "$ARCH" == "aarch64" ]; then
    ARCH_STRING="arm64"
else
    echo "Unknown architecture: $ARCH"
    exit 1
fi



ZIP_NAME="kubo_v${IPFS_VERSION}_linux-${ARCH_STRING}.tar.gz"
wget "https://dist.ipfs.tech/kubo/v${IPFS_VERSION}/${ZIP_NAME}"
tar -xvzf $ZIP_NAME
cd kubo
bash install.sh

# clean up
cd ..
rm -r kubo
rm $ZIP_NAME

# create script to initialise an IPFS repository and make inital configurations
echo "ipfs init
ipfs config --json Experimental.Libp2pStreamMounting true
ipfs config --json Mounts.FuseAllowOther true

# TESTING ROUTER MERCY
ipfs config --json Swarm.Transports.Network.TCP false
ipfs config --json Swarm.Transports.Network.Websocket false
" | tee /opt/init_ipfs.sh
chmod +x /opt/init_ipfs.sh

# create one-shot systemd service to run the IPFS initialisation script
echo "[Unit]
Description=Initialisation and configuration of IPFS repository
Before=ipfs.service

[Service]
Type=oneshot
ExecStart=/bin/bash /opt/init_ipfs.sh

[Install]
WantedBy=multi-user.target
" | tee /etc/systemd/system/ipfs-init.service

# create systemd service to run IPFS on startup
echo '[Unit]
Description=InterPlanetary FileSystem - the infrastructure of a P2P internet
Wants=ipfs-init.service

[Service]
Environment="LIBP2P_TCP_REUSEPORT=false"
ExecStart=/usr/local/bin/ipfs daemon --enable-pubsub-experiment --mount

[Install]
WantedBy=multi-user.target
' | tee /etc/systemd/system/ipfs.service
systemctl enable ipfs


echo "Installation of IPFS finished!"


