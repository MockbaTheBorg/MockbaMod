#!/bin/sh

# This script sets the r1p1 library for those with different GPU

#
# ########## ONLY RUN THIS SCRIPT IF REQUESTED BY SUPPORT
# ########## AND BY STRICTLY FOLLOWING SUPPORT'S GUIDANCE STEPS
#

# Set the initial execution path
cd "$(dirname "$0")"
echo $(pwd) > /dev/shm/.mmPath

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

set_pad 00 20 20 00
set_pad 01 05 05 00
mv -f /media/az01-internal/system/usr/overlay/lib/libmali.so.14.0 /media/az01-internal/system/usr/overlay/lib/libmali.so.14.0.r0p0
sleep .5
set_pad 01 20 20 00
set_pad 02 05 05 00
mv -f /media/az01-internal/system/usr/overlay/lib/libmali.so.14.0.r1p0 /media/az01-internal/system/usr/overlay/lib/libmali.so.14.0
sleep .5
set_pad 02 20 20 00
set_pad 03 05 05 00
if [ -f boot_old.sh ]; then
  mv -f boot.sh boot.bak   # remove the existing boot.sh
  mv boot_old.sh boot.sh   # rename boot_old.sh to boot.sh
fi
set_pad 03 20 20 00
shutdown -h now
