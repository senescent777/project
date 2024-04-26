#VAIH:koodin jakaminen metodeihin jotta voisi devauskoneen kautta mielekkästi käyttää
#pitäisi olla jo päällä kun install.sh kautta kutsutaan mutta varm vuoksi
part1() {
	/sbin/ifup eth0
	apt-get update

	if [ $? -eq 0 ] ; then
		echo "a.g.u OK";sleep 1
	else
		echo "ca-certificates | sources.list | date --set"
		exit
	fi

	apt-get -y remove --purge avahi*
	apt-get -y remove --purge pol* libsane* blu* cups* exim*
	apt-get -y remove --purge sntp* ntp* rpc* nfs*
	apt -y autoremove

	sleep 1

	apt-get -y install docker-compose docker.io
	#apt get -y install acl tarpeellinen?
	groupadd docker
	usermod -aG docker devuan
	sleep 1

	#sync uutena 150124
	if [ ${debug} -eq 1 ] ; then  
		echo "apt_g3t_d0n3()"
		sleep 5
		/bin/sync /
	fi
}

#tähän voiai päättyä eka meotdi

mangle5() {
	if [ -f $1 ] ; then 
		chmod 0444 $1
		chown root:root $1
		#chattr +ui $1 i ja linmkit ei sovi yhteen vai sopiiko?
	fi
	}

part2() {
	if [ -s /etc/resolv.conf.new ] ; then
		[ ${debug} -eq 1 ] && echo "res.conf.new found"
	else
		cp ${base}/buildr/source/resolv.conf.new.BAK /etc/resolv.conf.new
	fi

	mangle5 /etc/resolv.conf.new

	#toiv ei deletoidu tää hmisto tai tdsto liian aikaisin
	[ -d ${base}/buildr/tmp/dsn/t ] || mkdir -p ${base}/buildr/tmp/dsn/t 
	cp /etc/resolv.conf ${base}/buildr/tmp/dsn/t
	mangle5 ${base}/buildr/tmp/dsn/t/resolv.conf.13
	
	if [ ${debug} -eq 1 ] ; then  
		echo "res.13 d0n3"
		/bin/sync /
		/bin/sync /home
		sleep 5
	fi

	if [ -s /etc/dhcp/dhclient.conf.new ] ; then
		[ ${debug} -eq 1 ] && echo "dhc.conf.new found"
	else
		cp ${base}/buildr/source/dhclient.conf.new.BAK /etc/dhcp/dhclient.conf.new
	fi

	mangle5 /etc/dhcp/dhclient.conf.new
	
	if [ -s /sbin/dhclient-script.new ] ; then
		[ ${debug} -eq 1 ] && echo "dhc-s-.new found"
	else
		cp ${base}/buildr/source/dhclient-script.new.BAK /sbin/dhclient-script.new
	fi

	#HUOM. chattr +i ja linkitys
	mangle5 /sbin/dhclient-script.new

	for f in /etc/resolv.conf /etc/dhcp/dhclient.conf /sbin/dhclient-script ; do
		if [ -s ${f}.ORIG ] ; then
			echo "# ${f}.ORIG ALR3ADY 3X1STS #"
			#chattr -ui ${f}.ORIG
			[ ${debug} -eq 1 ]  && sleep 1
		else
			cp ${f} ${f}.ORIG
		fi

		mangle5 ${f}.ORIG 
	done
	
	if [ ${debug} -eq 1 ] ; then  
		echo "res.13 d0n34"
		/bin/sync /
		/bin/sync /home
		sleep 5
	fi
	
	#chmod a+x uutena 150124
	[ ${debug} -eq 1 ] && sleep 5
	chattr -ui /sbin/dhclient-script.ORIG
	[ ${debug} -eq 1 ] && sleep 5
	chmod a+x /sbin/dhclient-script.ORIG
	#chattr +ui /sbin/dhclient-script.ORIG
	
	#vielä uudemi vhmd 230124
	[ ${debug} -eq 1 ] && sleep 5
	chattr -ui /sbin/dhclient-script.new
	[ ${debug} -eq 1 ] && sleep 5
	chmod a+x /sbin/dhclient-script.new
	#chattr +ui /sbin/dhclient-script.new
	
	sleep 5
	
	if [ ${debug} -eq 1 ] ; then 
		echo "b3f0r3_mangl3()"
	fi
	
	/bin/sync /
}

#HUOM:dhclient-script lisätäÄN sudoersiin ilman sha-kikkailua 230124

mangle_s() {
	if [ -s ${1} ] ; then 
		#chattr -ui ${1}
		[ ${debug} -eq 1 ] && echo "W3NGL3 $1";sleep 5
		chmod 0555 ${1}
		chown root:root  ${1} #uutena tämä
		#chattr +ui ${1}

		echo -n "devuan localhost=NOPASSWD: sha256:" >> /etc/sudoers.d/meshuggah
		local s
		s=$(sha256sum ${1})
		echo ${s} >> /etc/sudoers.d/meshuggah
	fi
}

mangle2() {
	if [ -f ${1} ] ; then #onkohan tää testi hyvä idea?
		#chattr -ui ${1}
		[ ${debug} -eq 1 ] && echo "MANGLED $1";sleep 1
		chmod o-rwx ${1}
		chown root:root ${1}
		[ ${debug} -eq 1 ] && sleep 1
		#chattr +ui ${1}
	fi
}

