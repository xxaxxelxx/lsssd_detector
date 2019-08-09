#!/bin/bash
test  $# -lt 8 && \
    echo "usage:   $(basename $0) INTERFACE INTERFACESPEEDMBIT MAXNETLOADPERCENT MAXCPULOADPERCENT DB_HOST DB_PORT DB_PASS ALIVE_LIMIT" && \
    echo "example: $(basename $0) ens3 1000 50 30 192.168.99.99 3306 trallala 10.0" && \
    exit 1

CIF=$1
test "x$CIF" == "x" && exit 1

CIF_SPEED=$2
test "x$CIF_SPEED" == "x" && exit 1

MAXNETLOAD=$3
test "x$MAXNETLOAD" == "x" && exit 1

MAXCPULOAD=$4
test "x$MAXCPULOAD" == "x" && exit 1

DB_HOST=$5
test "x$DB_HOST" == "x" && exit 1

DB_PORT=$6
test "x$DB_PORT" == "x" && exit 1

DB_PASS=$7
test "x$DB_PASS" == "x" && exit 1

ALIVE_LIMIT=$8
test "x$ALIVE_LIMIT" == "x" && exit 1

test -d "/var/run/liquidsoap" || (mkdir -p "/var/run/liquidsoap" && chown liquidsoap "/var/run/liquidsoap")

while true; do
    # STARTUP
    C_MNTPNTLIST="$(echo "SELECT mntpnt FROM status WHERE (UNIX_TIMESTAMP() - $ALIVE_LIMIT > alive);" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)" #"

    for C_MNTPNT in $C_MNTPNTLIST; do

	# TEST FOR NETWORK LOAD
	NETLOAD=$(./get_nload.sh /host/sys $CIF $CIF_SPEED rx)
	test "x$NETLOAD" == "x" && sleep 10 && break
	test $NETLOAD -gt $MAXNETLOAD && sleep 10 && break

	# TEST FOR CPU LOAD
	NOCMAX=3;NOC=0
	while true; do
	    CPULOAD=$(./get_cpuload.sh /host/proc)
	    test "x$CPULOAD" == "x" && sleep 10 && break 3
	    test $CPULOAD -gt $MAXCPULOAD && echo "$CPULOAD vs $MAXCPULOAD" >> /CPU
	    test $CPULOAD -gt $MAXCPULOAD && sleep 10 && break 3
	    ((NOC++))
	    test $NOC -ge $NOCMAX && break
	done
	
	echo "$ALIVE_LIMIT" | grep '\.' > /dev/null || ALIVE_LIMIT="${ALIVE_LIMIT}.0"

	sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -d -- $C_MNTPNT $DB_HOST $DB_PORT $DB_PASS $ALIVE_LIMIT
	sleep 6
    done 
    sleep 1
done

exit $?

# AXXEL.NET
# 2019AUG06
# END
