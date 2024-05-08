#!/bin/sh

tgtdir=/tmp
tgtfile=app.tar
lstfile=${tgtdir}/.list2
debug=0
base=${HOME}/Dpckcer

#TODO:skrpteistä ja muista # karsiminen, kts vaikka hithubista mallia
tar_opts=""

parse_opts() {
	case ${1} in
		-v)
			debug=1
			tar_opts="${tar_opts} -v"
		;; 
		-T)
			lstfile=${2}
		;;
	esac
}

parse_opts ${2} ${3}
parse_opts ${4}

case ${1} in
	m)
		mv ${lstfile} ${lstfile}.OLD
		sleep 1
		
		find /home/devuan/Dpckcer/buildr/pre -type f  >> ${lstfile}
		
		find / -type f -name sources.list >> ${lstfile}
		find / -type f -name 01recommended >> ${lstfile}
		find / -type f -name sysctl.conf >> ${lstfile}
		
		find ${base}/buildr/bin -type f -name '*.sh' >> ${lstfile}
		find ${base}/buildr/bin -type f -name '*.conf' >> ${lstfile}
		find ${base} -type f -name 'Docker*' | grep -v '.OLD' >> ${lstfile}
		
		#HUOM.200124:var,uude buoksi pakotetaan tääkin 
		find ${base}/buildr  -type f -name '*.gpg' | grep -v '.OLD'  >> ${lstfile}
		
		#tä,äkin myös listan alkuun koska debug
		find ${base} -type f -name '*.yml'  | grep -v '.OLD' >> ${lstfile}

		#TODO:vähitellen jokin järjetely sen tables-sh kanssa, poimitaan asennuspakettiin vaikka oikeastaan buildrin tontilla
		
		#echo "${base}/buildr/bin/FIRST_RUN" >> ${lstfile}
		#echo "${base}/buildr/bin/mk_ruls" >> ${lstfile}
		#echo "${base}/buildr/bin/mutilate_sql_2" >> ${lstfile}
		
		#echo "${base}/buildr/tmp/tm.tar" >> ${lstfile}
		#echo "${base}/buildr/tmp/tm.tar.2" >> ${lstfile}
		find ${base}/buildr/tmp -type f -name 'tm.tar*' >> ${lstfile}
		
		#find /etc -type f -name 'resolv.conf.new' >> $lstfile
		find /etc/dhcp -type f -name 'dhclient.conf.new' >> $lstfile
		find /sbin -type f -name 'dhclient-script.new' >> $lstfile

		echo "/opt/bin/meshuggah" >> $lstfile
		#echo "/etc/apt/sources.list" >> $lstfile
		#echo "/etc/apt/apt.conf.d/01recommended" >> $lstfile
		#echo "/etc/sysctl.conf" >> $lstfile
		echo "/etc/network/interfaces" >> $lstfile

		find /opt/bin -type f -name '*.sh' | grep -v 'jenna' >> ${lstfile}

		echo "${base}/buildr/source/requirements.txt" >> ${lstfile}
		echo "${base}/buildr/source/resolv.conf.13" >> ${lstfile}
	
		#3 seur ei ehkä tarpeellisia jatkossa
		#echo "${base}/buildr/3.16.tar" >> ${lstfile}
		#echo "${base}/buildr/openssl.tar" >> ${lstfile}
		#echo "${base}/project/app/Pipfile" >> ${lstfile}
		
		find ${base}/buildr/source -type f -name '*.0' | grep -v '.OLD' >> ${lstfile}
		find ${base}/buildr/source -type f -name '*.sh' | grep -v '.OLD' >> ${lstfile}
		find ${base}/buildr/source -type f -name '*.tar' | grep -v '.OLD' >> ${lstfile}
		find ${base}/buildr/source -type f -name 'rules.*' | grep -v '.OLD' >> ${lstfile}

		#konftdsrojen kanssa tuplavarmistus
		find ${base}/project -type f -name '*.conf' | grep -v '.OLD' >> ${lstfile}

		#HUOM.1. oltava -v '.conn' eikä '.con'
		#HUOM.2. temporary1 permanent1 pois listalta jotta pääsee testaamaan:populate3
		for d in ro1 index cleaner kronos  keys ; do
			find ${base}/project/${d} -type f | grep -v 'possu' | grep -v '.OLD' | grep -v '.env' | grep -v '.pg' | grep -v '.conn' >> $lstfile
		done

		#tilapäinen tuplavarmistus mjölnirin kanssa, toiv pois josqs
		find ${base}/project/keys -type f -name 'mjolnir*' | grep -v 'jenna' >> ${lstfile}

		find ${base}/project/app/templates -type f | grep -v '.OLD' >> ${lstfile}
		find ${base}/project/app -name '*.py' -type f | grep -v '.OLD' >> ${lstfile}

		echo ${lstfile}
		[ ${debug} -eq 1 ] && cat ${lstfile}
	;;
	b)
		[ -f $tgtdir/$tgtfile ] && mv $tgtdir/$tgtfile $tgtdir/$tgtfile.OLD
		tar $tar_opts -cpf $tgtdir/$tgtfile -T $lstfile
	;;
	-h)
		echo "$0 (b|m) [-v] [-T <file>]"
	;;
	*)
		echo "$0 -h"
	;;
esac
