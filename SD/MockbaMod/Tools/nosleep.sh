#!/bin/sh

# Stop the unsupported devices service
systemctl stop az01-unsupported-device-daemon

# Find the path to the card reader
fPath=$(find /sys/devices/platform -name "product" -type f -exec grep -l "Card Reader" {} \;)
fPath=$(dirname "$fPath")/power
echo on > $fPath/control
echo -1 > $fPath/autosuspend
