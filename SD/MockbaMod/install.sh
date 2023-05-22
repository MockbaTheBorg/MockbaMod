#!/bin/sh

# Part of Mockba Mod, do not modify

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

if test -f /etc/mockba_mod_installed; then
	echo "Already installed..." >> $mmLogs/boot.log
else
	echo "Installing..." >> $mmLogs/boot.log
	set_pad 08 05 00 00
	display $mmImages/installing.png
	sleep .5
	cp -a $mmFiles/shadow /media/az01-internal/system/etc/overlay/
	sleep .5
	set_pad 08 20 00 00
	set_pad 09 05 00 00

	mkdir -p /media/az01-internal/system/etc/overlay/ssh
	cp -a $mmFiles/sshd_config /media/az01-internal/system/etc/overlay/ssh/
	sleep .5
	set_pad 09 20 00 00
	set_pad 0a 05 00 00

	ln -sf /tmp/usr/lib/libmali.so.14.0.$mmGPU /tmp/usr/lib/libmali.so.14.0
	sleep .5
	set_pad 0a 20 00 00
	set_pad 0b 05 00 00

	touch $mm/automount
	sleep .5
	set_pad 0b 20 00 00
	
	touch /etc/mockba_mod_installed
	display $mmImages/rebooting.png
	clear_pads
	sleep 1

	reboot
fi
