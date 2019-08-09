#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)

PROCDIR="$1"
test -r "$PROCDIR" || PROCDIR="/proc"
PROCMEM="$PROCDIR/meminfo"
MEMMINLIMIT="100000"

#cat $PROCMEM
test -r "$PROCMEM" || exit 2
MEMAVAIL="$(cat $PROCMEM | grep 'MemAvailable:' | awk '{print $2}')"

test $MEMAVAIL -lt $MEMMINLIMIT && exit 1
exit 0
