#
# Dockerfile for building DNCAPI-Server
#

# Build the DNCAPI-Server using phusion base image

FROM phusion/baseimage:bionic-1.0.0

# Installing nodejs 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install nodejs -y

# Copying public keys to get SSH access to this Container
COPY *.pub /tmp/
RUN cat /tmp/*.pub >> /root/.ssh/authorized_keys && rm -f /tmp/*.pub

# Enabling SSH service
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

#TO start DNC-APIs during system boot
COPY dncdemo_start /etc/service/dncdemo_start/run
RUN chmod +x /etc/service/dncdemo_start/run

COPY dncbe_start /etc/service/dncbe_start/run
RUN chmod +x /etc/service/dncbe_start/run

COPY dncapp_start /etc/service/dncapp_start/run
RUN chmod +x /etc/service/dncapp_start/run
