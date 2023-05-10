#!/bin/sh

# Screenshot Capture

dt=`date +"%Y%m%d_%H%M%S"`
ffmpeg -y -crtc_id 0 -framerate 60 -f kmsgrab -i - -vf 'hwdownload,format=bgr0' -vframes 1 -c:v png $dt.png
