#!/bin/sh
#jatkossa tablesin käskytys tässä vai casessa?
sudo /sbin/ifdown eth0

#HUOM.210124:laitettu jemmaan koska ei toiminut, toiv josqs takaisin
sudo ${HOME}/Dpckcer/project/scripts/tables.sh ${1}

case $1 in
	start)
		sudo ${HOME}/Dpckcer/buildr/source/scripts/part4.sh 0 ${2}
#
#		docker system prune
#		docker network rm project_default
#		docker network rm project_private
		
		sleep 5
		sudo /sbin/ifup eth0
		sleep 3
		/usr/bin/docker-compose -f another.yml up
	;;
	stop)
		/usr/bin/docker-compose -f another.yml down
		sleep 3
#		docker network rm project_default
#		docker network rm project_private
		sleep 3
		sudo ${HOME}/Dpckcer/buildr/source/scripts/part4.sh 1 ${2}
	;;
	*)
		echo "$0 start | stop"
	;;
esac
