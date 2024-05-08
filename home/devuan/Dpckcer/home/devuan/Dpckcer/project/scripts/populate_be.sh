checksig_base=$(which gpg)
checksig_cmd="${checksig_base} -q --verify"
ext="sig"

#HUOM.150124:kontilla kun yrittää ajaa niin seuraa:
#gpg: WARNING: recipients (-r) given without using public key encryption
#gpg: signing failed: Permission denied
gnis() {
		[ ${3} -eq 1 ] && echo "gris ${1} ${2} ${3} ${4}"
			
		case ${1} in
			sig)
				#tämä vaatisi salaiset avaimet, olettaen että parametrit oikein
				${checksig_base} --pinentry-mode loopback --sb -u thor ${2}
			;;
			*)
				[ ${3} -eq 1 ] && echo "${1} not implemented"
			;;
		esac
}

mk_rnd_fil() {
	[ ${2} -eq 1 ] && echo "mk_rndfil $1 $2 $3"
	
	local amt
	amt=$(dd if=/dev/urandom bs=2 count=1 | hexdump -d | awk '{print $2}' | tr -d 0)
	
	[ ${2} -eq 1 ] && echo "dd if=/dev/urandom bs=${amt} count=1 | base64 - > ${1}"
	dd if=/dev/urandom bs=${amt} count=1 | base64 - > ${1}
	
	if [ $? -gt 0 ] ; then
		[ ${2} -eq 1 ] && echo "sudo /opt/bin/xxx.sh"
	fi
}

#TODO:pitäsiköhän nakittaa minideb-kontille ne allekirjoitukset

process_row() {
	[ ${3} -eq 1 ]  && echo "process_row ${1} ${2} ${3}"
	mk_rnd_fil ${1}/a.un-jong.4ktdemo ${3}
	gnis ${ext} ${1}/a.un-jong.4ktdemo ${3}
	
	mk_rnd_fil ${1}/placeholder
	gnis ${ext} ${1}/placeholder ${3}
	
	[ ${3} -eq 1 ] && echo "pt1 d0n3()";sleep 1
	[ ${3} -eq 1 ] && ls -las $1 ;sleep 3
	
	#bobby tables-rivi tr-jekun testausta varten
	if [ ${2} -eq 1 ] ; then
		mk_rnd_fil ${1}/'bobby_tables;DROP' ${3}
		gnis ${ext} ${1}/'bobby_tables;DROP' ${3}
	fi

	#tarkoituksella ei mene läpi (eo allekirj)
	mk_rnd_fil ${1}/a.bc.def ${3}

	#m,enee lkäpoi
	mk_rnd_fil ${1}/a.bc.def2 ${3}
	gnis ${ext} ${1}/a.bc.def2 ${3}
	
	#tarkoituksella ei mene läpi (tauhklaa allekijr jälkeen)
	local n 
	n=$(mktemp -p ${1})

	if [ $? -gt 0 ] ; then
		[ ${3} -eq 1 ] && echo "sudo /opt/bin/xxx.sh tjsp"
	fi
		
	mk_rnd_fil ${n} ${3} 
	gnis ${ext} ${n} ${3} 
	dd if=/dev/urandom bs=12 count=1 >> ${n}

	n=$(mktemp -p ${1})
	mk_rnd_fil ${n} ${3} 
	n=$(mktemp -p ${1})
	mk_rnd_fil ${n} ${3} 

	[ -f ${1}/index.html ] || cp bak/index.html ${1}/
	gnis ${ext} ${1}/index.html ${3}
	[ $? -eq 0 ] || echo "sudo /opt/bin/xxx.sh"
	gnis ${ext} ${n} ${3}

	n=$(dd if=/dev/urandom bs=4 count=1 | hexdump | awk '{print $2}' | cut -d 0 -f 2 )
	n=${1}/a.bb.${n}
	mk_rnd_fil ${n} ${3}
	gnis ${ext} ${n} ${3}

	n=$(dd if=/dev/urandom bs=4 count=1 | hexdump | awk '{print $2}' | cut -d 0 -f 2 )
	n=${1}/c.tdd.${n}
	mk_rnd_fil ${n} ${3}
	gnis ${ext} ${n} ${3}

	#tässä kohtaa jokin pykii?
	n=${1}/b.cdef.7865956987698
	mk_rnd_fil ${n} ${3}
	gnis ${ext} ${n} ${3}
	mv ${n}.${ext} ${n}.${ext}.tmp
	${checksig_base} -u loki -sb ${n}
	mv ${n}.${ext} ${n}.${ext}.12
	mv ${n}.${ext}.tmp ${n}.${ext}

	if [ ${debug} -eq 1 ] ; then 
		ls -las ${1}
	fi
}
