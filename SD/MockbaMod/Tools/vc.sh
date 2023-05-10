#!/bin/sh

# Video Capture (no audio)

ffmpeg -y -framerate 30 -f kmsgrab -fflags nobuffer -i - -vf 'hwdownload,format=bgr0' -c:v libx264rgb -crf 0 -an -preset ultrafast $1
