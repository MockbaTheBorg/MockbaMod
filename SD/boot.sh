#!/bin/sh

# This script fully removes Mockba Mod from the Force

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

if [ -f "$mmPath/emmc-repair.sh" ]; then
	mv "$mmPath/emmc-repair.sh" /tmp/
	chmod +x /tmp/emmc-repair.sh
	/tmp/emmc-repair.sh > "$mmLogs/emmc.log"
fi

set_pad 00 05 00 00
display $mmImages/removing.png
set_pad 00 20 00 00
set_pad 01 05 00 00
rm -f /media/az01-internal/system/etc/overlay/hosts > $mmLogs/remove.log 2>&1
sleep .5
set_pad 01 20 00 00
set_pad 02 05 00 00
rm -f /media/az01-internal/system/etc/overlay/shadow >> $mmLogs/remove.log 2>&1
sleep .5
set_pad 02 20 00 00
set_pad 03 05 00 00
rm -rf /media/az01-internal/system/etc/overlay/ssh >> $mmLogs/remove.log 2>&1
sleep .5
set_pad 03 20 00 00
set_pad 04 05 00 00
rm -rf /media/az01-internal/system/usr >> $mmLogs/remove.log 2>&1
sleep .5
set_pad 04 20 00 00
set_pad 05 05 00 00
rm -f /media/az01-internal/system/etc/overlay/mockba_mod_installed >> $mmLogs/remove.log 2>&1
sleep .5
set_pad 05 20 00 00
set_pad 06 05 00 00
if [ -f boot_old.sh ]; then
	rm -f boot.sh             # remove the existing boot.sh
	mv -f boot_old.sh boot.sh # rename boot_old.sh to boot.sh
fi
set_pad 06 20 00 00
display $mmImages/poweroff.png
clear_pads
shutdown -h now
