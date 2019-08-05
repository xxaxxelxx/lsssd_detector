#!/bin/bash
test  $# -lt 4 && \
    echo "usage:     $(basename $0) DB_HOST DB_PORT DB_PASS MYIPADDR" && \
    echo "example:   $(basename $0) 192.168.99.99 3306 trallala 192.168.99.98" && \
    exit 1

DB_HOST=$1
test "x$DB_HOST" == "x" && exit 1

DB_PORT=$2
test "x$DB_PORT" == "x" && exit 1

DB_PASS=$3
test "x$DB_PASS" == "x" && exit 1

MYIPADDR=$4
test "x$MYIPADDR" == "x" && exit 1

while true; do
#get time from master via db
    TIME=$(echo "SELECT confvalue  FROM config WHERE confkey = 'DETECTORHOST_TELEMETRY_ALIVE_SECONDS_LIMIT';" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB --skip-column-names)

    date > /tmp/zzz
    sleep 1
    #/usr/bin/top -n 2  > /tmp/zzz
    #/usr/bin/top -n 2 | grep -i '%CPU' >> /tmp/zzz
    #/usr/bin/top -n 2 | grep -i '%CPU' | head -n 1 >> /tmp/zzz
    #/usr/bin/top -n 2 | grep -i '%CPU' | head -n 1 | awk '{print $8}' >> /tmp/zzz
    
#    CPUIDLE="$(top -n $TIME | grep -i '%CPU' | head -n 1 | awk '{print $8}' | sed 's/^\./0./' | sed 's|\..*||')"
#    echo $CPUIDLE >> /tmp/zzz
#CPUIDLE=$RANDOM
#    echo "INSERT INTO detectorload (ipaddr, alive, cpuidle, nload) VALUES ('$MYIPADDR', UNIX_TIMESTAMP(), $CPUIDLE, 0) ON DUPLICATE KEY UPDATE ipaddr='$MYIPADDR',alive=UNIX_TIMESTAMP(),cpuidle=$CPUIDLE;" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB 
#    echo "INSERT INTO detectorload (ipaddr, alive, cpuidle, nload) VALUES ('$MYIPADDR', 1111, $CPUIDLE, 0) ON DUPLICATE KEY UPDATE ipaddr='$MYIPADDR',alive='1111',cpuidle=$CPUIDLE;" | mysql -u detector -p$DB_PASS -h $DB_HOST -P $DB_PORT -D silenceDB 
done

exit $?

#END