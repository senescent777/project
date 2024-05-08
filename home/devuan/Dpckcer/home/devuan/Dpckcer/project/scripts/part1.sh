#tämän tiedoston funktio?
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
#}
