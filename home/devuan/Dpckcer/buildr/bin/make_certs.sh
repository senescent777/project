#!/bin/sh
. ~/bin/dirs.conf
set -e
debug=0
#alpinessa ei ole bash vakiovaruste ni toivottavasti sh kelpaa

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

if [ ${debug} -eq 1 ] ; then 
	pwd;sleep 5
fi

#TODO:asennusskripteihin se ~/lib.sh - jutskab huomiointi
#TODO:ca-jutut jatkossa nimeltään loki? tai loki-gpg-avaimella allekirj
#TODO:se ~/lib.sh käyttöön jatkossa
#TODO:jotain pitäisi keksiä sen odin-thor-loki-jutun suhteen tähän

make_ca() {
    [ $debug -eq 1 ] && echo "make_ca($1,$1,$3)"
	openssl3 req -nodes -x509 -new -days 1826 -keyout ${1}/priv/ca.key -out ${1}/pub/ca.crt
	[ $? -eq 0 ] || echo "P.V.HH"
	sleep 5
	/bin/sync /
	/bin/sync /home
	/bin/sync /tmp
}

make_int() {
	[ $debug -eq 1 ] && echo "make_int($1,$2,$3)";sleep 1
    openssl3 req  -new -nodes \
        -keyout ${1}/priv/ca_int.key -out ${1}/pub/ca_int.csr
	[ $? -eq 0 ] || echo "P.V.HH"
	sleep 5
	/bin/sync /
	/bin/sync /home
	/bin/sync /tmp
	
    openssl3 req -in ${1}/pub/ca_int.csr -noout -verify
    [ $? -eq 0 ] || echo "P.V.HH"
	sleep 5
	/bin/sync /
	/bin/sync /home
	/bin/sync /tmp
	
    openssl3 x509 -req -CA ${1}/pub/ca.crt -CAkey ${1}/priv/ca.key -CAcreateserial -in ${1}/pub/ca_int.csr -out ${1}/pub/ca_int.crt -days 365 
	[ $? -eq 0 ] || echo "P.V.HH"
    [ $debug -eq 1 ] && echo "Creating CA chain";sleep 1
    cat ${1}/pub/ca_int.crt ${1}/pub/ca.crt > ${1}/pub/ca.pem
    
    [ $debug -eq 1 ] && echo "t3st ca.o3m";sleep 1
    [ $debug -eq 1 ] && sleep 5
    [ $debug -eq 1 ] && openssl3 x509 -in ${1}/pub/ca.pem -noout -text
    
	sleep 5
	/bin/sync /
	/bin/sync /home
	/bin/sync /tmp
}

generic_make_key() {
	[ $debug -eq 1 ] && echo "mking gneric crt nd ky $1 $2 $3";sleep 1
	[ -d ${1} ] || mkdir -p ${1}

	if [ -s ${1}/${3}.crt ] ; then 
		[ $debug -eq 1 ] && echo "as1a kun0sa";sleep 1
	else
		#sha1, outform ja keyfrm uusina 16+124, pois jos pykii
		openssl3 req  -nodes  -new  -keyout ${1}/${3}.key -out ${1}/${3}.csr -outform PEM -keyform PEM -sha1
		[ $? -eq 0 ] || echo "P.V.HH"
		sleep 3
		openssl3 x509 -in ${1}/${3}.csr -out ${1}/${3}.crt -outform PEM -keyform PEM -sha1 -req -CA ${2}/pub/ca_int.crt -CAkey ${2}/priv/ca_int.key -CAcreateserial		
	fi
}

#HUOM. oleeellisimpien avainten kanssa chattr +ui
base=${HOME}/tmp
keysdir=${HOME}/keys

if [ -d ${keysdir} ] ; then 
	[ -w ${keysdir}/priv ] || exit
	[ -w ${keysdir}/priv ] || exit #uutena
	[ -s ${keysdir}/pub/ca.crt ] || make_ca ${keysdir}
	[ -s ${keysdir}/pub/ca_int.crt ] || make_int ${keysdir} 
else
	[ $debug -eq 1 ] && echo "P.V.H.H"
	exit
fi

[ $debug -eq 1 ] && echo ${THIS_WEBKEY_DIRS}
[ $debug -eq 1 ] && echo "b4f0r3";sleep 1

for dir in ${THIS_WEBKEY_DIRS} ; do
	generic_make_key ${base}/${dir} ${keysdir} webkey
done

[ $debug -eq 1 ] && echo "4ft3r";sleep 1
	
for dir in ${THIS_DBKEY_USRS} ; do
	generic_make_key ${base}/${dir} ${keysdir} dbkey
done

[ $debug -eq 1 ] && echo "f1nally";sleep 1




