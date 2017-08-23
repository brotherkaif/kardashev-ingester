#/bin/bash
# Ingesting script that uses FFmpeg to convert input video and audio into a standardised 1:1 format

ffmpeg -ss $3 -i $1 -i $2 -map 0:0 -map 1:0 -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" -shortest output.webm
