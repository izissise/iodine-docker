#################################################
#
# Iodine Dockerfile v1.3
# http://code.kryo.se/iodine/
#
# Iodine version 0.7
#
# Based on https://github.com/FiloSottile/Dockerfiles/blob/master/iodine/Dockerfile
#
# Run with:
# docker run -d --privileged -p 53:53/udp -e IODINE_HOST=t.example.com -e IODINE_PASSWORD=1234abc izissise/iodine
#
#################################################

# Use phusion/baseimage as base image.
FROM phusion/baseimage:0.9.16

MAINTAINER Hugues Morisset <morisset.hugues@gmail.com>

# Set environment variables and regen SSH host keys
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update && apt-get install -y net-tools
RUN apt-get install -y git make gcc
RUN apt-get install -y zlib1g-dev

# Retrieve and compile iodine

RUN git clone --branch iodine-0.7 https://github.com/yarrick/iodine.git
RUN cd iodine && make && make install

# Add the runit iodine service
RUN mkdir /etc/service/iodined
ADD iodined.sh /etc/service/iodined/run

# Expose the DNS port, remember to run -p 53:53/udp
EXPOSE 53/udp

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Clean up APT when done.
RUN apt-get remove --purge -y git make gcc zlib1g-dev
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
