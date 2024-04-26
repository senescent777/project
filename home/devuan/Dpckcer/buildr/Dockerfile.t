FROM alpine:3.16
WORKDIR /

#HUOM. apk fetch -R (gpg-agent gpg cronie postgresql15-client tini iptables)
ADD ./3.16.tar /
RUN touch repo.list&&apk add --repositories-file=repo.list --allow-untrusted --no-network --no-cache /data/apkcache/*.apk 
RUN rm /data/apkcache/*

RUN adduser -D tstr
RUN ln -s /run/secrets/tstr_pgpass /home/tstr/.pgpass
RUN echo "HUOM!!! MUISTA sudo /opt/bin/meshuggah !!!"

#tässä nyt vielä pykii jokin kun ei yhteys muodostu
RUN mkdir -p /home/tstr/bin
RUN chmod 0755 /home/tstr/bin
RUN echo "#!/bin/sh" >> /home/tstr/bin/doIt.sh
RUN echo "echo \"HUOM MUISTA sudo /opt/bin/meshuggah\"" >> /home/tstr/bin/doIt.sh
RUN echo "sleep 5" >> /home/tstr/bin/doIt.sh
RUN echo "export PGPASSFILE=$HOME/.pgpass" >> /home/tstr/bin/doIt.sh
#joskohan ilman parametreja toimisi?
RUN echo "psql -d ${PGDATABASE} -U ${PGUSER} -c \"SELECT * FROM chain;\"" >> /home/tstr/bin/doIt.sh
RUN chmod 0555 /home/tstr/bin/*.sh

RUN chown -R tstr:tstr /home/tstr
RUN ls -laR /home/tstr
