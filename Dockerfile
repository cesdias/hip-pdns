FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install curl gnupg -y

COPY pdns.list /etc/apt/sources.list.d/
COPY pdns /etc/apt/preferences.d/pdns

RUN curl -sSL https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add -
RUN apt-get update && apt-get install -y pdns-server pdns-backend-pipe && apt-get purge -y pdns-backend-bind

EXPOSE 53/tcp
EXPOSE 53/udp

ADD pipe.conf /etc/powerdns/pdns.d/
ADD hip-pdns /etc/powerdns/

RUN chmod a+x /etc/powerdns/hip-pdns

CMD /usr/sbin/pdns_server
