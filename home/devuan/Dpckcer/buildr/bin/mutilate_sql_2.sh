#!/bin/sh
. ~/bin/dirs.conf
debug=0
nu=0

parse_opts() {
	case ${1} in
		-v)
			debug=1
		;; 
		-nu)
			nu=1
		;;
	esac
}

parse_opts ${1}
parse_opts ${2}

if [ ${debug} -eq 1 ] ; then 
	pwd;sleep 5
fi

src=${HOME}/source
dst=${HOME}/tmp

rm -f ${dst}/stg1
[ $debug -eq 1 ] && sleep 1
touch ${dst}/stg1
[ $debug -eq 1 ] && sleep 1

#ao. jutut(2xmkdir) pitäisi kai mkdrs'in hoitaa
[ -d ${dst}/sql/1 ] || mkdir ${dst}/sql/1
[ -d ${dst}/sql/2 ] || mkdir ${dst}/sql/2

pre() {
	[ $debug -eq 1 ] && echo "pre()"
	[ -f ${3}/${1} ] && rm -f ${3}/${1} 
	[ $debug -eq 1 ] && echo "grep -v '#' ${2}/${1}.0 > ${3}/${1}.tmp"
	[ -s ${2}/${1}.0 ] && grep -v '#' ${2}/${1}.0 > ${3}/${1}.tmp
}

#TODO:"se l_rw käyttämään (psql over) tls:ää"-idea?
#TODO:buildr, possutest ja be -> secrets kautta pg ja my (jos ei olejo)
#TODO:buildr ja possutest -> näiden kautta ainoastaan init.sql , sekin secrets kautta

pre init-user-db.sql ${src} ${dst}/sql/1
pre pg_hba.conf ${src} ${dst}/sql/2
pre my.post.conf ${src} ${dst}/sql/2
f=${dst}/stg1

#TEHTY?:kenties jotenkin mahdollistettava sellainnt mutilointi mikä ei muuta login-pass-juttuja? pikemminkin mk_envfiles juttuja?
mangle_usrs() {
	local d
	local v
	local u
	local v0
	local d0

	[ $debug -eq 1 ] && echo "urs.maj $1 $2 $3 $4"
	#HUOM. ao listan kanssa jrjestys oleellista

	for d0 in ${THIS_DBKEY_CLIENTS}; do 
		[ $debug -eq 1 ] && echo "dez ${d0}"
		d=$(echo ${d0} | tr -d -c a-zA-Z0-9_)
		v0=$(cat ${HOME}/tmp/${d}/.pgpass | grep -v '#' | cut -d ':' -f 5)

		v=$(echo ${v0} | tr -d /) 
		#HUOM. hipsukin pitäisi varmaan hukata...mut miten?

		[ $debug -eq 1 ] && echo "@ ${d} dv=${v}"
		echo "sed -i 's/q_${d}/${v}/g' ${1}/1/init-user-db.sql.tmp" >> ${2}

		u=$(cat ${HOME}/tmp/${d}/.env | grep -v '#' | grep PGUSER)
		u=$(echo ${u} | cut -d '=' -f 2 | tr -d -c a-zA-Z0-9)

		echo "sed -i 's/${d}/${u}/g' ${1}/1/init-user-db.sql.tmp" >> ${2}
		echo "sed -i 's/${d}/${u}/g' ${1}/2/pg_hba.conf.tmp" >> ${2}
	done

	#uusi rivi lisätty 161123
	v=$(dd if=/dev/urandom bs=3 count=1 | hexdump | awk '{print $2}')
	echo "sed -i 's/tor2/${v}/g' ${1}/1/init-user-db.sql.tmp" >> ${2}
}

#jokin komentorivioptio millä m_u skipataan?
[ ${nu} -eq 0 ] && mangle_usrs ${dst}/sql ${f}
[ ${debug} -eq 1 ] && echo ". ${dst}/.env";sleep 10
. ${dst}/.env
[ ${debug} -eq 1 ] && echo "INDXIP0=${INDXIP0}";sleep 5

