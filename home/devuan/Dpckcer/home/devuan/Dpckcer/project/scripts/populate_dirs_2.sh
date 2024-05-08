#!/bin/sh
#[ $# -gt 0 ] || echo "$0 -h"
#dir=nonexistent
#
#debug=0
#bobby=0
#p=0
#dir=nonexistent
#dir2=./permanent1
#. ~/lib.sh
#
##HUOM. voinee kokeilla miten pop_dirs toimisi konrin sisällä
##HUOM.2. sitten oli sitä kannan testailuakin ennen varsinaista konttien rakennusta, että jos semmoisen
#
#parse_opts() {
#	case ${1} in
#		-v)
#			debug=1 #nyt vain se ls lopussa
#		;; 
#		--bobby)
#			bobby=1
#		;;
#		-h|--h)
#			echo "$0 dir1 [--bobby] [-v]"
#			exit
#		;;
#		*)
#			dir=${1}
#			p=1
#		;;
#	esac
#}
#
#parse_opts ${1}
#parse_opts ${2}
#parse_opts ${3}
#parse_opts ${4}
#
#mk_rnd_fil() {
#	local amt
#	amt=$(dd if=/dev/urandom bs=2 count=1 | hexdump -d | awk '{print $2}' | tr -d 0)
#	
#	[ ${debug} -eq 1 ] && echo "dd if=/dev/urandom bs=${amt} count=1 | base64 - > ${1}"
#	dd if=/dev/urandom bs=${amt} count=1 | base64 - > ${1}
#	
#	if [ $? -gt 0 ] ; then
#		[ ${debug} -eq 1 ] && echo "sudo /opt/bin/xxx.sh"
#	fi
#}
#
#main() {
#	#tarkoituksella täsmää metadataam(pystyisi kai toisellakin tavalla tekemään täsmäyksen)
#	mk_rnd_fil ${dir}/placeholder
#	gnis ${ext} ${1}/placeholder
#	
#	#bobby tables-rivi tr-jekun testausta varten
#	if [ ${bobby} -eq 1 ] ; then
#		mk_rnd_fil ${dir}/'bobby_tables;DROP'
#		gnis ${ext} ${dir}/'bobby_tables;DROP'
#	fi
#
#	#tarkoituksella ei mene läpi (eo allekirj)
#	mk_rnd_fil ${dir}/a.bc.def
#
#	#m,enee lkäpoi
#	mk_rnd_fil ${dir}/a.bc.def2
#	gnis ${ext} ${dir}/a.bc.def2
#	
#	#tarkoituksella ei mene läpi (tauhklaa allekijr jälkeen)
#	n=$(mktemp -p ${dir})
#
#	if [ $? -gt 0 ] ; then
#		[ ${debug} -eq 1 ] && echo "sudo /opt/bin/xxx.sh"
#	fi
#		
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n} #0
#	dd if=/dev/urandom bs=12 count=1 >> ${n}
#
#	n=$(mktemp -p ${dir})
#	mk_rnd_fil ${n}
#	n=$(mktemp -p ${dir})
#	mk_rnd_fil ${n}
#
#	[ -f ${dir2}/index.html ] || cp bak/index.html ${dir2}/
#	gnis ${ext} ${dir2}/index.html
#	[ $? -eq 0 ] || echo "sudo /opt/bin/xxx.sh"
#	gnis ${ext} ${n}
#
#	n=$(dd if=/dev/urandom bs=4 count=1 | hexdump  | awk '{print $2}' | cut -d 0 -f 2 )
#	n=${dir}/a.bb.${n}
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n}
#
#	n=$(dd if=/dev/urandom bs=4 count=1 | hexdump  | awk '{print $2}' | cut -d 0 -f 2 )
#	n=${dir}/c.tdd.${n}
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n}
#
#	#tässä kohtaa jokin pykii?
#	n=${dir}/b.cdef.7865956987698
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n}
#	mv ${n}.${ext} ${n}.${ext}.tmp
#	${checksig_base} -u loki -sb ${n}
#	mv ${n}.${ext} ${n}.${ext}.12
#	mv ${n}.${ext}.tmp ${n}.${ext}
#
#	if [ ${debug} -eq 1 ] ; then 
#		ls -las ${dir}
#		ls -las ${dir2}
#	fi
#	
#	mk_rnd_fil ${dir}/a.un-jong.4ktdemo
#	gnis ${ext} ${dir}/a.un-jong.4ktdemo
#}
#
#if [ ${p} -eq 1 ] ; then
#        [ -d ./${dir}  ] || mkdir -p ./${dir}
#        #HUOM. tls-possu==nykyään opnäytteen ulkopuolinen juttu
#        [ ${debug} -eq 1 ] && echo "mdk"
#
#fi
#
