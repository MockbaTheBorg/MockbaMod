#!/bin/sh

# Part of Mockba Mod, do not modify

# Set the initial execution path
cd "$(dirname "$0")"
echo $(pwd) > /dev/shm/.mmPath

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

clear_pads


if test -f /tmp/mod_started; then
	echo "------------------------------" >> $mmLogs/boot.log
	date >> $mmLogs/boot.log
	echo "Mod was already started" >> $mmLogs/boot.log
else
	echo "------------------------------" > $mmLogs/boot.log
	date >> $mmLogs/boot.log
	echo "MockbaMod SD Card is mounted on "$mmMount
	echo "Booting up the mod" >> $mmLogs/boot.log

	set_pad 00 00 05 05
	# Start logo video
	echo "Logo video" >> $mmLogs/boot.log
	play_back $mmVideos/logo.mp4
	sleep .5
	set_pad 00 00 20 20
	set_pad 01 00 05 05
	
	# Mount the /usr overlay
	echo "Mount /usr overlay" >> $mmLogs/boot.log
	f=$mm/overlay.sh
	[ -f "$f" ] && "$f"
	sleep .5
	set_pad 01 00 20 20
	set_pad 02 00 05 05
	
	# Enable SSHD
	echo "Enable sshd" >> $mmLogs/boot.log
	systemctl enable sshd
	sleep .5
	set_pad 02 00 20 20
	set_pad 03 00 05 05
	
	# Restart SSHD
	echo "Restart sshd" >> $mmLogs/boot.log
	systemctl restart sshd
	sleep .5
	set_pad 03 00 20 20
	set_pad 04 00 05 05
	
	# Checks and runs runonce.sh
	echo "Check/run runonce" >> $mmLogs/boot.log
	f=$mmPath/runonce.sh
	[ -f "$f" ] && "$f"
	mv -f "$f" $mmPath/runonce.bak 2>/dev/null
	sleep .5
	set_pad 04 00 20 20
	set_pad 05 00 05 05
	
	# Checks and runs autoexec.sh
	echo "Check/run autoexec" >> $mmLogs/boot.log
	f=$mmPath/autoexec.sh
	[ -f "$f" ] && "$f"
	sleep .5
	set_pad 05 00 20 20
	set_pad 06 00 05 05
	
	# Waits for logo video to finish playing
	echo "Waiting for logo video to end" >> $mmLogs/boot.log
	while [ `ps | grep ffmpeg | wc -l` -gt 1 ]
	do
		echo "ffmpeg is running" >> $mmLogs/boot.log
		sleep .5	
	done

	display $mmImages/wait.png
	
	# First installation script
	echo "Check/run install" >> $mmLogs/boot.log
	set_pad 06 00 20 20
	set_pad 07 00 05 05
	f=$mm/install.sh
	[ -f "$f" ] && "$f"

	touch /tmp/mod_started
	set_pad 07 00 20 20
fi

echo "Check/run runalways" >> $mmLogs/boot.log
f=$mmPath/runalways.sh
[ -f "$f" ] && "$f"

# Kills AddOns if still running
echo "Killing AddOns" >> $mmLogs/boot.log
if test -d $mmPath/AddOns; then
	for f in $mmPath/AddOns/*.sh; do
		echo "$f kill" >> $mmLogs/boot.log
		"$f" kill 2>/dev/null
	done
fi

# Loads AddOns
echo "Loading AddOns" >> $mmLogs/boot.log
if test -d $mmPath/AddOns; then
	for f in $mmPath/AddOns/*.sh; do
		echo "$f" >> $mmLogs/boot.log
		"$f" &
	done
fi

sleep 1

# Starts MPC
ulimit -S -s 1024
export MALLOC_ARENA_MAX=1
echo 0 > /proc/sys/kernel/randomize_va_space
if test -f /usr/bin/luajit; then
	if test -f $mm/apps.sh; then
		echo "Starting apps menu" >> $mmLogs/boot.log
		$mm/apps.sh
	else
		echo "No apps.sh found" >> $mmLogs/boot.log
		echo "$@" >> $mmLogs/boot.log
		/usr/bin/MPC "$@"
	fi
else
	echo "No luajit found" >> $mmLogs/boot.log
	echo "$@" >> $mmLogs/boot.log
	/usr/bin/MPC "$@"
fi

# Kills AddOns
echo "Killing AddOns" >> $mmLogs/boot.log
if test -d $mmPath/AddOns; then
	for f in $mmPath/AddOns/*.sh; do
		echo "$f kill" >> $mmLogs/boot.log
		"$f" kill 2>/dev/null
	done
fi
