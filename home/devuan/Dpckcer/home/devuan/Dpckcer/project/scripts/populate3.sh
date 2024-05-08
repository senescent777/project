#!/bin/sh
if [ -s  ~/bin/dirs.conf ] ; then  
	. ~/bin/dirs.conf
#else
#	. ./dirs.conf
fi
#
#lib taidettiin tarvita allekirjoitushommiin
#. ~/lib.sh


debug=0
bobby=0
list=""

parse_opts() {
	case ${1} in
		-v)	
			debug=1
		;;	
		-h|--h)
			echo "$0 dir1 [dir2] [--bobby] [-v]"
			exit
		;;
		--bobby)
			bobby=1
		;;
		*)
			list="${list} ${1}"
		;;
	esac
}

if [ $# -eq 0 ] ; then
	echo "$0 -h"
	exit
fi

parse_opts ${1}
parse_opts ${2}
parse_opts ${3}
parse_opts ${4}

. ~/bin/populate_be.sh

for x in ${list} ; do
	process_row ${x} ${bobby} ${debug}
done
