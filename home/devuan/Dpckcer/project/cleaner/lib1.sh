checksig_cmd=$(which openssl)
checksig_cmd="${checksig_cmd} dgst -sha256 -verify ./keys/thor.ssl -signature "
ext="sign"

#TODO:sign_cmd samaan tapaan kuin yllä
#TODO:juttujen nimeäminen

firstrow() {
	[ $debug -eq 1 ] && echo "FRIST"
	echo -n "INSERT INTO tempfilez VALUES " >> ${2}
}

addwor2() {
	[ $debug -eq 1 ] && echo " SEPPO "
	echo -n "," >> ${2}
}
#TODO:kokeilu miten tr onnistuu estämään härdellin? (bobby t olisi jo valmiina)
#, bissiin ei ole viel härdelliä aiheutunut mutta josko kokeilisi? sqla olisi jo käytössä
addwor3() {
	[ $debug -eq 1 ] && echo "addwor33 ${1} ${2}"
	echo -n "('" >> ${2}

	tmp=$(echo ${1} | tr -d -c a-zA-Z0-9./ )

	echo -n ${tmp} >>  ${2} 
	echo -n "')" >> ${2}
}	

delrow() {
	[ $debug -eq 1 ] && echo "delrow ${1} ${2}"
	[ -f ${1} ] && rm ${1}
	[ -f ${2} ] && rm ${2}
}

finalrow() {
	[ $debug -eq 1 ] && echo "LSTA RW0"
	echo ";" >> ${2}
}
