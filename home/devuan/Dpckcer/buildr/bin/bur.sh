#!/bin/sh
. ~/bin/dirs.conf
sleep 5

#VAIHEESSA:make_certs'iin muutoksia tähän skriptiin liittyen
#.key- ja .crt- tiedostot pitäisi allekirj s.e. ketju osoittaa odiniin asti
#HUOM. oleeellisimpien avainten kanssa chattr +ui (eipä linkitetä sitten?)

keysdir=${HOME}/keys

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
	gpg --pinentry-mode loopback --import ${HOME}/keys/asgard*.gpg
fi

#HUOM:gpg export-pub odin, thor, loki tarkoitus exportoida aiemmin


#TODO:thor allek jotain /keys alaisia? mikähän idea?

#idiksenä kai oli että konttien rak vaih voisi loki.gpg vasten tastata loki.tar ?
for x in ${THIS_WEBKEY_DIRS} ; do
	cp ${keysdir}/loki.gpg  ~/tmp/${x}/
done

#oleellisimmat kontit .sig-tdstojen tark kannalta
#paikallisiin .gph-hmistoihin vois ittenl isätäm uitakin julk avamia jotka mjonlirilla allek
for x in cleaner rw clientd ; do
	cp ${keysdir}/thor.gpg   ~/tmp/${x}/
done

#useimilla konteilla riittäisi ro-pääsy keys-hmistoon
#clientd:n tarvitsisi vissiin lisätä jotta voi varmistaa, ja mahdollistaa muidenkin ...
#jos clientd ei lisää yhteiseen hmistoon muiden puolesta niin sitten rw'n on omaan .gpg-hmistoon lisättävä
#jotta voi lähetettyjä tarkistaa (vedetään jolatn ro-kontilta a.xxx.gpg)

for x in ${THIS_TARGETS} ; do
	cp ${keysdir}/odin.gpg  ~/tmp/${lt}/
done

gpg --export-secret-keys thor > ~/tmp/local_rw/mjolnir
#loki.gpg:tä vastaava salainen myös local_rw'lle?

for x in $(find ${keysdir}/pub -type f -name 'ca*') ; do 
	echo "TODO: gpg -u loki -sb ${x}"
done

for x in ${RSKEY} ${RSKEY2} ${RSKEY3} ; do
	"TODO: gpg -u loki -sb ${keysdir}/pub/${x}.crt"
done
