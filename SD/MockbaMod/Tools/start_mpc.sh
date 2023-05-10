#!/bin/sh

# This script starts the MPC application

echo 0 >/sys/class/backlight/mipi-backlight/bl_power
systemctl start inmusic-mpc
