#!/bin/sh
mode=2
debug=0

parse_opts() {
	case ${1} in
		-m)
			mode=$2
		;; 
		-v)
			debug=1
		;;
	esac
}

parse_opts $1 $2
parse_opts $3

if [ ${debug} -eq 1 ] ; then  
	echo "parse_opts_done()"
	/bin/sync /
	/bin/sync /home
	sleep 5
fi

cd /home/devuan/Dpckcer
[ $? -eq 0 ] || exit 99
#HUOM.21.11.23:ei ole enää pack_it, toiminnallisuus siirretty muualle
#VAIH:prebuild
#sudo /sbin/ifup eth0

#HUOM.20124:nämä kullä tylisi löytyä... paitsi jos...
for d in bin tmp source keys ; do
	[ -d ./buildr/${d} ]  || mkdir -p ./buildr/${d}
done

#jatkossa jos req olisi pre-hmistossa ja täts it (riippuu vähän jutuista)
[ -s ./buildr/pre/requirements.txt ] || cp ./buildr/source/requirements.txt ./buildr/pre

if [ -s ./buildr/3.16.tar ] && [ -s ./buildr/openssl.tar ] ; then
	[ ${debug} -eq 1 ] && echo -n "NO NEED TO "
else
	/usr/bin/docker-compose -f pre.yml build
	#tai jos vain pre.ym up
	/usr/bin/docker-compose -f pre.yml run prebuild
	/usr/bin/docker-compose -f pre.yml run prebuild2
	
	[ ${debug} -eq 1 ] && echo -n " ... ";sleep 5
	
	[ -f ./buildr/tmp/openssl.tar ] && mv ./buildr/tmp/openssl.tar ./buildr
	[ -f ./buildr/tmp/3.16.tar ] && mv ./buildr/tmp/3.16.tar ./buildr
	#[ -f ./buildr/tmp/vnev.tar ] && mv ./buildr/tmp/vnev.tar ./buildr/source
fi

[ -s ./buildr/source/repositories ] || cp ./buildr/pre/repositories ./buildr/source
#[ -s ./buildr/source/sources.list ] || cp ./buildr/pre/sources.list ./buildr/source
[ -s ./buildr/source/01recommended ] || cp ./buildr/pre/01recommended ./buildr/source
	
[ ${debug} -eq 1 ] && echo "PREBUILD"
/usr/bin/docker-compose -f compose3.yml build

if [ ${debug} -eq 1 ] ; then  
        echo "c0mp0s3_done()"
        /bin/sync /
        /bin/sync /home
        [ ${debug} -eq 1 ] && sleep 5
fi

./buildr/source/scripts/meshuggah.sh
/usr/bin/docker-compose -f compose3.yml run buildr2
#meneeköhän buildrin jälkeen jotain pieleen?

if [ ${debug} -eq 1 ] ; then  
        echo "bldr2_done()"
        /bin/sync /
        /bin/sync /home
        sleep 5
fi

#varm. buoksi aiemmat kontit sammuksiin
kea() {
	docker kill project_backend_1
	docker kill dpckcer_backend_1
	docker kill dpckcer_backend2_1
}

kea
sleep 1

#jossain tilanteessa saaattaa se xxx olla myös tarpeellinen
sleep 1

#24.11.23:buildr nyt toisella tavalla koska compose pykii
rtl() {
	docker build -f ./buildr/Dockerfile
	docker run --rm -d -it --name bldr2 --network none -v ~/Dpckcer/buildr/bin:/home/buildr/bin:ro -v ~/Dpckcer/buildr/tmp:/home/buildr/tmp:rw -v ~/Dpckcer/buildr/source:/home/buildr/source:ro dpckcer_buildr2
	docker exec -it bldr2 su buildr -c cd;./bin/FIRST_RUN;exit
	docker kill bldr2
}

export PATH=$HOME/.local/bin:$HOME/bin:$PATH 

#HUOM.21.11.23.2: tavallinen backend testaa toimiiko sql+konffit, backend2 luo datahmiston sisällön
#olisikohan run'illa tässä tapauksessa etua up yli?
#no & tässä nyt lisätty 271123, pois jos kusee

case ${mode} in
	0)
		PATH=$HOME/.local/bin:$HOME/bin:$PATH /usr/bin/docker-compose -f possutest.yml up backend&
	;;
	1)
		PATH=$HOME/.local/bin:$HOME/bin:$PATH /usr/bin/docker-compose -f possutest.yml up backend2&
	;;
	2)
		[ $debug -eq 1 ] && echo "BYPASSING DB-TEST"
	;;
esac

sleep 5
[ ${debug} -eq 1 ] && sleep 6
kea

#pitäisiköhän sittenkin olla tämän kohdan jölkeen se logout?
if [ ${debug} -eq 1 ] ; then
	echo "db_t3sts_d0ne()"
	/bin/sync /
	/bin/sync /home
	sleep 5
fi