mangle_db() {
	[ ${debug} -eq 1 ] && echo "mangle_db( ${1} ${2} ${3} ${4} )"

	local e2
	#fktion  ulkopuolella vaikuttaa f ni nimetty uudelleen
	local f2
	local g2
	local h2
	local p2

	#HUOM. "/" täytyy olla mukana p:ssa!!!!
	p1=$(echo ${1} | tr -d -c a-zA-Z0-9/)
	p2=${p1}/sql/1
	p3=${p1}/sql/2

	#pitäisiköhän tuo kovolangoitettu be saada pois?
	. ${1}/backend/.env
	[ ${debug} -eq 1 ] && echo "ugp"
	#h2=$(cat ${1}/backend/.pgU | tr -d -c a-zA-Z0-9)
	h2=$(echo ${POSTGRES_USER} | tr -d -c a-zA-Z0-9)
	f2=$(echo ${PGDATABASE} | tr -d -c a-zA-Z0-9)

	[ ${debug} -eq 1 ] && echo "initsql"
	e2="init-user-db.sql"
	echo "sed -i 's/d5ddd/${f2}/g' ${p2}/${e2}.tmp" >> ${2}
	echo "sed -i 's/d8d40/${f2}/g' ${p2}/${e2}.tmp" >> ${2}
	echo "sed -i 's/d09ba/${f2}/g' ${p2}/${e2}.tmp" >> ${2}
	echo "sed -i 's/demiurg/${h2}/g' ${p2}/${e2}.tmp" >> ${2}

	[ ${debug} -eq 1 ] && echo "hba"
	e2="pg_hba.conf"
	echo "sed -i 's/d5ddd/${f2}/g' ${p3}/${e2}.tmp" >> ${2}
	echo "sed -i 's/d8d40/${f2}/g' ${p3}/${e2}.tmp" >> ${2}
	echo "sed -i 's/d09ba/${f2}/g' ${p3}/${e2}.tmp" >> ${2}
	echo "sed -i 's/demiurg/${h2}/g' ${p3}/${e2}.tmp" >> ${2}

	#HUOM.26.11.23:tartteeko my.post.conf sed-kikkailua nykyään vai ei?
}

mangle_db ${dst} ${f}

