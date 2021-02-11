#
# Dockerfile for building DNC-UI
#

# Build the DNC-UI using phusion base image
FROM phusion/baseimage:bionic-1.0.0

# Installing nodejs
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get update && apt-get install nodejs -y

# Installing Expo 
RUN npm install expo-cli --global
RUN npm install yarn -g

# Copying public keys to get SSH access to this Container
COPY *.pub /tmp/
RUN cat /tmp/*.pub >> /root/.ssh/authorized_keys && rm -f /tmp/*.pub

# Enabling SSH service
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# TO start DNC-UI during system boot 
COPY expo_start.sh /etc/service/expo_start/run
RUN chmod +x /etc/service/expo_start/run

# End of the file
