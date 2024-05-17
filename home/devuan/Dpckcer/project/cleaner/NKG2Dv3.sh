#!/bin/sh

export PGPASSFILE=${HOME}/.pgpass 
tmpfile=$(mktemp)
sleep 1;touch ${tmpfile}
debug=0

parse_opts() {
	case ${1} in
		-v)
			debug=1
		;; 
	esac
}

parse_opts ${1}
parse_opts ${2}
parse_opts ${3}

. ~/lib.sh

#TODO:sääntöihin että 4. kenttä oltava ${ext} tai ei mittään
v4() {
	[ $debug -eq 1 ] && echo "processing ${1}"

	local g
	local h

	#tr-mankelointi näihinkin?
	g=$(echo ${1} | cut -d '.' -f 1,2,3)
	h=$(echo ${g} | cut -d '.' -f 1)

	case ${h} in
		a|b|c)
			[ $debug -eq 1 ] && echo "prefix ok"
		;;
		*)
			delrow ${2}/${g} ${2}/${1}
		;;
	esac

	if [ -d ${2}/${g} ] ; then 
		[ $debug -eq 1 ] && echo "dri"
	else
		if [ -s $2/${g} ] ; then 
			[ $debug -eq 1 ] && echo "source OK"
		else
			delrow ${2}/${g} ${2}/${f}
		fi
	fi

	echo
}

v3_inner() {
	local s
	s=1

	if [ -f ${1} ] ; then 
		if [ -s ${2} ] ; then 
			[ $debug -eq 1 ] && echo "${checksig_cmd} ${2} ${1}"
			${checksig_cmd} ${2} ${1}
			[ $? -eq 0 ] && s=0
		fi
	fi

	if [ ${s} -eq 0 ] ; then 
		[ $debug -eq 1 ] && echo ${f}
	else
		delrow ${2} ${1} #${1}/${f} ${1}/${e} 
	fi
}

v3() {
	[ $debug -eq 1 ] && echo "v3 $1 $2 $3"
	local e	
	local f	
	local s

	[ $debug -eq 1 ] && echo "part0"

	for f in $(ls ${1}) ; do
		v4 ${f} ${1}
	done

	[ $debug -eq 1 ] && echo "part1"

	for f in $(ls ${1}/*.${3}.* | sort) ; do
		[ $debug -eq 1 ] && echo "b3f0r3 v4  ${f} ${1}"
		e=$(echo ${f} | cut -d '.' -f 1,2,3)
		v3_inner ${e} ${f}
		[ $debug -eq 1 ] && echo "------------------------------------------"
	done

	[ $debug -eq 1 ] && echo "aprt2"

	for f in $(ls ${1}/*.${3} | grep -v '.${3}.') ; do
		[ $debug -eq 1 ] && echo "b3f0r3 v4  ${f} ${1}"
		e=$(echo ${f} | cut -d '.' -f 1,2,3)

		if [ -s ${e} ] ; then 
			[ $debug -eq 1 ] && echo "${e} ok"
		else
			delrow ${f} ${e}
		fi

		[ $debug -eq 1 ] && echo "------------------------------------------"
	done

	[ $debug -eq 1 ] && echo "part3"
	local t
	local u
	local v
	t=1
	
	#mitenköhän sitten esmes a.SIGfried.cc tai b.xxx.SIGmund ?
	for f in $(ls ${1} | grep -v ${3} ) ; do
		[ $debug -eq 1 ] && echo "b3f0r3 v4 ${f} ${1}"
		u=${1}/${f}.${3}
		v=${1}/${f}
		[ ${debug} -eq 1 ] && echo "${checksig_cmd} ${u} ${v}"
		${checksig_cmd} ${u} ${v}
		
		if [ $? -eq 0 ] ; then 
			if [ ${t} -eq 1 ] ; then
				t=0
				firstrow ${1} ${2} t
			else
				add_sep ${1} ${2}
			fi
				
			addwor3 ${f} ${2} ${1}	
		else
			delrow ${u} ${v}
		fi

		[ $debug -eq 1 ] && echo "------------------------------------------"
	done
	
	[ ${t} -eq 0 ] && finalrow ${1} ${2}
	[ $debug -eq 1 ] && echo "d0n3"
}

if [ $# -gt 1 ] ; then
	dirs="${1} ${2}"
else
	dirs="/data/temp /data/perm"
fi

tf=$(mktemp)

for d in ${dirs} ; do
	v3 ${d} ${tf} ${ext}
done

${dbcmd_base} -c "CALL del_tmpf_rows();" 
sleep 5
${dbcmd_base} -f ${tf}

if [ $debug -eq 1 ] ; then
	echo "cat ${tf}"
else
	rm ${tf}
fi

for row in $(${dbcmd_base} -c 'SELECT get_tmpf_rows();' | grep /data ) ; do
	[ $debug -eq 1 ] && echo "part3 ${row}"
	col1=$(echo ${row} | cut -d ',' -f 1)	
	col1=$(echo ${col1} | cut -d '|' -f 1 | tr -d -c a-zA-Z0-9./ )

	col2=$(echo ${row} | cut -d ',' -f 2)
	col2=$(echo ${col2} | cut -d '|' -f 1 | tr -d -c a-zA-Z0-9./ )	

	[ $debug -eq 1 ] && echo "col1=${col1} "

	if [ -f ${col2}/${col1} ] ; then 
		[ $debug -eq 1 ] && echo "rm ${col2}/${col1}"
		rm ${col2}/${col1}
		rm ${col2}/${col1}.${ext}
	fi
done
#part4
