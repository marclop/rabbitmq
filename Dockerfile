# USE UBUNTU from Phusion guys which is a well made ubuntu image for docker running runit as the init main process
FROM phusion/baseimage

MAINTAINER Marc Lopez Rubio <marc5.12@outlook.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# INSTALL RABBITMQ
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get install -qq -y rabbitmq-server

# ENABLE MANAGEMENT INTERFACE
RUN rabbitmq-plugins enable rabbitmq_management

#COPY CONFIG FILE
RUN mkdir -p /etc/rabbitmq
ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config

# Create service for runit
RUN mkdir /etc/service/rabbitmq
ADD rabbitmq.sh /etc/service/rabbitmq/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install SSH key
ADD key.pub /tmp/key.pub
RUN cat /tmp/key.pub >> /root/.ssh/authorized_keys && rm -f /tmp/key.pub && chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

# EXPOSE RABBITMQ PORT
EXPOSE 5672 15672
