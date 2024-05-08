#!/bin/sh
. ~/bin/dirs.conf
sleep 5

#VAIHEESSA:make_certs'iin muutoksia tähän skriptiin liittyen
#.key- ja .crt- tiedostot pitäisi allekirj s.e. ketju osoittaa odiniin asti
#HUOM. oleeellisimpien avainten kanssa chattr +ui (eipä linkitetä sitten?)

#ideana kai ajaa juuri make_certs'in+mk_rskeys'in jölkeen

keysdir=${HOME}/keys
debug=0
#alpinessa ei ole bash vakiovaruste ni toivottavasti sh kelpaa

parse_opts() {
	case ${1} in
		-v)
			debug=1
		;; 
	esac
}

if [ -d ${HOME}/.gnupg ]; then
	echo "~/.gnupg ALR3ADY EXISTS!!!!!"
else
	chmod 0600  ${HOME}/keys/*.gpg
	gpg --list-keys
	#pitäisiköhän olla 0644?
	chmod 0700  ${HOME}/.gnupg 
	
	#HUOM.150124: gpg: key 4070543868AD46EE/4070543868AD46EE: error sending to agent: Permission denied
	#gpg: error building skey array: Permission denied
	#gpg: error reading '/home/buildr/keys/gungnir.gpg': Permission denied
	#gpg: import from '/home/buildr/keys/gungnir.gpg' failed: Permission denied
	#...PITÄISI JOtain keksiä (TODO) (0700 ei oikein?)

	#https://bbs.archlinux.org/viewtopic.php?id=223241
	#gpg --pinentry-mode loopback --import ${HOME}/keys/asgard*.gpg
	
	#vai olisikohan kätevämpi vain prukaa tar?
	tar -xvpf ${keysdir}/punk150124.tar
	#echo "run $0 again"
	#exit
	sleep 5
fi

[ ${debug} -eq 1 ] && echo "pt1";sleep 1
gpg --export odin > odin.gpg
[ $? -eq 0 ] || exit

#HUOM:gpg export-pub odin, thor, loki tarkoitus exportoida aiemmin
for x in ${THIS_TARGETS} ; do
#	cp ${keysdir}/odin.gpg  ~/tmp/${lt}/
	cp odin.gpg  ~/tmp/${x}
done

#thor allek jotain /keys alaisia? mikähän idea? no varmistaa että on kys. av omist hyväksyntä
#.. nykyään (260124) käytetään loki:n privk allek ne openssl-jutut
[ ${debug} -eq 1 ] && echo "pt2";sleep 1
gpg --export loki > loki.gpg

#idiksenä kai oli että konttien rak vaih voisi loki.gpg vasten tastata loki.tar ?
for x in ${THIS_WEBKEY_DIRS} ; do
	cp loki.gpg ~/tmp/${x}/
done

[ ${debug} -eq 1 ] && echo "pt3";sleep 1
#oleellisimmat kontit .sig-tdstojen tark kannalta
#paikallisiin .gph-hmistoihin vois ittenl isätäm uitakin julk avamia jotka mjonlirilla allek
gpg --export thor > thor.gpg

for x in cleaner rw clientd ; do
	cp thor.gpg ~/tmp/${x}/
done

#HUOM. tarvitseeko kronos nimenomaan loki.gpg ? no kannan rivehin tietty, cleaner tar sisällöt, se tarttee thor.gpg
#myös clientd'n ainakin täytyy tarkistaa rskey-jutut
for x in kronos clientd ; do
	cp loki.gpg ~/tmp/${x}/
done

#useimilla konteilla riittäisi ro-pääsy keys-hmistoon
#clientd:n tarvitsisi vissiin lisätä jotta voi varmistaa, ja mahdollistaa muidenkin ...
#jos clientd ei lisää yhteiseen hmistoon muiden puolesta niin sitten rw'n on omaan .gpg-hmistoon lisättävä
#jotta voi lähetettyjä tarkistaa (vedetään jolatn ro-kontilta a.xxx.gpg)
[ ${debug} -eq 1 ] && echo "pt4";sleep 1

gpg --export-secret-keys thor > ~/tmp/local_rw/mjolnir
#tarvitseeko l_rw loki-priv-key:tä? jos riittäisi openssl'n salaiset
#loki.gpg:tä vastaava salainen myös local_rw'lle?
gpg --export-secret-keys loki > ~/tmp/reg/loki-priv

[ ${debug} -eq 1 ] && echo "pt5";sleep 1
for x in $(find ${keysdir}/pub -type f -name 'ca*') ; do 
	gpg -u loki -sb ${x}
done

[ $debug -eq 1 ] && echo "pt5";sleep 5
cp ${HOME}/keys/thor.gpg ${base}/reg
[ ${debug} -eq 1 ] && echo "pt6";sleep 1

for x in ${RSKEY} ${RSKEY2} ${RSKEY3} ; do
	gpg -u loki -sb ${keysdir}/pub/${x}.crt
done
