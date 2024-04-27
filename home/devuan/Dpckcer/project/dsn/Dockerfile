FROM aciobanu/dnsmasq:latest
WORKDIR /
COPY ./resolv.conf.13 /etc/
CMD dnsmasq -A /some/172.19.0.4 -r /etc/resolv.conf.13  -q -k -2 --log-facility=- --dns-loop-detect
#tarvitaanko r.c.13 2 kertaan?