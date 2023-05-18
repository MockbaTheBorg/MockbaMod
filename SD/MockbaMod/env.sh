# Check if the mmPath variable is set
if [ -z "$mmPath" ]; then
  echo 'Error: mmPath variable is not set.'
  exit 1
fi

# set up environment variables

MPC_PID=$(ps | grep "MPC Main Thread" | xargs | cut -d' ' -f1)

mm=$mmPath/MockbaMod
mmLogs=$mm/Logs
mmVideos=$mm/Videos
mmImages=$mm/Images
mmTools=$mm/Tools
mmFiles=$mm/Files
mmLua=$mm/Lua
mmLibs=$mm/Libs
mmDev=`amidi -l | grep Private | cut -b5-13`
mmGPU=`cat /sys/devices/platform/ffa30000.gpu/gpuinfo | cut -d' ' -f4`
mmMount=`mount | grep 662522 | cut -d' ' -f1`

#set LDPRELAOD and ANYCTL Var File:
mmLD_PRELOAD_VAR="/dev/shm/.LD_PRELOAD"
mmANYCTL_VAR="/dev/shm/.ANYCTRL_NAME"

# Mount the /tmp/usr folder (pre overlay)

mkdir -p /tmp/usr
if ! mount | grep -q "/tmp/usr"; then
	mount -o loop $mmFiles/usr.img /tmp/usr
fi
usrbin=/tmp/usr/bin

# Create log directory

mkdir -p $mmLogs

# Set up functions

# start_mpc - Starts the MPC process
start_mpc()
{
    [ "x$MPC_PID" == "x" ] && systemctl start inmusic-mpc
}

# stop_mpc - Stops the MPC process to enable access to resources
stop_mpc()
{
    [ "x$MPC_PID" != "x" ] && systemctl stop inmusic-mpc
    sleep 2
    rm "/media/az01-internal/Settings/MPC/MPC.crashinfo"
    rm "/media/az01-internal/Settings/MPC/MPC.running"
}

# clear_pad - Sets all pads to black
clear_pads() {
	amidi -p $mmDev -S 'f0 47 00 40 62 00 01 02 f7'
}

# set_pad <pad> <r> <g> <b> - Sets pad to color 00-f7
set_pad() {
	amidi -p $mmDev -S 'f0 47 00 40 65 00 04 '$1' '$2' '$3' '$4' f7'
}

# play_back <video> - Plays a mp4 video file in the background
play_back() {
	$usrbin/ffmpeg -i $1 -pix_fmt bgra -f fbdev /dev/fb0 >/dev/null 2>&1 &
}

# play <video> - Plays a mp4 video file in the foreground
play() {
	$usrbin/ffmpeg -i $1 -pix_fmt bgra -f fbdev /dev/fb0 >/dev/null 2>&1
}

# display <img> - Displays a png image
display() {
	$usrbin/ffmpeg -i $1 -vf "transpose=2" -pix_fmt bgra -f fbdev /dev/fb0 >/dev/null 2>&1
}
