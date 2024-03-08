#!/bin/bash

TMPDIR=/tmp/$RANDOM

mkdir -p $TMPDIR/final

#PARCHDIR=$(pcp | grep "pmlogger: primary logger: " | cut -c 28- | sed "s/\(.*\)$HOSTNAME.*/\1/")
PARCHDIR='/var/log/pcp/pmlogger'
PSTART='yesterday'
PINTERVAL='1hour'
PHOST=$HOSTNAME
PALIGN='1day'
PTIMEFMT='%Y-%m-%d,%H:%M'
PCMD="pmdumptext --start=$PSTART --interval=$PINTERVAL --archive=$PHOST --align=$PALIGN --metrics --unit --delimiter=, --time-format=$PTIMEFMT"
NPROC=$(nproc)

# General CPU usage
cpu_general () {
    $PCMD \
        kernel.cpu.util.user \
        kernel.cpu.util.sys \
        kernel.cpu.util.wait \
        kernel.cpu.util.idle \
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none,none,none,none,none/none,none,%,%,%,%/' \
        > $TMPDIR/final/cpu_general.csv
}

# Multi-CPU busy rates
multi_cpu_busy () {
    $PCMD kernel.percpu.cpu.idle \
        | grep -v '?' \
        | tail +3 \
        > $TMPDIR/multi_cpu_raw.csv

    echo "Date,Time,CPU#,Busy" > $TMPDIR/final/multi_cpu.csv
    echo "none,none,none,%" >> $TMPDIR/final/multi_cpu.csv

    for ((CPU=0; CPU<$NPROC; CPU++))
    do 
        PRINCOL=$((3+$CPU*1))
        echo "CPU=$CPU"
        echo "PRINCOL=$PRINCOL"
        awk -F, '{ printf "%s,%s,\x27cpu'"$CPU"'\x27,%.2f\n", $1, $2, (1000-$'"$PRINCOL"')/10 }' $TMPDIR/multi_cpu_raw.csv >> $TMPDIR/final/multi_cpu.csv
    done
}

# Load averages
load_average () {
    # TODO add a column comparing to $NPROC
    $PCMD kernel.all.load \
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        > $TMPDIR/final/loadavg.csv
}

# Virtual memory stats
virtual_memory () {
    $PCMD \
        mem.physmem \
        mem.util.free \
        mem.util.available \
        em.util.pageTables \
        mem.util.bufmem \
        mem.util.cached \
        mem.util.slab \
        mem.util.swapTotal \
        mem.util.swapFree \
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' \
        > $TMPDIR/final/memory.csv
}


# Disk Free - for whatever reason - this fails on my laptop - while it works on ocitest01
disk_free () {
    # TODO - convert this into a per-FS layout having FS as a column
    $PCMD \
        filesys.free \
        filesys.freefiles \ 
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' 
        > $TMPDIR/final/diskfree.csv
}



# I/O Rate stats


# Network stats

# Main
cd $PARCHDIR

# Call modules
#cpu_general
#multi_cpu_busy
#load_average
#virtual_memory
#disk_free

# I/O Rate stats


# Network stats
