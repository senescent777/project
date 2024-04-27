#!/bin/sh
. ~/bin/dirs.conf
debug=0

#TODO:/opt/bin sisältö myös (?)
tgt=${HOME}/tmp/scripts/tables.sh
ipt=/usr/sbin/iptables
	
parse_opts() {
	case ${1} in
		-v)
			debug=1
		;; 
	esac
}

parse_opts ${1}

pre2() {
	[ $debug -eq 1 ] && echo "pre"

	[ -s ${HOME}/tmp/.env ] && . ${HOME}/tmp/.env 
	rm ${HOME}/tmp/stq1
	[ $debug -eq 1 ] && sleep 1
	touch ${HOME}/tmp/stq1
	[ $debug -eq 1 ] && sleep 1

	[ -f ${1} ] && mv ${1} ${1}.OLD
	sleep 1
	touch ${1}
	sleep 1
}

pre2 ${tgt}

pre() {
	[ $debug -eq 1 ] && echo "pre2"
	echo "#!/bin/sh" >> ${1}
	echo "ipt=${ipt}" >> ${1}
	echo "case \$1 in " >> ${1}
	echo "	start)" >> ${1}
	
	echo "		\${ipt} -A DOCKER-USER -m conntrack --ctstate INVALID -j DROP" >> ${1}
	echo "		\${ipt} -A DOCKER-USER -p tcp -m multiport --dports 0:1024 -j DROP" >> ${1}	
	echo "		\${ipt} -A DOCKER-USER -p tcp -m multiport --sports 0:1024 -j DROP" >> ${1}
}

pre ${tgt}

for d in ${THIS_DBKEY_TCP} ; do
	#tähän tarvitsisi ehkä nimi-ip-mappayksen
	[ ${debug} -eq 1 ] && echo "make rules 4 ${d}"

	#HUOM. 160124:parempi jos saisi lisätyksi tässä alla sen $ipt:n mutta nyt näin
	if [ -s ${HOME}/source/rules.${d} ] ; then 
		grep -v '#' ${HOME}/source/rules.${d} >> ${tgt}
	fi
done

post() {
	[ $debug -eq 1 ] && echo "post"
	
	echo "	;;" >> ${1}
	echo "	stop)" >> ${1}
	echo " 		\${ipt} -F DOCKER-USER" >> ${1}
	echo " 		\${ipt} --A DOCKER-USER -j RETURN" >> ${1}

	echo "	;;" >> ${1}
	echo "esac " >> ${1}
	
	[ $debug -eq 1 ] && sleep 1
	[ $debug -eq 1 ] && echo "post2"
	
	local base
	base=${HOME}/tmp
	
	#sitten sed:illä muokataan olemassaolevat säännöt (.env voisi hyödyntää)
	echo "sed -i 's/172.19.0.2/${INDXIP}/g' ${1}" >> ${base}/stq1
	echo "sed -i 's/443/${RW_PORT}/g' ${1}" >> ${base}/stq1

	#pitäisiköhän näille tehdä jotain?
	echo "sed -i 's/INPUT/DOCKER-USER/g' ${1}" >> ${base}/stq1
	echo "sed -i 's/OUTPUT/DOCKER-USER/g' ${1}" >> ${base}/stq1

	#TEHTY?:my.post.conf -> my.post koska aiemmat skriptit
	echo "sed -i 's/5234/${PGPORT}/g' ${base}/sql/2/pg_hba.conf" >> ${base}/stq1
	echo "sed -i 's/5234/${PGPORT}/g' ${base}/sql/2/my.post" >> ${base}/stq1
	echo "sed -i 's/172.18.0.10/${PQIP}/g' ${base}/sql/2/pg_hba.conf" >> ${base}/stq1
	echo "sed -i 's/172.18.0.10/${PQIP}/g' ${base}/sql/2/my.post" >> ${base}/stq1

	#tai mikä se possun oletusportti olikaan
	echo "sed -i 's/5234/${PGPORT}/g' ${1}" >> ${base}/stq1
	echo "sed -i 's/172.18.0.10/${PQIP}/g' ${1}" >> ${base}/stq1

	#VAIH:443/RW_PORT myös tdstoon init.sql barm vuoksi
	echo "sed -i 's/443/${RW_PORT}/g' ${base}/sql/1/init-user-db.sql" >> ${base}/stq1
}

post ${tgt}
cat ${HOME}/tmp/stq1 | sh -s
chmod 0555 ${tgt}
[ ${debug} -eq 1 ] && echo "iptables-restore --noflush ${tgt}"
