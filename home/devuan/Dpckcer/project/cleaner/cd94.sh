#!/bin/sh
. ~/lib.sh

export PGPASSFILE=$HOME/.pgpass 
debug=0

#HUOM:TARPEELLISIin kohdin huomiointi että samaa sisältöä kohti useampi acl-rivi, jops samalla roleid:llä
#HUOM:shasum -c vastaava toiminto myöhemmin

parse_opts() {
	case ${1} in
		-v)
			debug=1 #nyt vain se ls lopussa
		;; 
		
	esac
}

parse_opts ${1}

#part1()
[ $debug -eq 1 ] && echo "pre"
[ $debug -eq 0 ] && ${dbcmd_base} -c "CALL del_acl_rows();" #takaisin sittenq cond_del_a käyttävä looppi alla toimii
[ $debug -eq 1 ] && echo "after"

sleep 5
tf=$(mktemp) #tarpeellinen nykyään? entä 2 seur?
j=""
k=""

#HUOM.091023:nykyään pitäisi olla: acl=(id, name, rsk, rsv, exp, ...)
#alla siis openssl-versio... pitäsi palailla siihen lib.sh:n ideaan
#...että yksityiskohdat kirjastossa, cd94 tietää vain että tätä fktiota kuTSumalla tapahtuu jotain

for r in $(${dbcmd_base} -c 'SELECT get_acl_rows();'  | grep /data) ; do
	rsid=$(echo ${r} | cut -d ',' -f 1 | tr -d -c 0-9)
	rsk=$(echo ${r} | cut -d ',' -f 3 | tr -d -c a-zA-Z0-9)
	rsve=$(echo ${r} | cut -d ',' -f 4 | tr -d -c a-zA-Z0-9)
	rsexp=$(echo ${r} | cut -d ',' -f 5 | tr -d -c a-zA-Z0-9)

	#rsv=$(echo ${rsve} | openssl pkeyutl -decrypt -pubin ${HOME}/keys/${rsk} )
	sign_row ossl ${rsexp} ${rsk}
done

[ $debug -eq 1 ] && echo "l00p2 d0n3"
[ $debug -eq 0 ] && rm ${tf} #debig pois sittenq muuten toimii
