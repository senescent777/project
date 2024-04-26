#!/bin/sh
chmod 0555 /opt/bin/part1.sh
p2=0
debug=0
/sbin/ifup eth0

if [ $? -eq 0 ] ; then
	echo "OK"
else
	echo "resolv.conf | dhclient.conf | tables"
	exit
fi

#HUOM. eth0 tarvitaan vasta part1.sh kanssa mutta huomautetaan jo ajoissa jos vikaa vikaa
#HUOM.230124:p2 turhahko nykyään
case ${1} in
#     1)
#        p2=1
#     ;;
	-v)
		debug=1
	;;
esac

#if [ ${debug} -eq 1 ] ; then 
#	/opt/bin/part1.sh 5 1
#else
#	/opt/bin/part1.sh 5 0
#fi
for m in 1 2 3 4 5 ; do /opt/bin/part1.sh $m $debug ; done

#HUOM. jos ei ala docker löytää sokcs.yml ni su part2 takaisin tähän skriptiin
#if [ ${p2} -eq 1 ] ; then 
#	if [ ${debug} -eq 1 ] ; then 
#		echo "PART2";sleep 30
#		su devuan -c /opt/bin/part2.sh -v
#	else
#		su devuan -c /opt/bin/part2.sh
#	fi
#fi

/sbin/ifdown eth0

if [ ${debug} -eq 1 ] ; then 
	echo "TODO: iptables-restore --noflush /home/devuan/Dpckcer/project/DOCKER-USER.txt"
	sleep 6
fi

echo "after logout, login and run install2.sh as devuan";sleep 6
/opt/bin/part1.sh 6
exit
