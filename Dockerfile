#################################################
#
# Iodine Dockerfile v1.4
# http://code.kryo.se/iodine/
#
# Iodine version 0.7
#
# Based on https://github.com/FiloSottile/Dockerfiles/blob/master/iodine/Dockerfile
#
# Run with:
# docker run -d --cap-add=NET_ADMIN -p 53:53/udp -e IODINE_HOST=t.example.com -e IODINE_PASSWORD=1234abc izissise/iodine
#
#################################################

FROM debian

MAINTAINER Hugues Morisset <morisset.hugues@gmail.com>

# Set environment variables and regen SSH host keys
ENV HOME /root

RUN apt-get update && apt-get install -y \
        iptables net-tools \
        git make gcc \
        zlib1g-dev \
    && echo 'Retrieve and compile iodine' \
    && git clone --branch iodine-0.7 https://github.com/yarrick/iodine.git \
    && cd iodine && make && make install \
    && echo 'Cleanup' \
    && apt-get remove --purge -y git make gcc zlib1g-dev \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add the runit iodine service
ADD iodined.sh /
RUN chmod +x iodined.sh

# Expose the DNS port, remember to run -p 53:53/udp
EXPOSE 53/udp

# Use baseimage-docker's init system.
CMD ["/iodined.sh"]
