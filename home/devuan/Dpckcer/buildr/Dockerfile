FROM alpine:3.16
WORKDIR /

#2+1 volumea:skriptihakemisto (ro) sekä sitten output-hmisto minne oksennetaan esim. tar
#sen tarin sitten kun purkaa hostin puolella niin tulee kontteihin ne em. jutut 
#...kolmantena sitten se avainhak

RUN adduser -D buildr
RUN mkdir -p /home/buildr/bin
RUN mkdir -p /home/buildr/tmp
RUN mkdir -p /home/buildr/source
RUN mkdir -p /home/buildr/keys
RUN chown -R buildr:buildr /home/buildr
#RUN mkdir -p /data/apkcache
RUN ls -laR /home/buildr

#HUOM. apk fetch -R (gpg-agent gpg cronie postgresql15-client tini iptables)
#HUOM.2. versio
#HUOM.3. nykyään(19.1.24) olemassa prebuild 
ADD ./3.16.tar .

ADD ./openssl.tar .
RUN touch repo.list&&apk add --repositories-file=repo.list --allow-untrusted --no-network --no-cache /data/apkcache/*.apk 
#sittenkin jätetään dellimättä 2 em. tar koska tarvitaan myöhemmin

ARG lib_vrs
COPY  ./source/lib${lib_vrs}.sh /home/buildr
RUN chmod 0555 /home/buildr/lib*.sh
RUN ln -s /home/buildr/lib${lib_vrs}.sh /home/buildr/lib.sh

#15.1.24 uutena .gnupg lisäys ja odin/thor/loki-jutdkat
#COPY ./punk150124.tar /home/buildr/
#RUN tar -C /home/buildr -xvpf /home/buildr/punk150124.tar
# 
##VAIH:jatkossa pois nämä seur. rivit, skriptien tulisi luoda nuo tdstot
##... tai sitten mountataan /keys
#COPY ./loki.gpg /home/buildr/keys
#COPY ./thor.gpg /home/buildr/keys 
#COPY ./odin.gpg /home/buildr/keys 
##COPY ./mjolnir /home/buildr/keys
 
RUN chown -R buildr:buildr /home/buildr


