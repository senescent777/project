#!/bin/sh
#/sbin/iptables-restore /etc/iptables/rules 
#TODO:tableskäyntiin vain jos verkkoliitäntä löytyy (joko jo 0112323)
#24.9.23 vaihdettu tilapäisesti alpinen versioon 3.18, joten parametritkin uusiksi eli -l 2 pois
/usr/sbin/crond -f -l 2 
#HUOM.190124:tuli vivusta -f valitusta, apk pugrade huono idea?
#koita muistaa katsoa kuinka tarpeellinen -l olikaan
