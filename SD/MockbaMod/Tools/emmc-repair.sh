#!/bin/sh
# AKAI FORCE INTERNAL EMMC REPAIR TOOL by Amit Talwar for Mcokba Mod


VERBOSE=$1

HEADER(){
cat << EOF
##########################################################################
 AKAI FORCE INTERNAL EMMC REPAIR TOOL by Amit Talwar for Mockba Mod
--------------------------------------------------------------------------
This Script Attemmpts to repair corruption of your internal emmc card.
You must Restart Force after scan if this script is run with parameter -v,
otherwise it will automatically reboot.
##########################################################################
EOF
}

function  TIMEOUT()
{
timeout=5
if [ ! -z $1 ] && [ "$1" == $1 ] && [ $1 -lt 30 ]; then
    timeout=$1
fi
    i=$timeout
while [ $i -gt 0 ]; do
echo -en "\r Waiting for: $i Seconds"
sleep 1
    i=$((i-1))
    echo -en "\r"
done

}



ERROR() {
	if [ $1 -ne 0 ]; then
echo -e "There was a Problem in Last Step! Cannot Proceed\n"

echo "Please Restart Your Force Nevetheless: reboot command works!"

[[ "$VERBOSE" == "-v" ]] && exit 1 ||  reboot
exit  1
fi
}

UNMOUNTS(){

overlays=`cat /proc/mounts | grep "az01-internal/system" | cut -d' ' -f2`

echo
for o in $overlays;
do
	echo "Unmounting Overlay: " $o
	umount -lf "$o"
	ERROR $?
done

echo -e  "\nAll Overlays Unmounted.."
return 0
}


HEADER
#wait 5 seconds to make overlay listing available..
TIMEOUT 5 
UNMOUNTS
ERROR $?


#proceed with remounting 
base="/media/az01-internal"
mmc=`cat /proc/mounts | grep "$base ext4" | xargs |cut -d' ' -f1`
echo -e "\n************* RE-MOUNTING FS AS RO for FSCK ***********\n"
echo "remounting: $base"
mount -o remount,ro "$base"
ERROR $?
echo "remounting: $mmc"
mount -o remount,ro "$mmc"
ERROR $?

echo -e "\n************* ATTEMPTING REPAIR ***********\n"

fsck.ext4 -fy "$mmc"

ERROR $?



[[ "$VERBOSE" == "-v" ]] ||  reboot



