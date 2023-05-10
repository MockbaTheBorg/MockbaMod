#!/bin/sh

# Part of Mockba Mod, do not modify

# Set up the environment
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh

ps xawf > $mmLogs/ps.log
set > $mmLogs/set.log
pwd > $mmLogs/pwd.log
aconnect -l > $mmLogs/aconnect.log
cd $mmLua
app=`luajit menu.lua`
cd -
echo "Preparing $app" >> $mmLogs/boot.log

[[ -f "$mmANYCTL_VAR" ]] && export ANYCTRL_NAME="$(cat "$mmANYCTL_VAR")"
[[ -f "$mmLD_PRELOAD_VAR" ]] && export LD_PRELOAD="$(cat "$mmLD_PRELOAD_VAR")"

echo "Executing $app" >> $mmLogs/boot.log
echo "[$@]" >> $mmLogs/boot.log
if test "$app" == "MPC"; then
	/usr/bin/MPC "$@"
else
	$mmPath/Apps/$app "$@"
fi
echo "$app exited" >> $mmLogs/boot.log
