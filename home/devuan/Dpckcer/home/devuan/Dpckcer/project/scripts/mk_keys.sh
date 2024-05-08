#!/bin/sh
#
##HUOM. tämä tulee ajaa serttien luonnin jälkeen, tempin täyttö myös sertin luonnin jölkeen
#. ~/lib.sh
##HUOM.14.10.23:o0likos tämä jo kopsattu buildr:iin? vissiin on
##HUO.22.11.23:saattoi olla jokin juttu miksi avainten luonti kontin ulkop, selvitä
#
#this_make_key() {
#	case ${2} in
#		odin)
#			gpg  --quick-gen-key ${2}
#		;;
#		*)
#			case ${1} in
#				sig)
#					${checksig_base} --quick-gen-key ${2}
#				;;
#			esac
#		;;
#	esac
#}
#
#this_sign_key() {
#	case ${2} in
#		odin)
#			gpg --sign-key ${2}
#			gpg --export ${2} > ./keys/${2}.gpg
#		;;
#		*)
#			case ${1} in
#				sig)
#					${checksig_base} --sign-key ${2}
#				;;
#			esac
#		;;
#	esac
#}
#
#if [ -d ~/.gnupg ]; then
#	echo "~/.gnupg ALR3ADY EXISTS!!!!!"
#else
#	for k in odin thor loki ; do
#		this_make_key ${ext} ${k}
#		this_sign_key sig ${k}
#		#this_exp_key ${k}
#	done
#
#	gpg --export odin loki > ./keys/loki.gpg
#	gpg --export odin thor > ./keys/thor.gpg
#fi
#
#sleep 5
#
##VAIHEESSA:make_certs'iin muutoksia tähän skriptiin liittyen
##.key- ja .crt- tiedostot pitäisi allekirj s.e. ketju osoittaa odiniin asti
#
#tar -cvf ./keys/loki.tar ./keys/ca*
#gpg -u loki -sb  ./keys/loki.tar 
#tar -cvf ./keys/loki2.tar ./keys/*.crt ./keys/*.key
#gpg -u loki -sb  ./keys/loki2.tar 
#
##TODO:ao. lista kuntoon ja konftsdtoon (niinqu mihin?)
#for lt in index local_rw ro rw msgb0x ; do
#	cp ./keys/loki.gpg  ./${lt}/
#done
#
##TEHTY:thor'in pitäisi mennä local_rw'lle ja rw'lle ... siis thorin sallaisen avaimen koska x
##HUOM. mjolnir kierrätettävä secretsin kautta!!!
#
#cp ./keys/thor.gpg ./cleaner#
#
#for tt in local_rw rw ; do
#	cp ./keys/odin.gpg ./${tt}/
#	cp ./keys/mjolnir ./${tt}/ #miksi piti mennä rw:lle?
#done
#
#shred -fu ./keys/mjolnir
#
