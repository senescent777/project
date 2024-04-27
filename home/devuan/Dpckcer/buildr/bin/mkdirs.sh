#!/bin/sh
. ~/bin/dirs.conf
debug=0
base=${HOME}/tmp

parse_opts() {
	case ${1} in
		-v)
			debug=1
		;; 
	esac
}

parse_opts $1

#HUOM.200124:antaa nuyt toistaiseksi olla sen t:n
for d in backend dsn/t sql/1 sql/2 scripts temporary1 permanent1 ; do
	mkdir -p ${base}/${d}
done

[ ${debug} -eq 1 ] && echo "pt1.d0n3()";sleep 5

for d in ${THIS_TARGETS} ; do mkdir -p ${base}/${d} ; done
for d in ${THIS_WEBKEY_DIRS} ; do mkdir -p ${base}/${d} ; done
for d in ${THIS_DBKEY_CLIENTS} ; do mkdir -p ${base}/${d} ; done
for d in ${THIS_RSKEY_DIRS} ; do mkdir -p ${base}/${d} ; done

#uutena 150124
[ ${debug} -eq 1 ] && echo "M4K3_K3YZ_d1Rz";sleep 5
#pitäisi selvittää mikä demokoneessa kuseee tuon hak osalra?
for d in pub priv ; do mkdir -p ${HOME}/keys/${d} ; done
[ ${debug} -eq 1 ] && ls -laR ${base}


