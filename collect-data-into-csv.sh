#!/bin/bash

TMPDIR=/tmp/platform-monitoring-$RANDOM
mkdir -p $TMPDIR/final

PARCHDIR=$(pcp | grep "pmlogger: primary logger: " | cut -c 28- | sed "s/\(.*\)\/.*\/.*/\1/")
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
        | tail -n +3 \
        > $TMPDIR/multi_cpu_raw.csv

    echo "Date,Time,CPU#,Busy" > $TMPDIR/final/multi_cpu.csv
    echo "none,none,none,%" >> $TMPDIR/final/multi_cpu.csv

    NUMCOLMN=1 # Number of columns in raw file
    for ((CPU=0; CPU<$NPROC; CPU++))
    do 
        PRINCOL=$((3+$CPU*$NUMCOLMN))
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
        mem.util.pageTables \
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


# Disk Free 
disk_free () {
    $PCMD \
        filesys.capacity \
        filesys.free \
        filesys.avail \
        filesys.full \
        | grep -v '?' \
        > $TMPDIR/diskfree_raw.csv

    echo "Date,Time,Device,Capacity,Free,Available,Full" 
    echo "none,none,none,Kbyte,Kbyte,Kbyte,%" 

    # Get count of devices from raw data
    NUMDISK=$(head -1 $TMPDIR/diskfree_raw.csv | sed 's/\,/\n/g' | grep "filesys.capacity" | awk -F\" '{ print $2 }' | wc -l)
    echo "NUMDISK=$NUMDISK"
    # Get list of devices from raw data
    LISTDISK=$(head -1 $TMPDIR/diskfree_raw.csv | sed 's/\,/\n/g' | grep "filesys.capacity" | awk -F\" '{ print $2 }')
    #echo "LISTDISK=$LISTDISK"
    # Set unique types of data (from first command - 4 types -> MAX=3)
    #NUMTYP=4
    #echo "NUMTYP=$NUMTYP"

    # Disk0: 1,2,DISK,3+TYPE(0)*NUMDISK+NUMDISK(0),3+TYPE(1)*NUMDISK+NUMDISK(0),3+TYPE(2)*NUMDISK+NUMDISK(0)
    # Disk1: 1,2,DISK,3+TYPE(0)*NUMDISK+NUMDISK(1),3+TYPE(1)*NUMDISK+NUMDISK(1),3+TYPE(2)*NUMDISK+NUMDISK(1)
    # Disk1: 1,2,DISK,3+TYPE(0)*NUMDISK+NUMDISK(2),3+TYPE(1)*NUMDISK+NUMDISK(2),3+TYPE(2)*NUMDISK+NUMDISK(2)

    # For every disk
    DSKN=0
    for DSK in $LISTDISK
    do
        echo "$DSKN:$DSK"
        CAPCOL=$((3+$DSKN))
        FREECOL=$(($CAPCOL+$NUMDISK))
        AVLCOL=$(($FREECOL+$NUMDISK))
        FULLCOL=$(($AVLCOL+$NUMDISK))            
        tail -n +3 $TMPDIR/diskfree_raw.csv | head -3 | awk -F, '{ printf "%s,%s,\x27'"$DSK"'\x27,%d,%d,%d,%.2f\n", $1, $2, $'$CAPCOL', $'$FREECOL', $'$AVLCOL', $'$FULLCOL'}' 
        DSKN=$(($DSKN+1))
    done

    
    # TODO: Collect and put "mountdir" entries to the rows too
# Use below for final output
#        > $TMPDIR/final/diskfree.csv
}

# I/O Rate stats
io_rate_stats () {
    # Overall I/O rates
    $PCMD \
        disk.all.read \
        disk.all.write \
        disk.all.read_bytes \
        disk.all.write_bytes \
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' \
        > $TMPDIR/final/io_rates_overall.csv

    # Per-device I/O rates
    $PCMD \
        disk.dev.read \
        disk.dev.write \
        disk.dev.read_bytes \
        disk.dev.write_bytes \
        disk.dev.avg_qlen \
        disk.dev.util \
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' \
        > $TMPDIR/io_rates_perdevice_raw.csv
# Use below for final output
#        > $TMPDIR/final/io_rates_perdevice.csv
}

# Network stats
# This requires the network.interface stats enabled on Ubuntu.
network_stats () {
    # Bandwidth usage
    $PCMD \
        network.interface.in.bytes \
        network.interface.out.bytes \
        network.interface.total.bytes \
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' \
        > $TMPDIR/network_bandwidth_usage_raw.csv
# Use below for final output
#        > $TMPDIR/final/network_bandwidth_usage.csv

    # Error stats
    $PCMD \
        network.interface.in.packets \
        network.interface.in.errors \
        network.interface.in.drops \
        network.interface.out.packets \
        network.interface.out.errors \
        network.interface.out.drops \
        network.interface.total.packets \
        network.interface.total.errors \
        network.interface.total.drops \
        | grep -v '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' \
        > $TMPDIR/network_error_rates_raw.csv
# Use below for final output
#        > $TMPDIR/final/network_error_rates.csv
}

###############################################
# Main
###############################################
cd $PARCHDIR

# Call modules
#cpu_general
#multi_cpu_busy
#load_average
#virtual_memory
disk_free
#io_rate_stats
#network_stats
