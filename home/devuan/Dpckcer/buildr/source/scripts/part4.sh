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
		[ -f /etc/resolv.conf.ORIG ] && rm /etc/resolv.conf
		##echo "nameserver 127.0.0.1" > /etc/resolv.conf.new
		#chattr -ui /etc/resolv.conf.new
		#chmod 0444 /etc/resolv.conf.new
		#chattr +ui /etc/resolv.conf.new
		#mangle5 /etc/resolv.conf.new
		ln -s /etc/resolv.conf.new /etc/resolv.conf

		[ -f /etc/dhcp/dhclient.conf.ORIG ] && rm /etc/dhcp/dhclient.conf
		#chattr -ui /etc/dhcp/dhclient.conf.ORIG
		#chmod 0444 /etc/dhcp/dhclient.conf.ORIG
		#chattr +ui /etc/dhcp/dhclient.conf.ORIG
		#mangle5 /etc/dhcp/dhclient.conf.ORIG		
		ln -s /etc/dhcp/dhclient.conf.new /etc/dhcp/dhclient.conf

		[ -f /sbin/dhclient-script.ORIG ] && rm /sbin/dhclient-script
		#chattr -ui /sbin/dhclient-script.new
		#chmod 0555 /sbin/dhclient-script.new
		#chattr +ui /sbin/dhclient-script.new
		#mangle5 /sbin/dhclient-script.new
		ln -s /sbin/dhclient-script.new /sbin/dhclient-script
	;;
	1)
		[ -f /etc/resolv.conf.ORIG ] && rm /etc/resolv.conf
		#chattr -ui /etc/resolv.conf.ORIG 
		#chmod 0444 /etc/resolv.conf.ORIG 
		#chattr +ui /etc/resolv.conf.ORIG 
		ln -s /etc/resolv.conf.ORIG /etc/resolv.conf

		[ -f /etc/dhcp/dhclient.conf.ORIG ] && rm /etc/dhcp/dhclient.conf
		#chattr -ui /etc/dhcp/dhclient.conf.ORIG
		#chmod 0444 /etc/dhcp/dhclient.conf.ORIG
		#chattr +ui /etc/dhcp/dhclient.conf.ORIG
		ln -s /etc/dhcp/dhclient.conf.ORIG /etc/dhcp/dhclient.conf

		[ -f /sbin/dhclient-script.ORIG ] && rm /sbin/dhclient-script
		#chattr -ui /sbin/dhclient-script.ORIG
		#chmod 0555 /sbin/dhclient-script.ORIG
		#chattr +ui /sbin/dhclient-script.ORIG
		ln -s /sbin/dhclient-script.ORIG /sbin/dhclient-script
	;;
esac

if [ ${debug} -eq 1 ] ; then 
	/bin/sync /
	sleep 5
	echo "D.ONE"
	echo "d-c -f sokcs.yml up | down"
fi
