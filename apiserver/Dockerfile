#
# Dockerfile for building APISERVER
#

# Build the APISERVER using phusion base image

FROM phusion/baseimage

# Installing nodejs and configuring SSH access
RUN apt-get update 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install nodejs -y
COPY *.pub /tmp/
RUN cat /tmp/*.pub >> /root/.ssh/authorized_keys && rm -f /tmp/*.pub
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# # have to do that yourself. You may also comment out this instruction; the
# # init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

#To start APP-API during system boot
COPY nodejs_start /etc/service/nodejs_start/run
RUN chmod +x /etc/service/nodejs_start/run

#TO start DNC-API during system boot
COPY nodejs_start_db /etc/service/nodejs_start_db/run
RUN chmod +x /etc/service/nodejs_start_db/run
