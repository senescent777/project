#mangle=$( | tr -d -c a-zA-Z0-9./ )
checksig_base=$(which gpg)
checksig_cmd="${checksig_base} -q --verify"
ext="sig"
#VAIHEESSA?:sign_cmd samaan tapaan kuin yllä, tai siis gnis on jo...

ossl=$(which openssl)
#rowsign_cmd="${ossl} pkeyutl -sign -inkey ~/dbkey.key | xxd -p | tr -d '\n' | cut -b 1-63"

#TODO:hmac-sha256 myös tähän?
gnis() {
	case ${1} in
		sig)
			#kokeillaan jos menisi näin
			${checksig_base} -u thor -sb ${2}
		;;
		*)
			#pikemminkin ossl kuin cheksig_base
			${checksig_base} rsautl -sign -inkey ${3} -keyform PEM -in ${2} > ${2}.${ext}
		;;
	esac
	
	
	if [ $? -gt 0 ] ; then
		[ ${debug} -eq 1 ] && echo "sudo /opt/bin/xxx.sh"
	fi
}

sign_row() {
	local tmp

	case ${1} in
		ossl)
			tmp=$(echo ${2} | ${ossl} pkeyutl -sign -inkey ${HOME}/keys/${3})
			tmp=$(echo ${tmp} | xxd -p | tr -d '\n' | cut -b 1-30)  
			echo ${tmp}		
		;;
		gpg)
			#tmp=$(echo ${2} | ${checksig_base} -u ${3} -sb -) 
		;;
		hmac)
			#TODO
		;;
		*)
			exit 666
		;;
	esac
}

firstrow() {
	[ $debug -eq 1 ] && echo "FRIST"

	case ${3} in
		t)
			echo -n "INSERT INTO tempfilez(filename,path) VALUES " >> ${2}
		;;
		*)
			exit 666
		;;
	esac
}

add_sep() {
	[ $debug -eq 1 ] && echo " vSEPPO (nimi muutettu)"
	echo -n "," >> ${2}
}

#HUOM. voisi kai joskus kokeilla miten tr onnistuu estämään härdellin (bobby t olisi jo valmiina)
addwor3() {
	[ $debug -eq 1 ] && echo "addwor33 ${1} ${2} ${3}"
	echo -n "('" >> ${2}

	tmp=$(echo ${1} | tr -d -c a-zA-Z0-9./ )
	echo -n ${tmp} >>  ${2} 
	echo -n "','" >> ${2}

	tmp=$(echo ${3} | tr -d -c a-zA-Z0-9./ )
	echo -n ${tmp} >>  ${2} 
	echo -n "')" >> ${2}
}	

delrow() {
	[ $debug -eq 1 ] && echo "delrow ()"

	if [ -f ${1} ] ; then 
		if [ $debug -eq 1 ] ; then 
			echo "rm ${1}"
		else
			rm ${1}
		fi
	else
		[ $debug -eq 1 ] && echo "no such agency"
	fi 

	if [ -f ${2} ] ; then 
		if [ $debug -eq 1 ] ; then 
			echo "rm ${2}"
		else
			rm ${2}
		fi
	else
		[ $debug -eq 1 ] && echo "no such agency"
	fi
}

finalrow() {
	[ $debug -eq 1 ] && echo "LSTA RW0"
	echo ";" >> ${2}
}

dbcmd_base=$(which psql)
dbcmd_base="${dbcmd_base} -d ${PGDATABASE} -U ${PGUSER}"

#TODO:pois cleanerin tontilta koska kronos (?=
part4() {
	${dbcmd_base} -c "CALL del_md_rows();"
}
