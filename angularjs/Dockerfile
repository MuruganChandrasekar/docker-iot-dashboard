#
# Dockerfile for building MQTTS
#

# Build the MQTTS using phusion base image

# passing arguments to map letsencrypt certs

FROM phusion/baseimage

RUN apt-get update 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install nodejs -y
#RUN npm install -g @angular/cli
#RUN apt-get install npm -y
RUN npm install expo-cli --global
RUN npm install yarn babel-core babel-loader babel-preset-es2015 babel-preset-react

#RUN npm audit fix
#RUN apt-get install npm -y
#npm install expo-cli --global
#RUN apt-get install npm -y
COPY id_rsa.pub /tmp/id_rsa.pub
RUN cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_rsa.pub
COPY seenivasan_bitvise_pub_key.pub /tmp/id_rsa.pub
RUN cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_rsa.pub
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# # have to do that yourself. You may also comment out this instruction; the
# # init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh



#COPY angular_start /etc/my_init.d/angular_start
#RUN chmod +x /etc/my_init.d/angular_start

COPY angular_start /etc/service/angular_start/run
RUN chmod +x /etc/service/angular_start/run


#COPY nodejs_start_db /etc/service/nodejs_start_db/run
#RUN chmod +x /etc/service/nodejs_start_db/run
