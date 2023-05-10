#!/bin/sh

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

LD_LIB="$mmPath/AddOns/MidiLoop/tkgl_anyctrl_lt.so"

SETLIBS() {

[ -f "$mmANYCTL_VAR" ] || echo "Mockba Automation Out" > "$mmANYCTL_VAR"

if [ -f "$mmLD_PRELOAD_VAR" ]; then
    #if exists check if its already loaded, otherwise append to end.
    
    FC=$(cat "$mmLD_PRELOAD_VAR")
    
    if [[ "$FC" != *"$LD_LIB"* ]]; then
        #always append to end
        echo "$FC $LD_LIB" > "$mmLD_PRELOAD_VAR"
    fi

else

    echo "$LD_LIB" > "$mmLD_PRELOAD_VAR"
fi

}

if test "$1" == "kill"; then
    killall midiloop
else
    SETLIBS
    $mmPath/AddOns/MidiLoop/midiloop 2>/dev/null & 
    echo 
fi
