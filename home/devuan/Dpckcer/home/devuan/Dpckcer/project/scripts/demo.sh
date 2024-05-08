#!/bin/sh
#jatkossa tablesin käskytys tässä vai casessa?
sudo /sbin/ifdown eth0
sleep 3

#HUOM.210124:laitettu jemmaan koska ei toiminut, toiv josqs takaisin
sudo ${HOME}/Dpckcer/project/scripts/tables.sh ${1}

case $1 in
	start)
		docker network rm project_default
		sudo ${HOME}/Dpckcer/buildr/source/scripts/part4.sh 0 ${2}
		
		sleep 3
		sudo /sbin/ifup eth0
		sleep 3
		
		/usr/bin/docker-compose -f another.yml up
	;;
	stop)
		/usr/bin/docker-compose -f another.yml down

		sleep 3
		sudo ${HOME}/Dpckcer/buildr/source/scripts/part4.sh 1 ${2}
	;;
	*)
		echo "$0 start | stop"
	;;
esac
