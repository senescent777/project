#!/bin/sh
debug=0

case ${1} in
	-v)
		debug=1
	;;
esac

#HUOM.
#sävellysvaiheessa oltava sorkkimaton dns
#kun taas laitetaan sävellyksen tulos pystyyn on nimenomaan oltava sorkittu 

sudo /sbin/ifup eth0
[ -d /home/devuan/Dpckcer/buildr/tmp ] || mkdir -p /home/devuan/Dpckcer/buildr/tmp

if [ -s /home/devuan/Dpckcer/buildr/tmp/tm.tar ] ; then
	[ ${debug} -eq 1 ] && echo "tm.tar already exists"
	cp /home/devuan/Dpckcer/buildr/bin/ft.sh /home/devuan/Dpckcer/buildr/tmp
	sleep 5
else
	[ ${debug} -eq 1 ] && echo "have to run part2.sh"
	sleep 10
	/opt/bin/part2.sh ${1}
fi

[ ${debug} -eq 1 ] && sleep 3
#/opt/bin/part3.sh ${1}
~/Dpckcer/buildr/source/scripts/part3.sh ${1}
sudo /sbin/ifdown eth0
[ ${debug} -eq 1 ] && sleep 3

#johonkin kohtaan tämmöistä... paitsi että ei, stkee
#docker network rm project_public
#docker network rm project_private

echo "cd /home/devuan/Dpckcer/project;./scripts/demo.sh start"
[ ${debug} -eq 1 ] && sleep 3
