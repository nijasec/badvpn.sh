#!/bin/bash
server_addr=ssh-9.sshstores.net
server_ip=$(dig +short $server_addr)
defaultip=192.168.1.1
sudo route add $server_ip gw $defaultip metric 4
server_ip=localhost
port=1443
username=pakru
password=322855
sudo stunnel st.conf 
sleep 3
sshpass -p $password  ssh -o "StrictHostKeyChecking=no" $username@$server_ip -p $port -D 127.0.0.1:3128 -N &
echo "waiting..."
sleep 5
echo "done"
sudo route del default
sudo openvpn --mktun --dev tun0 --user noname
sudo ifconfig tun0 10.10.0.1 netmask 255.255.255.0

sudo route add default gw 10.10.0.1 metric 6
sudo route add 8.8.8.8 gw $defaultip metric 4
badvpn-tun2socks --tundev tun0 --netif-ipaddr 10.10.0.1 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:3128 --udpgw-remote-server-addr 127.0.0.1:7313 --loglevel warning

sudo route del default
sudo route add default gw  $defaultip
