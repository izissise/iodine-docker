#!/bin/sh

TUNNEL_IP=${IODINE_TUNNEL_IP:-"10.53.0.1/27"}

# Thanks to https://github.com/jpetazzo/dockvpn for the tun/tap fix
mkdir -p /dev/net
mknod /dev/net/tun c 10 200

while [ 1 ]
do
  iodined -c -u nobody -f -P $IODINE_PASSWORD $TUNNEL_IP $IODINE_HOST 
  sleep 2
done
