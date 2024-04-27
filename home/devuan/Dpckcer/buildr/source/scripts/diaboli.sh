#!/bin/sh
for f in $(find . -name '*.OLD') ; do echo "rm $f" ; done

#totaalituho wanhoille asetuksille(kts myös /o/b/m)
for f in $(find . -name '*.env') ; do rm $f ; done
for f in $(find . -name '*.pg*') ; do rm $f ; done
for f in $(find . -name '*.connstr') ; do rm $f ; done
