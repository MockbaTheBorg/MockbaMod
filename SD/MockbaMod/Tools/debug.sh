#!/bin/sh

# This script records debug information for troubkeshooting

#
# ########## ONLY RUN THIS SCRIPT IF REQUESTED BY SUPPORT
# ########## AND BY STRICTLY FOLLOWING SUPPORT'S GUIDANCE STEPS
#

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

echo "******* Mockba Mod Debug **********" > $mmPath/debug.txt

echo "***** Overlays listing ****" >> $mmPath/debug.txt
cat /proc/mounts | grep overlay >> $mmPath/debug.txt

echo "******** Generating usr lib Overlay Directory Tree ********"
echo "******** /media/az01-internal/system/usr/overlay/lib Tree ********" >> $mmPath/debug.txt
find /media/az01-internal/system/usr/overlay/lib -type d  -exec echo "Directory: {}" \; -exec ls -al {} \; >> $mmPath/debug.txt

echo "******** Generating /media/662522 Directory Tree ********"
echo "******** /media/662522 Tree ********" >> $mmPath/debug.txt
find $mmPath -type d  -exec echo "Directory: {}" \; -exec ls -al {} \; >> $mmPath/debug.txt

echo "******** Collecting aconnect -l output ********"
echo "******** aconnect -l output ********" >> $mmPath/debug.txt
aconnect -l >> $mmPath/debug.txt

echo "******** Collecting GPU Information ********"
echo "******** GPU Information ********" >> $mmPath/debug.txt
cat /sys/devices/platform/ffa30000.gpu/gpuinfo >> $mmPath/debug.txt

echo "<<<< $mmPath/debug.txt generated, share as required! >>>>"
