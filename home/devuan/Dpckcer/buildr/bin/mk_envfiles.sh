#!/bin/sh
. ~/bin/dirs.conf
. ~/bin/jmke.conf
debug=0
nu=0
indxip2=${INDXIP}

parse_opts() {
	case ${1} in
		-v|--v)
			debug=1
		;; 
		-nu|--nu)
			nu=1
		;;
	esac
}

parse_opts ${2}
parse_opts ${3}
parse_opts ${4}

if [ ${debug} -eq 1 ] ; then 
	pwd;sleep 3
fi

dbname=$(dd if=/dev/urandom bs=3 count=1 | hexdump | awk '{print $2}')
dbname=d${dbname}
[ ${debug} -eq 1 ] && echo "dbname=${dbname}";sleep 3

lokal_env() {
	[ $debug -eq 1 ] && echo "lokal_enc($1, $2, $3, $4, $5, $6, $7)"

	local s2
	local t	
	local u
	
	t=${HOME}/tmp/${1}
	[ -f ${t} ] && rm -f ${t} 

	[ $debug -eq 1 ] && sleep 1
	touch ${t}
	[ $debug -eq 1 ] && sleep 1
		
	echo "PGDATABASE=${3}" > ${t}
	grep PG ~/bin/jmke.conf | grep -v '#' >> ${t}
	
	#HUOM.190124:dbname nykyään $3
	if [ x${RSKEY} == x ] ; then 
		[ ${debug} -eq 1 ] && echo "makinh new row_sogn_key"
		td=$(date -I)
		pre_rsk=$(echo "${td};${3};${td}" | sha256sum | awk '{print $1}' | cut -b 1-30)
		#oli aiemmin PGHOST tässä, parempi jos INDXP koska sockets
		dap=$(echo "${pre_rsk};${INDXP};${td};${PGPORT};${pre_rsk}" | sha256sum | awk '{print $1}' | cut -b 1-30)
		#rskey oli aiemmin 60 mrk, nyt typistetty vähän (190124)
		rsk=$(echo "${pre_rsk};/home/cleaner/keys/rskey.key;${dap}" | sha256sum | awk '{print $1}' | cut -b 1-30)
		[ ${debug} -eq 1 ] && echo "rsk=${rsk}";sleep 3
	
		echo "RSKEY=${rsk}" >> ${t}
		rsk2=$(echo "${rsk};rskey2;{dap}" | sha256sum | awk '{print $1}' | cut -b 1-30)
		echo "RSKEY2=${rsk2}" >> ${t}
		
		rsk3=$(echo "${pre_rsk};RSKEY3;${rsk2}" | sha256sum | awk '{print $1}' | cut -b 1-30)
		echo "RSKEY3=${rsk3}" >> ${t}
	else
		[ ${debug} -eq 1 ] && echo "R5K3YZ ALR3ADY 3XI5TZ";sleep 5 
		grep RS ~/bin/jmke.conf | grep -v '#' >> ${t}
	fi
	
	#HUOM. olisi hyväksi sekä alpine-puolella ett postgresin kanssa sellainen base64-variantti missä ei ainakaan "/" juhli
	grep ACL ~/bin/jmke.conf | grep -v '#' >> ${t}
	grep MD  ~/bin/jmke.conf | grep -v '#' >> ${t}
	
	#... tarkemmin ajatellen voisi composelle välittää vain sen /24-verkon, jos mahd
	grep INDX ~/bin/jmke.conf | grep -v '#' >> ${t}

	pq=$(echo $PGHOST | tr -d -c 0-9.)
	echo "PQIP=${pq}" >> ${t}
	
	grep RW_ ~/bin/jmke.conf | grep -v '#' >> ${t}
	[ $debug -eq 1 ] && cat ${t}
	u=$HOME/tmp/${2}/${1}
	echo "POSTGRES_DB=${3}" >> ${u}
	grep PGPORT ~/bin/jmke.conf | grep -v '#' >> ${u}
	[ $debug -eq 1 ] && cat ${u};sleep 6
}