#olikohan jotain muutakin mitä pitä huomioida tulevien muutoksien varalta?
new_part() {
	local e2
	local z2
	[ $debug -eq 1 ] && echo "new_part( $1 $2 $3 $4)"

	e2=$(echo "${1}/1/init-user-db.sql" | tr -d -c a-zA-Z0-9-./)
	z2=$(dd if=/dev/urandom bs=8 count=1 | sha256sum | cut -b 1-10)
	echo "sed -i 's/cf8/${z2}/g' ${e2}.tmp" >> ${2} 
	
	#HUOM.25124:pitäisi olla heksaa ja max 64 mrk?
	z2=$(echo ${ACL_SIG1} | tr -d -c a-f0-9) #a-zA-Z0-9.- | cut -b 1-30)
	echo "sed -i 's/ACLSIG/${z2}/g' ${e2}.tmp" >> ${2}
	
	#fault vai default?
	z2=$(dd if=/dev/urandom bs=8 count=1 | sha256sum | cut -b 1-15)
	echo "sed -i 's/fault/${z2}/g' ${e2}.tmp" >> ${2}

	z2=$(date -I)
	echo "sed -i 's/2023-09-21/${z2}/g' ${e2}.tmp" >> ${2}
	
	#HUOM.180124:smallint-kenttien kanssa voi tulla valituksia tälleen
	#z2=$(dd if=/dev/urandom bs=2 count=1 | hexdump -d | awk '{print $2}' | cut -d 0 -f 2)
	z2=$(dd if=/dev/urandom bs=2 count=1 | hexdump -d | awk '{print $2}' |  cut -b -4)
	echo "sed -i 's/32767/${z2}/g' ${e2}.tmp" >> ${2}

#ao. kikkailut taitavat kusea paskaa	
#	z2=$(dd if=/dev/urandom bs=6 count=1 | base64 | tr -c -d a-zA-Z0-9)
#	echo "sed -i 's/asf/${z2}/g' ${e2}.tmp" >> ${2}
#	
#	z2=$(dd if=/dev/urandom bs=6 count=1 | base64 | tr -c -d a-zA-Z0-9)
#	echo "sed -i 's/fasd/${z2}/g' ${e2}.tmp" >> ${2}
#	
#sessiotestiin llitt. syistö kommenteissa
#	z2=$(dd if=/dev/urandom bs=2 count=1 | hexdump -d | awk '{print $2}' | cut -d 0 -f 2)
#	echo "sed -i 's/1234/${z2}/g' ${e2}.tmp" >> ${2}

	#vääränlaisten merkkien takia viimeisenä. siirretty 25.2.14
	#tr pitäisi vissiin ottaa pois kanssa
	
		#pitäisikö olla ennen default-riviä?
	#".-" lisätty 250124 parista syystä, mm- eräänlaien base64yhteensopivuus
	#HUOM. tiivisteiden ja etenkin allekirjoitusten kanssa ei oikeastaan voisi katkaista kesken
	#...tosin rskey'n tuli si olla heksaa mutta laitetaan vielä "." mukaan
	z2=$(echo ${RSKEY3} | tr -d -c a-f0-9. | cut -b 1-30)
	echo "sed -i 's/ac1defau1t/${z2}/g' ${e2}.tmp" >> ${2}

	#HUOM.230124:tässä alla saattaa jotain kusta, verkkaan:ACLSIG	
	#... tosin näihin öiittyi se mk_rsks, ne RSKEY-jutut, joten josko kokeilisi typistöö lisää tai sitten ei
	#kuuluisi kai tehdä toisin mutta nyt näin, jatkossa nimenomaan RSVALUE se mja mitä käytetään tässä
	#30 mrk typistäminen vähentäisi kai jotain kautta psql'n jurpoiluja mutta toisaalta
	z2=$(echo ${RSKEY} | tr -d -c a-f0-9. | cut -b 1-30)
	echo "sed -i 's/RSKEY/${z2}/g' ${e2}.tmp" >> ${2}
	
	##typistämisen takia saattaa mennä P.V.HH, tr saattaa myös sotkea
	#z2=$(echo ${RSVALUE} | tr -d -c a-zA-Z0-9.=) # | cut -b 1-60)
	#echo "sed -i 's/RSVALUE/${z2}/g' ${e2}.tmp" >> ${2}
	echo "sed -i 's/RSVALUE/${RSVALUE}/g' ${e2}.tmp" >> ${2}
	
	#z2=$(echo ${MDSIG} | tr -d -c a-zA-Z0-9.=) # | cut -b 1-60)
	#echo "sed -i 's/MD_SIG/${z2}/g' ${e2}.tmp" >> ${2}
	echo "sed -i 's/MDSIG/${MDSIG}/g' ${e2}.tmp" >> ${2}
	
	#HUOM. pitäisi vissiin noudatella a) RFC 3501 tai b) RFC 4648 pykälä 5 , josko sopiva symbolijoukko mm. sed:ille
}

pgpas2constr() {
	local e
	local f

	for d in ${THIS_FLASK_DIRS} ; do
		[ -s ${1}/${d}/.pgpass ] && echo " ${1}/${d}/.pgpass found"
		echo -n "postgresql+psycopg2://" >> ${1}/${d}/.connstr
		e=$(cat ${1}/${d}/.pgpass)

		f=$(echo ${e} | cut -d ':' -f 4)
		echo -n ${f} >> ${1}/${d}/.connstr
		echo -n ":" >> ${1}/${d}/.connstr

		f=$(echo ${e} | cut -d ':' -f 5)
		echo -n ${f} >> ${1}/${d}/.connstr
		echo -n "@/" >> ${1}/${d}/.connstr

		f=$(echo ${e} | cut -d ':' -f 3)
		echo -n ${f} >> ${1}/${d}/.connstr
		echo -n "?host=/run/postgresql" >> ${1}/${d}/.connstr

		chmod 0400 ${1}/${d}/.connstr
		rm -f ${1}/${d}/.pgpass
	done 
}

new_part ${dst}/sql ${f}
pgpas2constr ${dst}
cat ${f}  | sh -s
[ $? -eq 0 ] || cat ${f}

for g in $(ls ${dst}/sql/1/*.tmp) ; do 
	h=$(echo ${g} | cut -d '.' -f 1,2)
	mv -f ${g} ${h}
done

#HUOM. tässä kohtaa hukataan my.post.conf:ista se .conf
for g in $(ls ${dst}/sql/2/*.tmp) ; do 
	h=$(echo ${g} | cut -d '.' -f 1,2)
	mv -f ${g} ${h}
done
