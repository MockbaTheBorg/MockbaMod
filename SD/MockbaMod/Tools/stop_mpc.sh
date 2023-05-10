#!/bin/sh

# This script stops the MPC application

systemctl stop inmusic-mpc
sleep 1
dev=`amidi -l | grep Private | cut -b5-13`
amidi -p $dev -S 'f0 47 00 40 62 00 01 02 f7'
if [ "$1" = "off" ]; then
    echo 1 >/sys/class/backlight/mipi-backlight/bl_power
fi
