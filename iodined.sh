#!/bin/sh

TUNNEL_IP=${IODINE_TUNNEL_IP:-"10.53.0.1/27"}

# Thanks to https://github.com/jpetazzo/dockvpn for the tun/tap fix
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

echo "Network: $TUNNEL_IP"
iptables -t nat -A POSTROUTING -s $TUNNEL_IP -o eth0 -j MASQUERADE
# iptables -t nat -C POSTROUTING -s $TUNNEL_IP -o eth0 -j MASQUERADE || {
#   
#   }

# iptables -C FORWARD -i dns0 -j ACCEPT || { 
#   iptables -A FORWARD -i dns0 -j ACCEPT
#   }
#   
# iptables -C FORWARD -i dns0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT || {
#   iptables -A FORWARD -i dns0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#   }
#  
# iptables -C FORWARD -i eth0 -o dns0 -m state --state RELATED,ESTABLISHED -j ACCEPT || {
#   iptables -A FORWARD -i eth0 -o dns0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
#   }

iodined -c -u nobody -f -P $IODINE_PASSWORD $TUNNEL_IP $IODINE_HOST
