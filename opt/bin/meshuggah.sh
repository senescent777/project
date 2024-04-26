#!/bin/sh
base0=/home/devuan/Dpckcer
base=${base0}/project
mode=0

case $1 in 
	x)
		mode=1
	;;
esac

#HUOM! tuo possu-hmiston tuhoaminen taitaa olla ainoa miksi oikeastaan pitää sudottaa
case $mode in
	0)
		rm -rf ${base}/backend/possujuna
	;;
	1)
		chown devuan:devuan ${base}/temporary1
		chown devuan:devuan ${base}/permanent1
	;;
esac
