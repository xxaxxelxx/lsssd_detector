#!/bin/bash
set -ex
#set -x

echo "$1" | grep -i '^exit' > /dev/null && exit 0

while true; do
    ./detectorrunner.sh $DETECTORHOST_IF $DETECTORHOST_IF_MAXLOAD_PERCENT $DETECTORHOST_MAXCPULOAD_PERCENT $MYSQL_HOST $MYSQL_PORT $MYSQL_DETECTOR_PASSWORD $ALIVE_LIMIT
    sleep 1
done
exit $?
