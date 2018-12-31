FROM alpine

RUN apk add --no-cache postfix postfix-mysql postfix-pcre postfix-ldap python3 py2-pip procmail
RUN pip3 install chaperone
RUN mkdir -p /etc/chaperone.d
COPY chaperone.conf /etc/chaperone.d/chaperone.conf
COPY postfix_setup.py /usr/sbin/postfix_setup.py

#COPY conf /conf
#COPY start.py /start.py

EXPOSE 25/tcp 465/tcp 587/tcp

VOLUME /mnt/postfix-config
VOLUME /var/spool/postfix
VOLUME /var/spool/mail
VOLUME /var/spool/maildir

#CMD /start.py
#CMD /usr/bin/chaperone
ENTRYPOINT ["/usr/bin/chaperone"]

