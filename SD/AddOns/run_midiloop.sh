#!/bin/sh

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

if test "$1" == "kill"; then
    killall midiloop
else
    $mmPath/AddOns/MidiLoop/midiloop 2>/dev/null & 
    echo 
fi
