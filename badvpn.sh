#!/bin/bash

trap printout SIGINT
printout () 
{
echo "Terminated by User"

sudo route del default
sudo route add default gw  $defaultip
sudo ip link delete tun0
exit
}
sudo stunnel st.conf 
sudo openvpn --mktun --dev tun0 --user noname
sudo ifconfig tun0 10.10.0.1 netmask 255.255.255.0
server_addr=ssh-9.sshstores.net
server_ip=$(dig +short $server_addr)
defaultip=192.168.1.1
sudo route add $server_ip gw $defaultip metric 4

server_ip=localhost
port=1443
username=pakru
password=322855
sudo route del default
sudo route add default gw 10.10.0.1 metric 6
sudo route add 8.8.8.8 gw $defaultip metric 4
badvpn-tun2socks --tundev tun0 --netif-ipaddr 10.10.0.1 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:3128 --udpgw-remote-server-addr 127.0.0.1:7313 --loglevel warning &
while :
do
sshpass -p $password  ssh -o "StrictHostKeyChecking=no" $username@$server_ip -p $port -D 127.0.0.1:3128 -N 
echo "wating 6 sec..."
sleep 6

done;

