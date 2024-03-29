#!/bin/bash

TMPDIR=/tmp/platform-monitoring-$RANDOM
mkdir --parents $TMPDIR/final

PARCHDIR=$(pcp | grep "pmlogger: primary logger: " | cut --characters=28- | sed "s/\(.*\)\/.*\/.*/\1/")
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
        | grep --invert-match '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none,none,none,none,none/none,none,%,%,%,%/' \
        > $TMPDIR/final/cpu_general.csv
}

# Multi-CPU busy rates
multi_cpu_busy () {
    RAWCSV=$TMPDIR/multi_cpu_raw.csv
    FINALCSV=$TMPDIR/final/multi_cpu.csv
    $PCMD kernel.percpu.cpu.idle \
        | grep --invert-match '?' \
        | tail --lines=+3 \
        > $RAWCSV

    echo "Date,Time,CPU#,Busy" > $FINALCSV
    echo "none,none,none,%" >> $FINALCSV

    for ((CPU=0; CPU<$NPROC; CPU++))
    do 
        PRINCOL=$((3+$CPU))
        awk --field-separator , '{ printf "%s,%s,\x27cpu'"$CPU"'\x27,%.2f\n", $1, $2, \
        (1000-$'"$PRINCOL"')/10 }' $RAWCSV >> $FINALCSV
    done
}

# Load averages
load_average () {
    # TODO add a column comparing to $NPROC
    $PCMD kernel.all.load \
        | grep --invert-match '?' \
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
        | grep --invert-match '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' \
        > $TMPDIR/final/memory.csv
}


