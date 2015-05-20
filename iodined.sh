#!/bin/sh

TUNNEL_IP=${IODINE_TUNNEL_IP:-"10.53.0.1/27"}

# Thanks to https://github.com/jpetazzo/dockvpn for the tun/tap fix
mkdir -p /dev/net
mknod /dev/net/tun c 10 200

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A  POSTROUTING -s $TUNNEL_IP -o eth0 -j MASQUERADE
iptables -A FORWARD -i dns0 -j ACCEPT
iptables -A FORWARD -i dns0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o dns0 -m state --state RELATED,ESTABLISHED -j ACCEPT



while [ 1 ]
do
  iodined -c -u nobody -f -P $IODINE_PASSWORD $TUNNEL_IP $IODINE_HOST
  sleep 2
done
