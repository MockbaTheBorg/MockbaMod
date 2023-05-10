#!/bin/sh

# Part of Mockba Mod, do not modify

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

if test -f $mm/automount; then
	echo "Mounting Writable /usr via OverlayFS..."
	mkdir -p /media/az01-internal/system/usr/
	mkdir -p /media/az01-internal/system/usr/overlay/
	mkdir -p /media/az01-internal/system/usr/.work/
	mkdir -p /tmp/usr
	if ! mount | grep -q "/tmp/usr"; then
		mount -o loop $mmFiles/usr.img /tmp/usr
	fi
	sleep .5
	mount -t overlay -o rw,relatime,lowerdir=/tmp/usr:/usr,upperdir=/media/az01-internal/system/usr/overlay,workdir=/media/az01-internal/system/usr/.work overlay /usr
	if ! mount | grep -q "overlay on /usr"; then
		echo "OverlayFS mounting failed!"
	fi
else
	echo "Overlay not mounted."
fi
