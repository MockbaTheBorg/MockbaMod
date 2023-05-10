#!/bin/sh

# Video Capture (with Audio from hw:2)

ffmpeg -y -f alsa -i hw:2 -framerate 30 -f kmsgrab -itsoffset 0.5 -fflags nobuffer -i - -vf hwdownload,format=bgr0 -c:v libx264rgb -crf 0 -preset ultrafast $1
