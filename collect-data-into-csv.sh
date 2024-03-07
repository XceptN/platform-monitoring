#!/bin/bash

TMPDIR=/tmp/$RANDOM

mkdir $TMPDIR

PARCHDIR=$(pcp | grep "pmlogger: primary logger: " | cut -c 28- | sed "s/\(.*\)$HOSTNAME.*/\1/")
PSTART='yesterday'
PINTERVAL='1hour'
PHOST=$HOSTNAME
PALIGN='1day'
PTIMEFMT='%Y-%m-%d,%H:%M'
PCMDPRE="pmdumptext --start=$PSTART --interval=$PINTERVAL --archive=$PHOST --align=$PALIGN --metrics --unit --delimiter=, --time-format=$PTIMEFMT"

cd $PARCHDIR

# CPU General
$PCMDPRE \
    kernel.cpu.util.user \
    kernel.cpu.util.sys \
    kernel.cpu.util.wait \
    kernel.cpu.util.idle \
    | sed 's/^Time/Date,Time/' \
    | sed 's/none,none,none,none,none/none,none,%,%,%,%/' \
    > $TMPDIR/cpu_general.csv
# Maybe also do something about ?,?,?,?

