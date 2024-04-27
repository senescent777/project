#!/bin/sh
. ~/bin/dirs.conf
debug=0

base=${HOME}/tmp
[ $debug -eq 1 ] && pwd
[ $debug -eq 1 ] && echo "pt1";sleep 5

cp -a ${HOME}/source/scripts/*.sh ${base}/scripts
cp -a ${HOME}/bin/b*.sh ${base}/scripts

cp -a ${HOME}/bin/populate*.sh ${base}/scripts
cp -a ${HOME}/bin/dirs.conf ${base}/scripts
chmod 0555 ${base}/scripts/*

[ $debug -eq 1 ] && echo "pt2";sleep 5

for t in ${THIS_FLASK_DIRS} ; do
	[ $debug -eq 1 ] && echo "cp ${HOME}/source/requirements.txt ${base}/${t}"
	grep -v '#' ${HOME}/source/requirements.txt > ${base}/${t}/requirements.txt
	#Pythonon versio 3.12 siitä kätevä ettei kontilla tartte ajaa apt:ia
	v=$(dd if=/dev/urandom bs=16 count=1 | base64)
	echo ${v} > ${base}/${t}/sk.txt
	#cp ${HOME}/source/vnev.tar ${base}/${t}/ toistaiseksi jemmaan (220124)
done

[ $debug -eq 1 ] && echo "pt3";sleep 5
#local_rw erikseen koska alpinen gpg hankalahko, koitetaan jos minideb... tai devuan...
for t in cleaner kronos ; do
	#konftdstossa pitäisi kai sanoa tuo lib2
	[ ${debug} -eq 1 ] && echo "cp ${HOME}/source/lib2.sh ${base}/${t}/lib.sh "
	cp ${HOME}/source/lib2.sh ${base}/${t}/lib.sh
	
	[ ${debug} -eq 1 ] && echo "tar -cf ${base}/${t}/${t}.tar /data/apkcache"
	tar -cf ${base}/${t}/${t}.tar /data/apkcache
done

#HUOM.080124:kts ../source/scripts/make_keys.sh liittyen
[ $debug -eq 1 ] && echo "pt4";sleep 5

for t in ${THIS_RSKEY_DIRS2} ; do
	[ $debug -eq 1 ] && echo "TODO: cp ${base}/keys/mjolnir ${base}/${t}"
done

[ $debug -eq 1 ] && echo "pt5";sleep 5
cp ${HOME}/keys/thor.gpg ${base}/reg
#TODO:loki.gpg -> l_rw ?


[ $debug -eq 1 ] && echo "pt6";sleep 5
cp ${HOME}/bin/ft.sh ${base}
ls -la ${base};sleep 5
chmod 0555 ${base}/ft.sh

#TODO:loki- ja thor-juttujen kopsauly
