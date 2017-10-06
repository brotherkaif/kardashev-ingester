#/bin/bash
# Creates a file based on input JSON and edit parameters.

# Check for dry run.
if [ $DRY_RUN = "TRUE" ]
then
    ARG_DURATION="-t 00:00:20"
else
    ARG_DURATION="-shortest"
fi

# Run the muxing job via FFmpeg.
# WEBM creation
ffmpeg  -ss $( jq -r '.edit_info.start_timecode' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.video_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.audio_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -map 0:0 -map 1:0 \
        -map_metadata -1 \
        -c:v libvpx-vp9 -crf 20 -b:v 0 \
        -c:a libopus -b:a 96k \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        $ARG_DURATION \
        $INPUT_DIRECTORY/../output/$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA )\.webm

# MP4 creation
ffmpeg  -ss $( jq -r '.edit_info.start_timecode' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.video_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.audio_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -map 0:0 -map 1:0 \
        -map_metadata -1 \
        -c:v libx264 -crf 20 -b:v 0 \
        -c:a aac -b:a 128k \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        $ARG_DURATION \
        $INPUT_DIRECTORY/../output/$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA )\.mp4

# OGG creation
ffmpeg  -ss $( jq -r '.edit_info.start_timecode' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.video_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.audio_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -map 0:0 -map 1:0 \
        -map_metadata -1 \
        -c:v libtheora -q:v 7 \
        -c:a libvorbis -q:a 7 \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        $ARG_DURATION \
        $INPUT_DIRECTORY/../output/$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA )\.ogv
