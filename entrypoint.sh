#!/bin/bash
set -ex
#set -x

echo "$1" | grep -i '^exit' > /dev/null && exit 0

while true; do
    ./cpuidlereporter.sh $MYSQL_HOST $MYSQL_PORT $MYSQL_DETECTOR_PASSWORD $DETECTORHOST_IP
    sleep 1
done
exit $?
