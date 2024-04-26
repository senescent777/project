#!/bin/sh
debug=0
mode=0
#VAIH:testit, esmes devauskoneella ensin (?) (riippuu skriptistä viittiikö ajaa)

parse() {
	case ${1} in
		-v)
			debug=1
		;;
		*)
			mode=${1}
		;;
	esac
}

parse ${1}
parse ${2}

cd /home/devuan/Dpckcer/buildr/tmp
[ $? -eq 0 ] || exit 65

[ -f ./ft.sh ] || cp ../bin/ft.sh .
[ ${debug} -eq 1 ] && sleep 5
[ -f ./ft.sh ] || exit 66
[ ${debug} -eq 1 ] && echo "ft FOUND, w1ll c0nt1nue s00n";sleep 3 

chmod 0555 ./ft.sh
./ft.sh 7 ../../project ${1}
cd ../../project
[ $? -eq 0 ] || exit 67

if [ ${debug} -eq 1 ] ; then
	pwd;sleep 3
	/bin/sync /
	/bin/sync /home
fi

docker system prune

if [ ${debug} -eq 1 ] ; then
	sleep 5
	/bin/sync /
fi

export PATH=$HOME/.local/bin:$HOME/bin:$PATH 
cd /home/devuan/Dpckcer/project
[ $? -eq 0 ] || exit 68

[ ${debug} -eq 1 ] && pwd;sleep 6
[ -d ./temporary1 ] || mkdir -p ./temporary1
[ -d ./permanent1 ] || mkdir -p ./permanent1
#demoamisen kannalta parempi ettei xxx poiste attribuutteja
/home/devuan/Dpckcer/buildr/source/scripts/xxx
#HUOM.sudo ei enää tarpeen 230124

if [ $# -gt 0 ] ; then
	case ${mode} in
		1)
			rm ~/lib.sh
			ln -s ~/Dpckcer/project/cleaner/lib.sh ~/lib.sh
			#VAIH:opopulate3 jatkossa
			./scripts/populate3.sh_dirs ./temporary1 --bobby -v
			#tämä toiminta vaatisi sitä chattrn hakkaamista, ehkä
			#...oli tietysti hyvä jos saisi gpg:n toimimaan
			sleep 5
		;;
		*)
			[ ${debug} -eq 1 ] && echo "nopopulate"
		;;
	esac
fi

sudo /sbin/ifup eth0

prefetch() {
	#uutena 130124, onkohan tarpeellinen?
	
	for r in $(grep image $HOME/Dpckcer/project/another.yml | grep -v '#' | awk '{print $2}') ; do
			docker pull $r
	done
}

prefetch
[ $? -eq 0 ] || exit 69

#jos tähän asti päästy ni .env tulisi juuresta löytyä
[ -s .env ] || exit
[ ${debug} -eq 1 ] && echo "bu1ld att3mpt w1ll f0ll0w";sleep 4
/usr/bin/docker-compose -f /home/devuan/Dpckcer/project/another.yml build

if [ ${debug} -eq 1 ] ; then
        sleep 5
        /bin/sync /
        /bin/sync /home
        echo "pt3 don3"
fi
