#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)

PROCDIR="$1"
test -r "$PROCDIR" || PROCDIR="/proc"
PROCMEM="$PROCDIR/meminfo"
MEMMINLIMIT="1000000"

#cat $PROCMEM
test -r "$PROCMEM" || exit 2
MEMAVAIL="$(cat $PROCMEM | grep 'Inactive:' | awk '{print $2}')"

test $MEMAVAIL -lt $MEMMINLIMIT && exit 1
exit 0
