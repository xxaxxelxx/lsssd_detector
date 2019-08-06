#!/bin/bash
HOME="/usr/local/homegrown/liquidsilence"
test -d "$HOME" || exit 1
cd "$HOME"

test  $# -lt 7 && \
    echo "usage:   $(basename $0) INTERFACE MAXNETLOADPERCENT MAXCPULOADPERCENT DB_HOST DB_PORT DB_PASS ALIVE_LIMIT" && \
    echo "example: $(basename $0) ens3 50 30 192.168.99.99 3306 trallala 10.0" && \
    exit 1

CIF=$1
test "x$CIF" == "x" && exit 1

MAXNETLOAD=$2
test "x$MAXNETLOAD" == "x" && exit 1

MAXCPULOAD=$3
test "x$MAXCPULOAD" == "x" && exit 1

DB_HOST=$4
test "x$DB_HOST" == "x" && exit 1

DB_PORT=$5
test "x$DB_PORT" == "x" && exit 1

DB_PASS=$6
test "x$DB_PASS" == "x" && exit 1

ALIVE_LIMIT=$9
test "x$ALIVE_LIMIT" == "x" && exit 1

test -d "/var/run/liquidsoap" || (mkdir -p "/var/run/liquidsoap" && chown liquidsoap "/var/run/liquidsoap")

while true; do
    # STARTUP
    C_MNTPNTLIST="$(echo "SELECT mntpnt FROM status WHERE (UNIX_TIMESTAMP() - $ALIVE_LIMIT > alive);" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)" #"

    for C_MNTPNT in $C_MNTPNTLIST; do

	# TEST FOR NETWORK LOAD

	# TEST FOR CPU LOAD
	CPULOAD=$(./get_cpuload.sh /host/proc)
	test "x$CPULOAD" == "x" && sleep 1 && break
	test $CPULOAD -gt $MAXCPULOAD && sleep 60 && break

	sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -d -- $C_MNTPNT $DB_HOST $DB_PORT $DB_PASS $ALIVE_LIMIT && echo "$C_MNTPNT started"
	sleep 1
    done 
    sleep 1
done

exit $?

#while true; do sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -- http://broadcast.ir-media-tec.com/bbradio-ch08.mp3 192.168.100.123 3306 rfc1830; done
#while true; do sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -- http://ir-media.hoerradar.de/bbradio-xmas-mp3-hq 192.168.100.123 3306 rfc1830; done

#END