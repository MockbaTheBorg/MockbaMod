#!/bin/sh
#This is midloop v4 helper script.
# Author: Amit Talwar 
# Part of Akai Force MIDILOOP Project for AFWVG (Akai Force Warranty Voiders Group)
# you can put your own commands in Script Sections SCRIPT-1 - SCRIPT-8 and these can be launched from Force Shortcuts or
#midi notes/cc.
# To Enable/Disable MIDILOOP from loading : use the following commands from shell:
#  /media/662522/Tools/midiloop_script.sh ON
#  /media/662522/Tools/midiloop_script.sh OFF
# 
#root/install directory of midiloop

mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh
[[ -d "$mmPath" ]] ||   mmPath="/media/662522"

MLROOT="$mmPath/AddOns/MidiLoop"

if [ "$#" -eq 0 ]
then
  echo "No Script Id supplied"
  exit 1
fi

ID=$1




if [ "$ID" = "SCRIPT-1" ]; then  #SCRIPT-1
#YOUR SCRIPT STARTS BELOW HERE ###################

#YOUR SCRIPT ENDS ABOVE HERE ##################
	exit 0;
fi

if [ "$ID" = "SCRIPT-2" ]; then  #SCRIPT-2
	#YOUR SCRIPT STARTS BELOW HERE ###################
	## This SCRIPT TOGGLES DEV-MODE ON/OFF ON FORCE
	##You will need to Restart Force App to see changes..
	
	devF=/media/az01-internal/dev-mode
	if [ -f "$devF" ]; then
	rm -f "$devF"
	else
	touch "$devF"
	fi 
	
	#YOUR SCRIPT ENDS ABOVE HERE ###################
	exit 0;
fi

if [ "$ID"  = "SCRIPT-3" ]; then # #SCRIPT-3
	#YOUR SCRIPT STARTS BELOW HERE ###################
	
	
	#YOUR SCRIPT ENDS ABOVE HERE ###################

exit 0;

fi

if [ "$ID" = "SCRIPT-4" ]; then #SCRIPT-4
	#YOUR SCRIPT STARTS BELOW HERE ###################

	#YOUR SCRIPT ENDS ABOVE HERE ###################
exit 0;
fi


if [ "$ID" = "SCRIPT-5" ]; then   #SCRIPT-5
	#YOUR SCRIPT STARTS BELOW HERE ###################
	#select default config
	"$MLROOT"/midiloop_script.sh CONFIG default
	#YOUR SCRIPT ENDS ABOVE HERE ###################
exit 0;
fi

if [ "$ID" = "SCRIPT-6" ]; then  #SCRIPT-6
	#YOUR SCRIPT STARTS BELOW HERE ###################
	#select vanilla config
	"$MLROOT"/midiloop_script.sh CONFIG vanilla
	
	#YOUR SCRIPT ENDS ABOVE HERE ###################
exit 0;
fi

if [ "$ID" = "SCRIPT-7" ]; then  #SCRIPT-7
	#YOUR SCRIPT STARTS BELOW HERE ###################
	
	
	#YOUR SCRIPT ENDS ABOVE HERE ###################
exit 0;
fi

if [ "$ID" = "SCRIPT-8" ]; then  #SCRIPT-8                                                            
    #YOUR SCRIPT STARTS BELOW HERE ###################

	
	#YOUR SCRIPT ENDS ABOVE HERE ###################                                                                                           
exit 0;                                                                                        
fi   

################# SYSTEM SCRIPTS ################################
#                DO NOT EDIT BELOW 
##################################################################


########### INJECT CUSTM XMM FILE into OVERLAY and deactive factory xmm files of no use to enable special functions hackl 
if [ "$ID" = "XMM-INJECTION" ]; then #special setup script to mopunt an overlay in ram and remove templates and add custom internal functions.                                                           

#copy ffmpeg to ampeg if not exists for av capture 
#jsut using this functionas its always called
# no need for this anymore #[  -f /media/662522/Tools/ampeg ] || cp /media/662522/Tools/ffmpeg /media/662522/Tools/ampeg


xmm="/usr/share/Akai/SME0/Midi Learn"
tfile="NI AmitLP2-Ch11_n.xmm"
list=`ls "$xmm"/*.xmm`
ifs="$IFS"
IFS=$'\n'
 for line in $list; do
	file=`basename "$line"`
	if [ "$file" != "$tfile" ]; then
	 mv "$line" "${line::-4}.bak"
	 fi
  done

cp -uf "$MLROOT"/"$tfile" "$xmm/$tfile"
echo factory xmm templates renamed and custom injected! run "midiloop_script.sh RESTORE" to Restore Factory ones Back. 	
IFS="$ifs"

exit 0;                                                                                        
fi   

###########  RESTORE FACTORY TEMPLATES
if [ "$ID" = "RESTORE" ]; then  #restore factory templates
 xmm="/usr/share/Akai/SME0/Midi Learn"                                                                  
list=`ls "$xmm"/*.bak` 2> /dev/null                                                                                 
ifs="$IFS"                                                                                             
IFS=$'\n'                                                                                              
 for line in $list; do 
        mv "$line" "${line::-4}.xmm"                                                                        
  done   
