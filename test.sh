#!/bin/bash

./detectorrunner.sh ens3 50 50 192.168.100.124 63306 rfc1830 10.0
#./detectorrunner.sh $DETECTORHOST_IF $DETECTORHOST_IF_MAXLOAD_PERCENT $DETECTORHOST_MAXCPULOAD_PERCENT $MYSQL_HOST $MYSQL_PORT $MYSQL_DETECTOR_PASSWORD $ALIVE_LIMIT

#sudo -u liquidsoap liquidsoap /etc/liquidsoap/sd.liq -- http://broadcast.ir-media-tec.com/bbradio-ch08.mp3 192.168.100.124 63306 rfc1830 10.0

exit

#END