# Disk Free 
disk_free () {
    RAWCSV=$TMPDIR/diskfree_raw.csv
    FINALCSV=$TMPDIR/final/diskfree.csv
    
    # Generate raw data
    $PCMD \
        filesys.capacity \
        filesys.free \
        filesys.avail \
        filesys.full \
        | grep --invert-match '?' \
        > $RAWCSV

    # Add headers and units to the ultimate output file
    echo "Date,Time,Device,Capacity,Free,Available,Full" > $FINALCSV
    echo "none,none,none,Kbyte,Kbyte,Kbyte,%" >> $FINALCSV

    # Get count of devices from raw data
    NUMDISK=$(head --lines=1 $RAWCSV | sed 's/\,/\n/g' | grep "filesys.capacity" | awk --field-separator \" '{ print $2 }' | awk '!x[$0]++' | wc -l)
    #echo "Debug: NUMDISK=$NUMDISK"

    # Get list of devices from raw data
    LISTDISK=$(head --lines=1 $RAWCSV | sed 's/\,/\n/g' | grep "filesys.capacity" | awk --field-separator \" '{ print $2 }' | awk '!x[$0]++' )
    #echo "Debug: LISTDISK=$LISTDISK"
    
    
    # For every disk
    DSKN=0
    for DSK in $LISTDISK
    do
        #echo "Debug: $DSKN:$DSK"
        CAPCOL=$((3+$DSKN))
        FREECOL=$(($CAPCOL+$NUMDISK))
        AVLCOL=$(($FREECOL+$NUMDISK))
        FULLCOL=$(($AVLCOL+$NUMDISK))            
        tail --lines=+3 $RAWCSV \
            | awk --field-separator , '{ printf "%s,%s,\x27'"$DSK"'\x27,%d,%d,%d,%.2f\n", $1, $2, \
            $'$CAPCOL', $'$FREECOL', $'$AVLCOL', $'$FULLCOL'}' \
            >> $FINALCSV
        DSKN=$(($DSKN+1))
    done    
    # TODO: Collect and put "mountdir" entries to the rows too
}

# I/O Rate stats
io_rate_stats () {
    # Overall I/O rates
    $PCMD \
        disk.all.read \
        disk.all.write \
        disk.all.read_bytes \
        disk.all.write_bytes \
        | grep --invert-match '?' \
        | sed 's/^Time/Date,Time/' \
        | sed 's/^none/none,none/' \
        > $TMPDIR/final/io_rates_overall.csv

    # Per-device I/O rates
    RAWCSV=$TMPDIR/io_rates_perdevice_raw.csv
    FINALCSV=$TMPDIR/final/io_rates_perdevice.csv

    # Generate raw data 
    # (some devices might not haw avg_qlen and util - but we need the lines for other devices)
    # Therefore we only grep --invert-match with heading ?,?.... for read/write columns
    $PCMD \
        disk.dev.read \
        disk.dev.write \
        disk.dev.read_bytes \
        disk.dev.write_bytes \
        disk.dev.avg_qlen \
        disk.dev.util \
        | grep --invert-match ':00,?,?,?,?,?,?' \
        > $RAWCSV
    
    # Add headers and units to the ultimate output file
    echo "Date,Time,Device,read,write,read_bytes,write_bytes,avg_qlen,util" > $FINALCSV
    echo "none,none,none,count / second,count / second,Kbyte / second,Kbyte / second,none,%" >> $FINALCSV

    # Get count of devices from raw data
    NUMDEV=$(head --lines=1 $RAWCSV | sed 's/\,/\n/g' | grep "disk.dev.read" | awk --field-separator \" '{ print $2 }' | awk '!x[$0]++' | wc -l)
    #echo "Debug: NUMDEV=$NUMDEV"

    # Get list of devices from raw data
    LISTDEV=$(head --lines=1 $RAWCSV | sed 's/\,/\n/g' | grep "disk.dev.read" | awk --field-separator \" '{ print $2 }' | awk '!x[$0]++' )
    #echo "Debug: LISTDEV=$LISTDEV"
       
    # For every disk device
    DEVN=0
    for DEV in $LISTDEV
    do
        #echo "Debug: $DEVN:$DEV"
        RDCOL=$((3+$DEVN))
        WRTCOL=$(($RDCOL+$NUMDEV))
        RDBCOL=$(($WRTCOL+$NUMDEV))
        WRBCOL=$(($RDBCOL+$NUMDEV))
        AQLCOL=$(($WRBCOL+$NUMDEV))
        UTLCOL=$(($AQLCOL+$NUMDEV))
        tail --lines=+3 $RAWCSV \
            | awk --field-separator , '{ printf "%s,%s,\x27'"$DEV"'\x27,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n", $1, $2, \
            $'$RDCOL', $'$WRTCOL', $'$RDBCOL', $'$WRBCOL', $'$AQLCOL', $'$UTLCOL'}' \
            >> $FINALCSV
        DEVN=$(($DEVN+1))
    done
}

# Network stats
# This requires the network.interface stats enabled on Ubuntu.
network_stats () {
    # Bandwidth usage
    RAWBAND=$TMPDIR/network_bandwidth_usage_raw.csv
    FINALBAND=$TMPDIR/final/network_bandwidth_usage.csv
    $PCMD \
        network.interface.in.bytes \
        network.interface.out.bytes \
        network.interface.total.bytes \
        | grep --invert-match ':00,?,?,?' \
        > $RAWBAND

    # Add headers and units to the ultimate output file
    echo "Date,Time,Interface,in,out,total" > $FINALBAND
    echo "none,none,none,byte / second,byte / second,byte / second,byte / second" >> $FINALBAND

    # Get count of NICs from raw data
    NUMNIC=$(head --lines=1 $RAWBAND | sed 's/\,/\n/g' | grep "network.interface.in.bytes" | awk --field-separator \" '{ print $2 }' | awk '!x[$0]++' | wc -l)
    #echo "Debug: NUMNIC=$NUMNIC"

    # Get list of NICs from raw data
    LISTNIC=$(head --lines=1 $RAWBAND | sed 's/\,/\n/g' | grep "network.interface.in.bytes" | awk --field-separator \" '{ print $2 }' | awk '!x[$0]++' )
    #echo "Debug: LISTNIC=$LISTNIC"
       
    # For every NIC
    NICN=0
    for NIC in $LISTNIC
    do
        #echo "Debug: $NICN:$NIC"
        INBCOL=$((3+$NICN))
        OUTBCOL=$(($INBCOL+$NUMNIC))
        TOTBCOL=$(($OUTBCOL+$NUMNIC))
        tail --lines=+3 $RAWBAND \
            | awk --field-separator , '{ printf "%s,%s,\x27'"$NIC"'\x27,%.2f,%.2f,%.2f\n", $1, $2, \
            $'$INBCOL', $'$OUTBCOL', $'$TOTBCOL'}' \
            >> $FINALBAND
        NICN=$(($NICN+1))
    done

    # Error stats
    RAWERR=$TMPDIR/network_error_rates_raw.csv
    FINALERR=$TMPDIR/final/network_error_rates.csv
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
        | grep --invert-match ':00,?,?,?,?,?,?' \
        > $RAWERR

    # Add headers and units to the ultimate output file
    echo "Date,Time,Interface,InPackets,InErrors,InDrops,OutPackets,OutErrors,OutDrops,TotalPackets,TotalErrors,TotalDrops" > $FINALERR
    echo "none,none,none,count / second,count / second,count / second,count / second,count / second,count / second,count / second,count / second,count / second" >> $FINALERR
       
    # For every NIC
    NICN=0
    for NIC in $LISTNIC
    do
        #echo "Debug: $NICN:$NIC"
        INPCOL=$((3+$NICN))
        INECOL=$(($INPCOL+$NUMNIC))
        INDCOL=$(($INECOL+$NUMNIC))
        OUTPCOL=$(($INDCOL+$NUMNIC))
        OUTECOL=$(($OUTPCOL+$NUMNIC))
        OUTDCOL=$(($OUTECOL+$NUMNIC))
        TOTPCOL=$(($OUTDCOL+$NUMNIC))
        TOTECOL=$(($TOTPCOL+$NUMNIC))
        TOTDCOL=$(($TOTECOL+$NUMNIC))
        tail --lines=+3 $RAWERR \
            | awk --field-separator , '{ printf "%s,%s,\x27'"$NIC"'\x27,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n", $1, $2, \
            $'$INPCOL', $'$INECOL', $'$INDCOL', \
            $'$OUTPCOL', $'$OUTECOL', $'$OUTDCOL', \
            $'$TOTPCOL', $'$TOTECOL', $'$TOTDCOL'}' \
            >> $FINALERR
        NICN=$(($NICN+1))
    done
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
#disk_free
#io_rate_stats
network_stats