#HUOM. pitäisiköhän /e/s.d/m delliä ennen ekaa mangle_s ? no nykyään 230124 näin tehdään
part3() {
	#chattr -ui /etc/sudoers.d
	
	if [ -f /etc/sudoers.d/meshuggah ] ; then
		#chattr -ui /etc/sudoers.d/meshuggah
		shred -fu  /etc/sudoers.d/meshuggah
	else 
		touch /etc/sudoers.d/meshuggah
	fi
	
	/bin/sync /	;sleep 5
	#HUOM!!! ÄLÄ POISTA AO RIVI VAIKKA /home ALLA ONKIN SAMANNIMINEN
	mangle_s /opt/bin/meshuggah.sh
	mangle_s ${base}/buildr/source/scripts/part4.sh

	#HUOM. jos täss lisätään sudoersiin ni eivoi buildr laittaa tdstoa uusiksi myöhemmin
	mangle_s ${base}/project/scripts/tables.sh
	echo "devuan localhost=NOPASSWD: /sbin/dhclient-script.ORIG " >> /etc/sudoers.d/meshuggah
	echo "devuan localhost=NOPASSWD: /sbin/dhclient-script.new " >> /etc/sudoers.d/meshuggah
	
	#chattr -ui /sbin
	/bin/sync /;sleep 5
	
	#for f in ORIG new ; do mangle_s /sbin/dhclient-script.${f} ; done
	#HUOM.150124:dhclient.script EI KANNATA laittaa sudoersiin koska x
	#tässä oli muuten jotain urputusta, miksiköhän?
	
	for f in ifup ifdown ; do mangle_s /sbin/${f} ; done
	chmod 0755 /sbin
	chown root:root /sbin
	#chattr +u /sbin i perseestä jox meinaa kikkailla linkkien kanssa niinq

	if [ ${debug} -eq 1 ] ; then 
		echo "m0st 0f mang11ng d0n3"
		sleep 5
		/bin/sync /
		/bin/sync /home
	fi

	#HUOM.230124:otava erikseen /e/s.d sorkkiminen ja erikseen /e/s* sorkkininen
	for f in $(find /etc/sudoers.d/ -type f) ; do mangle2 ${f} ; done

	if [ ${debug} -eq 1 ] ; then
		echo "b3f0r3_chattr()" 
		/bin/sync /
		/bin/sync /home
		sleep 5
	fi

	#mangle sudo.conf,sudoers jossain vaih?
	#HUOM. /e/i/sudo, /e/p.d/sudo , tarpeellista sorkkia?
	echo "MANGLING SUDO!!!"
	
	sleep 20
	for f in $(find /etc -name 'sudo*' -type f | grep -v log) ; do 
		echo "666!!! SODOMIZING $f 666!!!"
		mangle2 ${f}
		sleep 6
	done
	
	#täh päät part3
	chattr +ui /etc/sudoers.d
	
	if [ ${debug} -eq 1 ] ; then 
		ls -la /etc/sudo* 
		sleep 3
		/bin/sync /
		echo "b3f0r3_chown()"
		sleep 5
	fi
}

part4() {
	[ -d ${base}/buildr/tmp ] || mkdir -p ${base}/buildr/tmp
	chown devuan:devuan ${base}
	chown devuan:devuan ${base}/project
	chown devuan:devuan ${base}/buildr

	chown -R devuan:devuan ${base}/project/*
	chown devuan:devuan ${base}/buildr/tmp

	[ -s ${base}/buildr/pre/sources.list ] || cp /etc/apt/sources.list ${base}/buildr/pre/ 
	[ -s ${base}/buildr/pre/sysctl.conf ] || cp /etc/sysctl.conf ${base}/buildr/pre/ 
	[ -s ${base}/buildr/pre/01recommended ] || cp /etc/apt/apt.conf.d/01recommended ${base}/buildr/pre/ 
	ls -las ${base}/buildr/pre/

	if [ ${debug} -eq 1 ] ; then 
		echo "pt1.4.1_d0n3()"
		/bin/sync /
		/bin/sync /home
		sleep 5
	fi
	
	#sync uuten1 150124
	[ ${debug} -eq 1 ] && /bin/sync /
	[ ${debug} -eq 1 ] && echo "b3f0r3 chmod"

	#chattr -ui /opt/bin/*.sh
	[ ${debug} -eq 1 ] && /bin/sync /

	chmod 0555 /opt/bin/*.sh
	chown root:root /opt/bin/install*.sh
	chown root:root /opt/bin/part*.sh
	
	[ ${debug} -eq 1 ] && /bin/sync /
	chattr +ui /opt/bin/*.sh

	#chown devuan:devuan /opt/bin/part3.sh #HUOM.080124:tarpeellinen?
	chown devuan:devuan /home/devuan
	chown root:root / #HUOM.140124 uutena
	chmod 0755 /
	sleep 5

	for g in $(find /home/devuan/Dpckcer/project/permanent1 -type f) ; do
		echo "CHATTR +UI $g";sleep 1
		chattr +ui $g #TARKKUUTTA PERKELE!!!
	done

	[ ${debug} -eq 1 ] && echo "aft3r chmod"
	[ ${debug} -eq 1 ] && /bin/sync /
	[ ${debug} -eq 1 ] && /bin/sync /home
	
	#VAIH:TÄHÄN jatkoksi ne perm- hmiston alaisten chattr
	
}

part666() {
	#tarvitaan logout+login jotta polut sunmuut päivittyvät
for p in $(ps -aux | grep xfce4-session | awk '{print $2}') ; do kill -9 ${p} ; done
	}
