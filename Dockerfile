FROM debian:buster
MAINTAINER xxaxxelxx <x@axxel.net>

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

RUN apt-get -qq -y update
RUN apt-get -qq -y dist-upgrade

RUN apt-get -qq -y install mc
RUN apt-get install -y mariadb-client
RUN apt-get install -y liquidsoap
# clean up
RUN apt-get clean

RUN test -d "/var/run/liquidsoap" || ( mkdir -p /var/run/liquidsoap && chown liquidsoap:liquidsoap /var/run/liquidsoap )
RUN test -d "/var/log/liquidsilence" || ( mkdir -p /var/log/liquidsilence && chown liquidsoap:liquidsoap /var/log/liquidsilence )

COPY liquidsoap/* /etc/liquidsoap/
COPY get_cpuload.sh /get_cpuload.sh
COPY get_nload.sh /get_nload.sh
COPY detectorrunner.sh /detectorrunner.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
#CMD [ "exit" ]

# END
