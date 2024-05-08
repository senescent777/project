#!/bin/sh
ipt=/usr/sbin/iptables
case $1 in 
	start)
		${ipt} -A DOCKER-USER -m conntrack --ctstate INVALID -j DROP
		${ipt} -A DOCKER-USER -p tcp -m multiport --dports 0:1024 -j DROP
		${ipt} -A DOCKER-USER -p tcp -m multiport --sports 0:1024 -j DROP
${ipt} -A DOCKER-USER -s 172.19.0.1/32 -d 172.19.0.2/32 -i eth0 -p tcp -m tcp --dport 443 -j ACCEPT
${ipt} -A DOCKER-USER -s 172.19.0.2/32 -d 172.19.0.0/27 -o eth0 -p tcp -m tcp --sport 443 -j ACCEPT
${ipt} -A DOCKER-USER -s 172.19.0.1/32 -d 172.19.0.5/32 -i eth0 -p tcp -m tcp --dport 443 -j ACCEPT
${ipt} -A DOCKER-USER -s 172.19.0.5/32 -d 172.19.0.0/27 -o eth0 -p tcp -m tcp --sport 443 -j ACCEPT
	;;
	stop)
 		${ipt} -F DOCKER-USER
 		${ipt} --A DOCKER-USER -j RETURN
	;;
esac 
