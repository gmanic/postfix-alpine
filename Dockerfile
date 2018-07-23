FROM alpine

RUN apk add --no-cache postfix postfix-sqlite postfix-pcre postfix-ldap python3 py2-pip
RUN pip3 install chaperone
RUN mkdir -p /etc/chaperone.d
COPY chaperone.conf /etc/chaperone.d/chaperone.conf
COPY postfix-setup.py /usr/sbin/postfix-setup.py

#COPY conf /conf
#COPY start.py /start.py

EXPOSE 25/tcp 465/tcp 587/tcp

VOLUME /mnt/postfix-config
VOLUME /var/spool/postfix

#CMD /start.py
#CMD /usr/bin/chaperone
ENTRYPOINT ["/usr/bin/chaperone"]

