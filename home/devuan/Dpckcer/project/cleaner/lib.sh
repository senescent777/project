

#HUOM. psql-kikkialuja ei tarvinne buildr-konttien kanssa oikeastaan
firstrow() {
	[ $debug -eq 1 ] && echo "FRIST"
	echo -n "INSERT INTO tempfilez VALUES " >> ${2}
}

addwor2() {
	[ $debug -eq 1 ] && echo " vSEPPO (nimi muutettu)"
	echo -n "," >> ${2}
}

#HUOM. voisi kai joskus kokeilla miten tr onnistuu estämään härdellin (bobby t olisi jo valmiina)
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

#vielä 1 kokeilu ennen manuaalin tavaamiSta
#echo "\set content ´#146´ ´cat ${tmpfile}´ ´#146´;INSERT INTO tempfilez  VALUES(:content);" | psql -h ${DBS} -d ${PGDATABASE} -U ${PGUSER} 
#
#toimivuus epäselvää
#echo "\set content `cat ${tmpfile}` ;INSERT INTO tempfilez VALUES(:content);" | psql -h ${DBS} -d ${PGDATABASE} -U ${PGUSER} 
#
#23-9.23:ei oikein toimijut tämä jekku
#psql -h ${DBS} -d ${PGDATABASE} -U ${PGUSER} << EOF
#\copy tempfilez FROM ${tmpfile} DELIMITER "," CVS HEADER;
#EOF
