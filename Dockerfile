FROM ubuntu:24.04
WORKDIR /opt/
COPY . /opt/

# install prerequisite and useful system packages
RUN apt update
RUN apt install -y wget systemctl python3 python3-dev python3-venv python3-pip python-is-python3

# install IPFS and configure it to be initialised on container instantiation
RUN /opt/install_ipfs_linux_docker.sh

# install systemd
RUN echo 'root:password' | chpasswd
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d
RUN apt -y install systemd systemd-sysv dbus dbus-user-session 
RUN printf "systemctl start systemd-logind" >> /etc/profile
ENTRYPOINT ["/sbin/init"]

## Run with:
# docker run -it --privileged emendir/systemd-ipfs