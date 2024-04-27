#!/bin/sh
. ~/bin/dirs.conf
debug=0

parse_opts() {
	case ${1} in
		-v)
			debug=1
		;; 
	esac
}

parse_opts ${1}

if [ ${debug} -eq 1 ] ; then 
	pwd;sleep 5
fi

base=${HOME}/tmp
keysdir=${HOME}/keys

make_x509() {
	[ $debug -eq 1 ] && echo "mking gneric_x509 ky $1 $2 $3";sleep 1

	if [ -s ${1}/pub/${2}.crt ] ; then 
		[ ${debug} -eq 1 ] && echo "as1a kun0sa"
	else
		openssl3 req -x509 -nodes -newkey rsa:512 -keyout ${1}/priv/${2}.key -out ${1}/pub/${2}.crt -subj '/CN=test' -days 10
		
		sleep 5
		#sleep saattaa olla oleellinen virheilmojen estämiseksi
		
		openssl3 x509 -pubkey -noout -in ${1}/pub/${2}.crt > ${1}/pub/${2}.pub
		
		openssl3 req -key ${1}/priv/${2}.key -new -out ${1}/pub/${2}.tmp
		openssl3 x509 -req -CA ${1}/pub/ca_int.crt -CAkey ${1}/priv/ca_int.key -CAcreateserial -in ${1}/pub/${2}.tmp -out  ${1}/pub/${2}.crt2
	fi
}

. ${base}/.env
[ -w ${keysdir}/priv ] || exit
[ -w ${keysdir}/pub ] || exit

make_x509 ${keysdir} ${RSKEY}
cp ${keysdir}/priv/${RSKEY}.key ${base}/local_rw
[ $? -eq 0 ] || echo "vopying of ${RSKEY} failed"
sleep 2

[ $debug -eq 1 ] && echo "calculating RSVALUEsz...";sleep 2
echo ${RSV0} | openssl3 dgst -sha256 -sign ${base}/local_rw/${RSKEY}.key | base64
echo ${MDPV0} | openssl3 dgst -sha256 -sign ${base}/local_rw/${RSKEY}.key | base64
[ $debug -eq 1 ] && echo "... done";sleep 4

make_x509 ${keysdir} ${RSKEY2}
cp ${keysdir}/priv/${RSKEY2}.key ${base}/ro1
[ $? -eq 0 ] || echo "vopying of ${RSKEY2} failed"
sleep 2 

#indexille ja ro:lle yhteinen ... joskohan ro...
make_x509 ${keysdir} ${RSKEY3}
cp ${keysdir}/priv/${RSKEY3}.key ${base}/ro1
[ $? -eq 0 ] || echo "vopying of ${RSKEY23} failed"
sleep 5

#openssl3 req -x509 -nodes -newkey rsa -keyout 
#openssl3 req -key tmp/rsa0 -new -out tmp/rsa2
#openssl3 x509 -req -CA keys/pub/ca_int.crt -CAkey keys/priv/ca_int.key -CAcreateserial -in tmp/rsa2 -out tmp/rsa3

