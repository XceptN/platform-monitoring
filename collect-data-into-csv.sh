#!/bin/bash

TMPDIR=/tmp/$RANDOM

mkdir -p $TMPDIR/final

#PARCHDIR=$(pcp | grep "pmlogger: primary logger: " | cut -c 28- | sed "s/\(.*\)$HOSTNAME.*/\1/"`
PARCHDIR='/var/log/pcp/pmlogger'
PSTART='yesterday'
PINTERVAL='1hour'
PHOST=$HOSTNAME
PALIGN='1day'
PTIMEFMT='%Y-%m-%d,%H:%M'
PCMD="pmdumptext --start=$PSTART --interval=$PINTERVAL --archive=$PHOST --align=$PALIGN --metrics --unit --delimiter=, --time-format=$PTIMEFMT"

cd $PARCHDIR

# CPU General
#$PCMD \
#    kernel.cpu.util.user \
#    kernel.cpu.util.sys \
#    kernel.cpu.util.wait \
#    kernel.cpu.util.idle \
#    | grep -v '?' \
#    | sed 's/^Time/Date,Time/' \
#    | sed 's/^none,none,none,none,none/none,none,%,%,%,%/' \
#    > $TMPDIR/final/cpu_general.csv

# Multi CPU Busy
NPROC=$(nproc)
#$PCMD kernel.percpu.cpu.idle \
#    | grep -v '?' \
#    | tail +3 \
#    > $TMPDIR/multi_cpu_raw.csv

#echo "Date,Time,CPU#,Busy" > $TMPDIR/final/multi_cpu.csv
#echo "none,none,none,%" >> $TMPDIR/final/multi_cpu.csv

#for ((CPU=0; CPU<$NPROC; CPU++))
#do 
#    PRINCOL=$((3+$CPU*1))
##    echo "CPU=$CPU"
##    echo "PRINCOL=$PRINCOL"
#    awk -F, '{ printf "%s,%s,\x27cpu'"$CPU"'\x27,%.2f\n", $1, $2, (1000-$'"$PRINCOL"')/10 }' $TMPDIR/multi_cpu_raw.csv >> $TMPDIR/final/multi_cpu.csv
#done

# Load average
$PCMD kernel.all.load \
    | grep -v '?' \
    | sed 's/^Time/Date,Time/' \
    > $TMPDIR/final/loadavg.csv

# Virtual Memory Stats


# Disk spaces


# I/O Rate stats


# Network stats