echo "Factory xmm Templates Restored" 
       exit 0;
fi

######################### TOUCH SIMULATOR ########################

if [ "$ID" = "TOUCH" ]; then
	
	counter=`cat /dev/shm/touchID`

	if [ $counter -eq "$counter" ]  2>/dev/null; then
	counter=$counter
	else 
	counter=0
	fi

	counter=$((counter + 1));

	echo $counter >/dev/shm/touchID

	[ $# -ne 3 ] &&  echo "Please Provide X and Y coordinates Between (1280x720)" &&  exit 1


	X=$((720- ($2 * 720/1280)))
	Y=$(($3 * 1280/720))

block=$(cat << EOF
E: 0.000001 0003 0039 $counter
E: 0.000001 0003 0035 $Y	
E: 0.000001 0003 0036 $X
E: 0.000001 0001 014a 0001
E: 0.000001 0003 0000 $Y
E: 0.000001 0003 0001 $X̦
E: 0.000001 0000 0000 0000
E: 0.062172 0003 0039 -001
E: 0.062172 0001 014a 0000
E: 0.062172 0000 0000 0000
EOF
)
	 event=/dev/shm/touche

	echo "$block" > $event
	estr=`ls /dev/input/by-path/ -l  | grep i2c-event | cut -d">" -f2 | xargs`
	dev=$(realpath /dev/input/by-path/$estr)
	evemu-play $dev < $event
	return 0;
fi

########### Turn On Midiloop

if [ "$ID" = "ON" ]; then
 [  -d "$MLROOT" ] ||  exit 0;

rm  -f "$MLROOT"/MIDILOOP_OFF 2>/dev/null
systemctl restart inmusic-mpc
echo "Midi Loop Should have started."
exit 0
fi

########### Turn Off MidiLoop
if [ "$ID" = "OFF" ]; then
[  -d "$MLROOT" ] ||  exit 0;

touch "$MLROOT"/MIDILOOP_OFF 2>/dev/null
"$MLROOT"/midiloop_script.sh RESTORE
systemctl restart inmusic-mpc
echo "Midi Loop has been switched off."
exit 0
fi


########### TAKE Screenshot
if [ "$ID" = "SCREENSHOT" ]; then 
#this script takes a screenshot and stores in /media/662522/Screenshots directory.
ts=$(date +"%Y-%m-%d_%H-%M-%S")

fn="$mmPath"/Screenshots
tfile="$fn/$ts.png"
mkdir -p "$fn" 2> /dev/null
ffmpeg -y -nostdin -hide_banner -loglevel error -crtc_id 0 -framerate 60 -f kmsgrab -i - -vf 'hwdownload,format=bgr0,transpose=1' -vframes 1 -c:v png "$tfile" &> /dev/null
echo "Screenshot Should have been saved to: $tfile"
exit 0;
fi

########### Video Capture : run once to start again to stop.
if [ "$ID" = "VIDEO-CAPTURE" ]; then

	"$MLROOT"/capture.sh capture V
	exit 0;
fi
if [ "$ID" = "AUDIO-CAPTURE" ]; then

	"$MLROOT"/capture.sh capture A
	exit 0;
fi

if [ "$ID" = "AUDIO-VIDEO-CAPTURE" ]; then

	"$MLROOT"/capture.sh capture AV
	exit 0;
fi

########### SHOW OUTOUT LOG iF LOGGIN ENABLED
if [ "$ID" = "LOG" ]; then
	if [ -f /tmp/midiloop.log ]; then
	echo "######## MIDILOOP REALTIME MESSAGE LOG ########"
	echo "           Press Ctrl+c to Exit                "
	echo "################################################"
	echo 
	tail -f /tmp/midiloop.log
	else
	echo Logging not Enabled in current Config File!	
	fi
	exit 0;
fi



########### Config File/Profile Switcher

if [ "$ID" = "CONFIG" ]; then
confdir="$MLROOT/configs"
#confdir=`dirname "$0"`/configs
ifs="$IFS"                                                                                             
IFS='
'
list=$(ls "$confdir"/*.config)


LIST_CONFIGS() {
	echo "
---------------- PLEASE PROVIDE A VALID CONFIG NAME ---------------"
	echo 
	echo "###### Please Provide one of the following as Parameter to the Script to Load as Config #######"
	
#	echo "$confdir"
echo "--------------------------------------------------------------"
	echo
echo "$list" | while read -r line; do
nline=${line:: -7}

echo `basename "$nline"`
done 

echo "
--------------------------------------------------------------
for example: midiloop_script.sh CONFIG basic
	 will set basic.config as current midiloop config.
	"

}

cfile="$confdir/$2.config"
tfile="$confdir/../midiloop.config"

if [ -f "$cfile" ]; then
cp -f "$cfile" "$tfile"  
echo "Config set to: " $2 
echo "
You Should RELOAD-CONFIG in Force or Restart Force Session!"
else
LIST_CONFIGS
fi 


IFS=$ifs #restore default IFS   
exit 0;
fi


echo Error! No Script Id Specified!
