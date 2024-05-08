#!/bin/sh
debug=0

case ${2} in
	-v)
		debug=1
	;;
esac

#varmistetaan viiveellä ett' muutokset ehitivät päibittyä levulle...tai jokin toinen komento parempi
if [ ${debug} -eq 1 ] ; then  
	/bin/sync /
	sleep 5
fi

#mangle5() {
#	if [ -f $1 ] ; then
#		chattr -ui $1
#		sleep $1
#		chmod 0444 $1
#		chown root:root $1
#		sleep 1
#		chattr +ui $1
#	fi
#	}

case ${1} in
	0)
		#koitetaam uudestaan r net rm kanssa 270124, tosin vissiin demo.sh
		
		[ -f /etc/resolv.conf.ORIG ] && rm /etc/resolv.conf
		ln -s /etc/resolv.conf.new /etc/resolv.conf

		[ -f /etc/dhcp/dhclient.conf.ORIG ] && rm /etc/dhcp/dhclient.conf	
		ln -s /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf

		[ -f /sbin/dhclient-script.ORIG ] && rm /sbin/dhclient-script
		ln -s /sbin/dhclient-script.new /sbin/dhclient-script
	;;
	1)
		[ -f /etc/resolv.conf.ORIG ] && rm /etc/resolv.conf 
		ln -s /etc/resolv.conf.ORIG /etc/resolv.conf

		[ -f /etc/dhcp/dhclient.conf.ORIG ] && rm /etc/dhcp/dhclient.conf
		ln -s /etc/dhcp/dhclient.conf.ORIG /etc/dhcp/dhclient.conf

		[ -f /sbin/dhclient-script.ORIG ] && rm /sbin/dhclient-script
		ln -s /sbin/dhclient-script.ORIG /sbin/dhclient-script
	;;
esac

if [ ${debug} -eq 1 ] ; then 
	/bin/sync /
	sleep 5
	echo "D.ONE"
	echo "d-c -f sokcs.yml up | down"
fi