#$2 **EI** pois parametreista
#TODO:vissiin pitäiai kuljetella juttuja vai ptääkö? mitä juttuja?
bakcend_env() {
	[ $debug -eq 1 ] && echo "back3nd_nv($1, $2)"
	local v
	local w
	local prefix11
	local pq
	
	[ -f  ${1}/.pgpass ] && rm -f ${1}/.pgpass
	[ $debug -eq 1 ] && sleep 1
	touch ${1}/.pgpass
	[ $debug -eq 1 ] && sleep 1

	v=$(dd if=/dev/urandom bs=6 count=1 | sha256sum | cut -b 2-10)
	prefix11=$(echo ${prefix1} | tr -d -c a-zA-Z0-9)
	echo "${prefix11}${v}" > ${1}/.pgpass
	chmod 0400  ${1}/.pgpass
	[ $debug -eq 1 ] && sleep 1

	#HUOM190124:tässä pari juttua tilapäisesti jemmassa, ehkä takaisin josqs
	v=$(dd if=/dev/urandom bs=3 count=1 | sha256sum | cut -b 1-5)
	#echo "s${v}" >>  ${1}/.pgU
	echo "POSTGRES_USER=s${v}" >> ${1}/${2}
	#	echo "POSTGRES_USER_FILE=/run/secrets/${w}_env2" >> ${1}/${2}
	
	grep POSTGRES_AUTH_METHOD ~/bin/jmke.conf | grep -v '#' >>  ${1}/${2}
	w=$(echo ${1} | cut -d '/' -f 5 | tr -d -c a-zA-Z0-9)
	echo "POSTGRES_PASSWORD_FILE=/run/secrets/${w}_env" >> ${1}/${2}

	[ $debug -eq 1 ] && cat ${1}/${2}
}

#HUOM. käytetäänkö 2. parametria mihinkään? no käytetään
other_env_2() {
	local g
	local h
	local y
	local z
	local w
	local prefix21
	
	[ $debug -eq 1 ] && echo "0ther_3nv_2($1 $2 $3 $4 $5)"
	y=$(echo ${1} | tr -d -c a-zA-Z0-9_)
	h=${HOME}/tmp/${y}
	g=${h}/.env

	#sulkeiden päättämisen kanssa tarkkana sitten!!!
	
	[ -f ${g} ] && rm -f ${g} 
	[ $debug -eq 1 ] && sleep 1
	touch ${g}
	[ $debug -eq 1 ] && sleep 1
	
	#HUOM.LIENEE TÄRKEÄTÄ ETTÄ ">>" EIKÄ ">"
	w=$(echo ${2} | tr -d -c a-zA-Z0-9)
	echo "PGDATABASE=${w}" >> ${g}
	
	y=$(echo ${PGPORT} | tr -d -c 0-9)
	echo "PGPORT=${y}" >> ${g}
	
	y=$(echo ${PGHOST} | tr -d -c 0-9a-z.)
	echo "PGHOST=${y}" >> ${g}
	
	#TODO:1. se export-juttu ghubista
	y=$(echo ${1} | tr -d -c a-zA-Z0-9_)
	echo "FLASK_APP=/app/${y}.py" >> ${g}

	#TODO:PGHOST mukaan .pgpassiin? (2 ekaa olisi hostname ja port mutta sockets...)
	if [ ${3} -gt 0 ] ; then
		echo "*:*:${w}:${y}:q_${y}" > ${h}/.pgpass
		echo "PGUSER=${y}" >> ${g}
	else
		y=$(dd if=/dev/urandom bs=2 count=1 | hexdump | awk '{print $2}')
		z=$(dd if=/dev/urandom bs=5 count=1 | base64 | tr -d -c a-zA-Z0-9)
		
		prefix21=$(echo ${prefix2} | tr -d -c a-zA-Z0-9)
		echo "*:*:${w}:u${y}:q${prefix21}${z}" > ${h}/.pgpass
		
		echo "PGUSER=u${y}" >> ${g}
	fi
	
	chmod 0400 ${h}/.pgpass
}

other_env_1() {
	[ ${debug} -eq 1 ] && echo "0ther_3nw1($1, $2, $3, $4, $5, $6)"
	local x

	for x in ${THIS_TARGETS} ; do
		other_env_2 ${x} ${1} ${2}
	done
}

lokal_env .env ${1} ${dbname} ${indxip2} 
bakcend_env ${HOME}/tmp/${1} .env
other_env_1 ${dbname} ${nu} 
