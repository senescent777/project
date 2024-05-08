#!/bin/sh
#
#if [ $#  -eq 0 ] ;  then
#	echo "$0 -h"
#	exit
#fi
#
#debug=0
#bobby=0
#dir=./temporary1
#dir2=./permanent1
#. ~/lib.sh
#
#parse_opts() {
#	case ${1} in 
#		-v)
#			debug=1
#		;;
#		-h)
#			echo "$0 dir [--bobby] [-v]"
#			exit
#		;;
#		--bobby)
#			bobby=1
#		;;
#		*)
#			dir=${1}
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
#	[ ${debug} -eq 1 ] && echo "main($1, $2, $3)";sleep 5
#	local n
#	
#	#tarkoituksella täsmää metadataan(pystyisi kai toisellakin tavalla tekemään täsmäyksen)
#	mk_rnd_fil ${1}/placeholder
#	gnis ${ext} ${1}/placeholder
#	
#	#bobby tables-rivi tr-jekun testausta varten
#	if [ ${3} -eq 1 ] ; then
#		mk_rnd_fil ${1}/'bobby_tables;DROP'
#		gnis ${ext} ${1}/'bobby_tables;DROP'
#	fi
#
#	#tarkoituksella ei mene läpi (eo allekirj)
#	mk_rnd_fil ${1}/a.bc.def
#
#	#m,enee lkäpoi
#	mk_rnd_fil ${1}/a.bc.def2
#	gnis ${ext} ${1}/a.bc.def2
#	
#	#tarkoituksella ei mene läpi (tauhklaa allekijr jälkeen)
#	n=$(mktemp -p ${1})
#
#	if [ $? -gt 0 ] ; then
#		[ ${debug} -eq 1 ] && echo "sudo /opt/bin/xxx.sh"
#	fi
#		
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n} #0
#	dd if=/dev/urandom bs=12 count=1 >> ${n}
#
#	n=$(mktemp -p ${1})
#	mk_rnd_fil ${n}
#	n=$(mktemp -p ${1})
#	mk_rnd_fil ${n}
#
#	[ -f ${2}/index.html ] || cp ./bak/index.html ${2}/
#	gnis ${ext} ${2}/index.html
#	[ $? -eq 0 ] || echo "sudo /opt/bin/xxx.sh"
#	gnis ${ext} ${n}
#
#	n=$(dd if=/dev/urandom bs=4 count=1 | hexdump  | awk '{print $2}' | cut -d 0 -f 2 )
#	n=${1}/a.bb.${n}
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n}
#
#	n=$(dd if=/dev/urandom bs=4 count=1 | hexdump  | awk '{print $2}' | cut -d 0 -f 2 )
#	n=${1}/c.tdd.${n}
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n}
#
#	#tässä kohtaa jokin pykii?
#	n=${1}/b.cdef.7865956987698
#	mk_rnd_fil ${n}
#	gnis ${ext} ${n}
#	mv ${n}.${ext} ${n}.${ext}.tmp
#	${checksig_base} -u loki -sb ${n}
#	mv ${n}.${ext} ${n}.${ext}.12
#	mv ${n}.${ext}.tmp ${n}.${ext}
#
#	if [ ${debug} -eq 1 ] ; then 
#		ls -las ${1}
#		ls -las ${2}
#	fi
#}
#
##TODO:listaolio mihin kasataan dir ja dir2 jonka jälkeen for d in list
#if [ $# -gt 1 ] ; then
#	main ${dir} ${dir2} ${bobby}
#fi
#
