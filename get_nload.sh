#!/bin/bash
SYSDIR="$1"
test -r "$SYSDIR" || SYSDIR="/sys"
SYSCLASSNET="$SYSDIR/class/net"

if [ $# -lt 4 ]; then
    echo "This script returns intrfaces rx or tx transmission load in percent."
    echo "Usage:   $(basename $0) SYSDIR INTERFACE INTERFACESPEED RXTX"
    echo "Example: $(basename $0) /sys ens3 1000 rx"
    if [ -r "$SYSCLASSNET" ]; then 
	echo "Available interfaces: $(ls $SYSCLASSNET | tr '\n' '\ ')"
    fi
    exit 1
fi
IF="$2"
IFSPEED="$3"
RXTX="$4"

echo $IFSPEED

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

while true; do
    START_BYTES=$(cat $BYTEFILE)
    sleep 1
    STOP_BYTES=$(cat $BYTEFILE)
    DIFF_BYTES=$(( $STOP_BYTES - $START_BYTES ))
    test $DIFF_BYTES -ge 0 && break
done

MAX_BITS=$(($IFSPEED * 1000000))
let CUR_BITS=$DIFF_BYTES*8
let PERC=$CUR_BITS*100/$MAX_BITS

echo "$PERC"
exit $?

#END
