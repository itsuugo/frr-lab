FROM ubuntu:16.04
MAINTAINER A.Ojea

RUN apt-get update && \
    apt-get -y install systemd \
    wget \
    tcpdump \
    inetutils-ping \
    inetutils-traceroute \
    netcat

# In order to gracefully stop systemd we need to set the stop signal to
# SIGRTMIN+3 and set the container environment variable
STOPSIGNAL SIGRTMIN+3
ENV container docker

# No need for graphical.target here
RUN systemctl set-default multi-user.target

COPY frr.deb /tmp/frr.deb 
RUN apt install -y /tmp/frr.deb

COPY frr/daemons /etc/frr/daemons
RUN systemctl enable frr
RUN systemctl mask system-getty.slice docker

RUN echo "export VTYSH_PAGER=more" >>  /etc/bash.bashrc
RUN echo "VTYSH_PAGER=more" >> /etc/environment

ENTRYPOINT ["/sbin/init"]
