#!/bin/sh

debug=0
#no nyt selvisi mistä se doesnotexist tuli
target=/doesnotexist
arch=tm.tar
arch2=tm2.tar

parse_opts() {
	case ${1} in
		-v)
			debug=1
		;; 
	esac
}

parse_opts ${2}
parse_opts ${3}

process_entry() {
	[ $debug -eq 1 ] && echo "process_entry($1 , $2, $3)"

	if [ -s ${1}/${2} ] ; then 
		[ ${debug} -eq 1 ] && echo "mv ${1}/${2} ${1}/${2}.OLD"
		mv -f ${1}/${2} ${1}/${2}.OLD
	fi
}

process_entries() {
	[ ${debug} -eq 1 ] && echo "process_entries(${1})"
	for f in $(tar -tf ${arch}) ; do  process_entry ${1} ${f} ; done
}

#b0rgq() {
#	local d
#	
#	d=$(echo $1 | cut -d '/' -f 2)
#	docker secret rm ${2}_${d}
#}
#
#sevenof9() {
#	local c
#	for c in $(find . -name '*.connstr') ; do b0rgq $c connstr ; done 
#	[ $debug -eq 1 ] && echo "SEP"
#	for c in $(find . -name '*.pgpass*') ; do b0rgq $c pgpass ; done
#	
#} 

case ${1} in
	1)
		tar -cvpf ${arch} .	
	;;
	4)
		[ -d ${2} ] || exit
		tar -C ${2} -xvpf ${arch}
	;;
	7)
		[ -d ${2} ] || exit
		
		process_entries ${2}
		#pitäisiköhän olla p mukana optioissa? let's find out
		tar -C ${2} -xvpf ${arch}
		tar -C ${2} -xvpf ${arch2}
		
		echo "cd $2"
	;;
	8)
		cd
		[ $debug -eq 1 ] && echo "ft8()";pwd
		
		[ -f kalat2 ] && rm kalat2
		[ $debug -eq 1 ] && sleep 5
		touch kalat2
		[ $debug -eq 1 ] && sleep 5
		
		find ./keys -type f -name '*.csr' >> kalat2
		find ./keys -type f -name '*.crt' >> kalat2 
		find ./keys -type f -name '*.pub' >> kalat2 
		tar -cvpf ~/tmp/${arch2} -T kalat2
	;;
	*)
		echo "PVHH"
		exit 666
	;;
esac
