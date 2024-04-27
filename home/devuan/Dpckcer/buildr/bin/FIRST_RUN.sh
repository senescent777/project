#!/bin/sh
cd

rm -rf ./tmp/*
rm -rf ./tmp/.*
#keys'in juuri olisi kuitenkin syytä jättää rauhaan (chattr olisi 1 idea)
rm -rf ./keys/pub/*
rm -rf ./keys/priv/*
sleep 5

./bin/mkdirs.sh $1
./bin/mk_envfiles.sh backend $1 $2
./bin/mutilate_sql_2.sh $1 $2

#HUOM. jos /o/b/p1 laittaa tables.sh sudoersiin ni mk_ruls ei kande ajaa
#./bin/mk_ruls.sh $1

./bin/make_certs.sh -v
#vissiin -v auttaa ? (210124)

#./bin/bur.sh $1 #käyttöön sittenq gpg toimii
./bin/mk_rskeys.sh ${1}

# allekirj sitten oltava kontin ulkopuolella rllri dss gpg:tä toimimaan
#./bin/populate3.sh tmp/permanent1 tmp/temporary1 --bobby $1

./bin/filez.sh $1

cd ~/tmp
./ft.sh 1 $1
./ft.sh 8 $1

echo "d-c -f possutest up + ctrl-c | cd buildr/tmp;./ft.sh 7"
