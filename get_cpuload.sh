#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)

PROCDIR="$1"
test -r "$PROCDIR" || PROCDIR="/proc"
PROCSTAT="$PROCDIR/stat"

PREV_TOTAL=0
PREV_IDLE=0
RCNT=0
while true; do
    # Get the total CPU statistics, discarding the 'cpu ' prefix.
    CPU=(`sed -n 's/^cpu\s//p' $PROCSTAT`)
    IDLE=${CPU[3]} # Just the idle CPU time.

    # Calculate the total CPU time.
    TOTAL=0
    for VALUE in "${CPU[@]}"; do
	let "TOTAL=$TOTAL+$VALUE"
    done

    # Calculate the CPU usage since we last checked.
    let "DIFF_IDLE=$IDLE-$PREV_IDLE"
    let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
    let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
#    test $RCNT -ne 0 && echo -en "\rCPU: $DIFF_USAGE%  \b\b"
    test $RCNT -ne 0 && echo "$DIFF_USAGE"
#    echo "$DIFF_USAGE"

    # Remember the total and idle CPU times for the next check.
    PREV_TOTAL="$TOTAL"
    PREV_IDLE="$IDLE"

    # Wait before checking again.

    test $RCNT -gt 0 && exit 0 || ((RCNT++))
    sleep 1
done
