#!/bin/bash
HOME="/usr/local/homegrown/liquidsilence"
test -d "$HOME" || exit 1
cd "$HOME"

test  $# -lt 9 && \
    echo "usage:   $(basename $0) INTERFACE MAXNLOADPERCENT MINCPUIDLEPERCENT DB_HOST DB_PORT DB_PASS INNERLOOP OUTERLOOP ALIVELIMIT" && \
    echo "example: $(basename $0) ens3 50 30 192.168.99.99 3306 trallala 3 10 15" && \
    exit 1

CIF=$1
test "x$CIF" == "x" && exit 1

MAXNLOAD=$2
test "x$MAXNLOAD" == "x" && exit 1

MINCPUIDLE=$3
test "x$MINCPUIDLE" == "x" && exit 1

DB_HOST=$4
test "x$DB_HOST" == "x" && exit 1

DB_PORT=$5
test "x$DB_PORT" == "x" && exit 1

DB_PASS=$6
test "x$DB_PASS" == "x" && exit 1

LOOPA=$7
test "x$LOOPA" == "x" && exit 1

LOOPB=$8
test "x$LOOPB" == "x" && exit 1

MAXALIVE=$9
test "x$MAXALIVE" == "x" && exit 1

IPADDR="$(ip -f inet addr show $CIF | awk '/inet / {print $2}' | sed 's|\/.*||')"
test "x$IPADDR" == "x" && exit 1


while true; do
    # TELEMETRY
    C_ALIVE="$(echo "SELECT alive FROM detectorload WHERE ipaddr='$IPADDR' ORDER BY alive DESC LIMIT 1;" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)"
    if [  "x$C_ALIVE" == "x" ]; then
	if [ $LOOPB -eq 0  ]; then exit $?; else sleep $LOOPB; continue; fi
    fi
    if [  $C_ALIVE -lt $(( $(date "+%s") - $MAXALIVE )) ]; then 
	if [ $LOOPB -eq 0  ]; then exit $?; else sleep $LOOPB; continue; fi
    fi

    C_NLOAD="$(echo "SELECT nload FROM detectorload WHERE ipaddr='$IPADDR' ORDER BY alive DESC LIMIT 1;" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)"
    if [  "x$C_NLOAD" == "x" ]; then
	if [ $LOOPB -eq 0  ]; then exit $?; else sleep $LOOPB; continue; fi
    fi
    if [ $C_NLOAD -gt $MAXNLOAD ]; then
	if [ $LOOPB -eq 0  ]; then exit $?; else sleep $LOOPB; continue; fi
    fi

    C_CPUIDLE="$(echo "SELECT cpuidle FROM detectorload WHERE ipaddr='$IPADDR' ORDER BY alive DESC LIMIT 1;" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)"
    if [  "x$C_CPUIDLE" == "x" ]; then
	if [ $LOOPB -eq 0  ]; then exit $?; else sleep $LOOPB; continue; fi
    fi
    if [ $C_CPUIDLE -lt $MINCPUIDLE ]; then
	if [ $LOOPB -eq 0  ]; then exit $?; else sleep $LOOPB; continue; fi
    fi

    # STARTUP
    C_MNTPNTLIST="$(echo "SELECT mntpnt FROM status WHERE (UNIX_TIMESTAMP() - $MAXALIVE > alive);" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)" #"

    for C_MNTPNT in $C_MNTPNTLIST; do
	test -d "/var/run/liquidsoap" || (mkdir -p "/var/run/liquidsoap" && chown liquidsoap "/var/run/liquidsoap")
	sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -d -- $C_MNTPNT $DB_HOST $DB_PORT $DB_PASS && echo "$C_MNTPNT started"
	sleep $LOOPA
    done 

    #date

    test $LOOPB -eq 0 && exit $? || sleep $LOOPB
done

exit $?

#while true; do sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -- http://broadcast.ir-media-tec.com/bbradio-ch08.mp3 192.168.100.123 3306 rfc1830; done
#while true; do sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -- http://ir-media.hoerradar.de/bbradio-xmas-mp3-hq 192.168.100.123 3306 rfc1830; done

#END