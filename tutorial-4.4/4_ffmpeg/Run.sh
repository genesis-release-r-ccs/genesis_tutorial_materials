#!/bin/sh

ffmpeg -i ../3_convert/md%4d.png -qscale 0 -vcodec mjpeg -s 480x480 md.avi
ffmpeg -i md.avi -b 4000k -vcodec libx264 -pix_fmt yuv420p md.mp4
