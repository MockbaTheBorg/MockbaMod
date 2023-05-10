#!/bin/sh
# Video Capture Script approx fps: 15
# usage:
# . videocapture.sh q : will directly create video in /media/662522/Videos
# . videocapture.sh  : without any arguements will start capture video in ram.
#   running the script again will stop capture and copy or convert the video to destination.
#   if convertyuv = 1 the video will be converted to the standard h264 format compatible with browsers and all players, but does take quite a lot of time to convert.
#   videocapture.sh reset : will kill any hung ffmpeg captures and remove locks and capture from Ram.
mmPath=`cat /dev/shm/.mmPath`
. $mmPath/MockbaMod/env.sh


DEST="$mmPath"/AV-Captures #target directory to save to.
#should be name of the audio card ytou acre capturing from. use the argument devices to this script to find available audio devices
# ADA2 is internal soundcard
audiodevice=ADA2
audioformat=flac #file format to use when only capturing audio. (you can also use wav, mp3 does not work)

#******************* INITIALIZERS *****************************

capture_temp="$DEST/.temp"
mkdir -p "$capture_temp"

cfile="$capture_temp"/capture.mp4
ts=$(date +"%Y-%m-%d_%H-%M-%S")

tfile="$DEST/$ts.mp4"
ctfile="$DEST/$ts.mp4"
C_LOCK=/dev/shm/capture.lock
ff="ffmpeg"

#************************ SCRIPT CODE ******************************************

param=$1
capturemode=$2
if [ "$capturemode" == "A" ]; then
    cfile="$capture_temp"/capture.$audioformat
    tfile="$DEST/$ts.$audioformat"
fi

#*********************************************************************
# Function Declarations
#*********************************************************************

STATUS() {

    if [ -e $C_LOCK ]; then
        echo CAPTURING
        exit 0
    fi
    echo IDLE

    exit 0
}

FFID() {

    fstx=$(ps | grep -m 1 "$ff")
    fstr=$(echo $fstx | sed -e 's/^[[:space:]]*//')
    fid=0
    if [[ "$fstr" == "*kmsgrab*" ]]; then
        fid=$(echo "$fstr" | cut -d" " -f1)
        echo $fid
        exit 0
    fi
    echo 0
    exit 0

}

RESET() {
    killall ffmpeg 2>/dev/null
    rm "$cfile" 2>/dev/null
    rm "$C_LOCK" 2>/dev/null
    exit 0
}

CONVERT() {
    
    mv "$cfile" "$tfile"

    if  [ $? -eq 0 ]; then
        echo "Captures  Saved to :" $tfile
    else
    echo "Error!
No File Was Captured!
Likely Bad Audio Device or Audio Device in Use!)"
    fi
    RESET

}
NCAPTURE() { #called from nodeserver
    node_capture=1
    CAPTURE
    exit 0
}

NCAPTURE() { #called from nodeserver
    node_capture=1
    CAPTURE
    exit 0
}
CAPTURE() {

    st=$(STATUS)

    if [ "$st" == "IDLE" ]; then

        if [ "$capturemode" == "V" ]; then
            touch "$C_LOCK"

            $ff -y -nostdin -hide_banner -loglevel 0 -framerate 60 -f kmsgrab -fflags nobuffer -i - -vf 'hwdownload,format=bgr0,transpose=1' -c:v libx264rgb -crf 0 -an -preset ultrafast -f mpegts "$cfile" &> /dev/null &

            echo "Video Capture Started.. run script again to Stop and convert to usable video format! "
            exit 0
        fi
        if [ "$capturemode" == "AV" ]; then
            touch "$C_LOCK"

            $ff -y -nostdin -hide_banner -loglevel error -framerate 60 -f kmsgrab -fflags nobuffer -i - -f alsa -ar 44100 -i default:$audiodevice -ac 2 -c:a aac -f mulaw -vf 'hwdownload,format=bgr0,transpose=1' -c:v libx264rgb -crf 0 -preset ultrafast -f mpegts "$cfile" &> /dev/null &

            echo "Audio Video Capture Started.. run script again to Stop and convert to usable video format"
            exit 0
        fi
        if [ "$capturemode" == "A" ]; then
            touch "$C_LOCK"

            $ff -y -nostdin -hide_banner -loglevel 0 -f alsa -ar 44100 -ac 2 -i default:$audiodevice -acodec flac "$cfile" &> /dev/null &

            echo "audio Capture Started: Run script again with same parameters to stop and save the captured file."

            exit 0
        fi

        echo "Error! You must Provide one of the following capture modes:
A, V, AV
after capture keyword!"

        exit 0

    fi

    if [ "$st" == "CAPTURING" ]; then

        kid=$(FFID)

        [ "$kid" -gt "0" ] 2>/dev/null && kill -2 $kid 2>/dev/null
        sleep .3
        rm "$C_LOCK" #clear capturing lock.
        CONVERT
        exit 0
    fi
    exit 0
}

SHOW_DEVICES() {
    echo "**************** AVAILABLE AUDIO DEVICES *******************\n"
    arecord -l | grep 'card\s[0-9]:' | cut -d" " -f3
    exit 0
}

HELP() {
    cat <<EOF
****************************************************	
	Video Capture Script for Akai Force.
****************************************************
	
 Usage: videocapture.sh {Param}

 ::The {Param} can be one of the Following:

	 reset   : Clears hun ffmpeg state and deletes any locks..

	 status  : Returns one of the Following: CAPTURING, PROCESSING, IDLE 
	 devices  : List Available Audio Capture Devices on the System..

	 capture : Starts Capturing the Video. call again with capture to stop capture and start
	 		   conversion processing. Takes a bit of time to convert to standard libx264.
               capture must be followed by capture mode, A for audio, V for Video, AV for Both audio,video.



	 help    : Shows this Help
EOF
    exit 0

}

#*********************************************************************
# CODE : edit at your own risk ;=())
#*********************************************************************

mkdir -p "$DEST"

[ $param == 'reset' ] 2>/dev/null && RESET
[ $param == 'status' ] 2>/dev/null && STATUS
[ $param == 'devices' ] 2>/dev/null && SHOW_DEVICES
[ $param == 'capture' ] 2>/dev/null && CAPTURE
[ $param == 'ncapture' ] 2>/dev/null && NCAPTURE

[ $param == 'help' ] 2>/dev/null && HELP

echo "Error: You Did not Provide a Valid Argument!"
HELP
