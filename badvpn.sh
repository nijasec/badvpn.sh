#!/bin/bash
server_addr=ssh-9.sshstores.net
port=442
username=pakru
password=322855
server_ip=$(dig +short $server_addr)
sshpass -p $password  ssh -o "StrictHostKeyChecking=no" $username@$server_ip -p $port -D 127.0.0.1:3128 -N &


sudo route del default
sudo openvpn --mktun --dev tun0 --user noname
sudo ifconfig tun0 10.10.0.1 netmask 255.255.255.0
sudo route add $server_ip gw 192.168.1.1 metric 4
sudo route add default gw 10.10.0.1 metric 6
sudo route add 8.8.8.8 gw 192.168.1.1 metric 4
badvpn-tun2socks --tundev tun0 --netif-ipaddr 10.10.0.1 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:3128 --udpgw-remote-server-addr 127.0.0.1:7313 --loglevel warning

sudo route del default
sudo route add default gw  192.168.1.1
