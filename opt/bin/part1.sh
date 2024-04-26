#!/bin/sh

mode=${1}
debug=${2}
base=/home/devuan/Dpckcer

. /opt/bin/part0.sh

case ${mode} in
	1)
		part1
	;;
	2)
		part2
	;;
	3)
	#tämä
		part3
	;;
	4)
		part4
	;;
#	5)
#		part1
#		part2
#		part3
#		part4
#	;;
	6)
		part666
	;;
	*)
		echo "fallback"
	;;
esac

#echo "debug=$debug"
#echo "mode=$mode"
#echo "base=$base"
