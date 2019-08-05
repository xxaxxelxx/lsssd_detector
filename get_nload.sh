#!/bin/bash
SYSDIR="$1"
test -r "$SYSDIR" || SYSDIR="/sys"
SYSCLASSNET="$SYSDIR/class/net"

if [ $# -lt 3 ]; then
    echo "This script returns intrfaces rx or tx transmission load in percent."
    echo "Usage:   $(basename $0) SYSDIR INTERFACE RXTX [ MAXMBIT ]"
    echo "Example: $(basename $0) /sys ens3 rx [ 1000 ]"
    if [ -r "$SYSCLASSNET" ]; then 
	echo "Available interfaces: $(ls $SYSCLASSNET | tr '\n' '\ ')"
    fi
    exit 1
fi
IF="$2"
RXTX="$3"
MAXMBITARG="$4"

if [ ! -r "${SYSCLASSNET}/${IF}" ]; then
    echo "There is no interface like $IF."
    echo "Available interfaces: $(ls $SYSCLASSNET | tr '\n' '\ ')"
    exit 1
fi

BYTEFILE="${SYSCLASSNET}/${IF}/statistics/$(echo "$RXTX" | tr [:upper:] [:lower:])_bytes"
if [ ! -r "$BYTEFILE" ]; then
    echo "There is no transmission type like $RXTX. Select rx or tx."
    exit 1
fi

SPEEDFILE="${SYSCLASSNET}/${IF}/speed"
test -r "$SPEEDFILE" && test $(cat "$SPEEDFILE") -gt 0 && MAXMBIT=$(cat "$SPEEDFILE")
if [ "x$MAXMBIT" == "x" ]; then
    if [ "x$MAXMBITARG" == "x" ]; then
	echo "Cannot detect the maximum $RXTX of $IF. Please set MAXMBIT as an argument."
	echo "Usage:  $(basename $0) SYSDIR INTERFACE RXTX [ MAXMBIT ]"
	exit
    else
	MAXMBIT=$MAXMBITARG
    fi
else
    if [ "x$MAXMBITARG" != "x" -a "x$MAXMBITARG" != "x$MAXMBIT" ]; then
	echo "You had have set MAXMBIT as $MAXMBITARG. Automatic detection returns $MAXMBIT."
	exit
    fi
fi

while true; do
    START_BYTES=$(cat $BYTEFILE)
    sleep 1
    STOP_BYTES=$(cat $BYTEFILE)
    DIFF_BYTES=$(( $STOP_BYTES - $START_BYTES ))
    test $DIFF_BYTES -ge 0 && break
done

MAX_BITS=$(($MAXMBIT * 1000000))
let CUR_BITS=$DIFF_BYTES*8
let PERC=$CUR_BITS*100/$MAX_BITS

echo "$PERC"
exit $?

#END
