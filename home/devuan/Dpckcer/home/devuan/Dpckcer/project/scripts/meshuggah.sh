#!/bin/sh
base0=/home/devuan/Dpckcer
base=${base0}/project

#TEHTY:päätteeksi .sh
#VAIH:toisen hakemiston alaisuuteen
#HUOM! tuo possu-hmiston tuhoaminen taitaa olla ainoa miksi oikeastaan pitää sudottaa
sudo /opt/bin/meshuggah.sh

rm -rf ${base}/sql/init-user-db.sql
rm -rf ${base}/sql/1/init-user-db.sql
rm -rf ${base}/sql/init-user-db.sql.OLD
rm -rf ${base}/sql/1/init-user-db.sql.OLD
rm -rf ${base}/sql/2/*

for f in $(find ${base} -type f -name '.env*') ; do rm ${f} ; done
for f in $(find ${base} -type f -name '.pg*') ; do rm ${f} ; done
for f in $(find ${base} -type f -name '*.txt') ; do rm ${f} ; done
for f in $(find ${base} -type f -name 'rules*') ; do rm ${f} ; done

#eipä hukata nginx'n knffeja
for f in $(find ${base} -type f -name '.conn*') ; do rm ${f} ; done

#HUOM.150124:uutena requirements.txt
for f in $(find ${base} -type f -name requirements.txt) ; do rm ${f} ; done

THIS_FLASK_DIRS="index local_rw msgb0x ro1 rw1 cleaner kronos"
THIS_WEBKEY_DIRS="index local_rw msgb0x ro1 rw1 cleaner kronos"

#voisi olla laajempikin lista
for t in ${THIS_FLASK_DIRS} ; do
	rm ${base}/${t}/${t}.tar
	rm ${base}/${t}/vnev.tar
done

#kts make_certs.sh
for t in $THIS_WEBKEY_DIRS ; do
	rm ${base}/${t}/*.csr
	rm ${base}/${t}/*.crt
	rm ${base}/${t}/*.key
done

rm -rf ${base0}/buildr/tmp/*
rm -rf ${base0}/buildr/tmp/.*
echo "docker system prune?"

rm ${base}/keys/pub/*
rm ${base}/keys/priv/*

rm ${base}/temporary1/*
rm ${base}/permanent1/*

rm ${base}/dsn/t/resolv.conf.13

