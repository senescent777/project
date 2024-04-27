#!/bin/sh
cmd=$(which gpg)

ngix() {
	gpg -u thor -sb $f
}

main() {
	for f in $(find $1 -type f | grep -v '.sig') ; do
		ngix $f
	done
}

if [ -d $1 ] ; then
	main $1
fi
