#/bin/bash
# Creates a file based on input JSON and edit parameters.

# Check for dry run.
if [ $DRY_RUN = "TRUE" ]
then
    ARG_DURATION="-t 00:00:20"
else
    ARG_DURATION="-shortest"
fi

# Put together the metadata comment value.
META_COMMENT=$"[ATTRIBUTION DECLARATION]
This work, \"$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA )\", is a derivative of the works listed below. \"$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA )\" was created by $( jq -r '.file.author' $INPUT_DIRECTORY/$INPUT_METADATA ) and is licenced under a $( jq -r '.file.licence' $INPUT_DIRECTORY/$INPUT_METADATA ) licence.

[AUDIO ATTRIBUTION]
Track: $( jq -r '.file.audio_stream.title' $INPUT_DIRECTORY/$INPUT_METADATA )
Artist: $( jq -r '.file.audio_stream.author' $INPUT_DIRECTORY/$INPUT_METADATA )
Licence: $( jq -r '.file.audio_stream.licence' $INPUT_DIRECTORY/$INPUT_METADATA )
Modifications: $( jq -r '.file.audio_stream.modifications' $INPUT_DIRECTORY/$INPUT_METADATA )
Reference URLs:
$( jq -r '.file.audio_stream.source_URI' $INPUT_DIRECTORY/$INPUT_METADATA )
$( jq -r '.file.audio_stream.author_URI' $INPUT_DIRECTORY/$INPUT_METADATA )
$( jq -r '.file.audio_stream.licence_URI' $INPUT_DIRECTORY/$INPUT_METADATA )

[VIDEO ATTRIBUTION]
Track: $( jq -r '.file.video_stream.title' $INPUT_DIRECTORY/$INPUT_METADATA )
Artist: $( jq -r '.file.video_stream.author' $INPUT_DIRECTORY/$INPUT_METADATA )
Licence: $( jq -r '.file.video_stream.licence' $INPUT_DIRECTORY/$INPUT_METADATA )
Modifications: $( jq -r '.file.video_stream.modifications' $INPUT_DIRECTORY/$INPUT_METADATA )
Reference URLs:
$( jq -r '.file.video_stream.source_URI' $INPUT_DIRECTORY/$INPUT_METADATA )
$( jq -r '.file.video_stream.author_URI' $INPUT_DIRECTORY/$INPUT_METADATA )
$( jq -r '.file.video_stream.licence_URI' $INPUT_DIRECTORY/$INPUT_METADATA )"

# Run the muxing job via FFmpeg.
ffmpeg  -ss $( jq -r '.edit_info.start_timecode' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.video_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -i $INPUT_DIRECTORY/$( jq -r '.edit_info.audio_file' $INPUT_DIRECTORY/$INPUT_METADATA ) \
        -map 0:0 -map 1:0 \
        -metadata title="$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA )" \
        -metadata artist="$( jq -r '.file.author' $INPUT_DIRECTORY/$INPUT_METADATA )" \
        -metadata comment="$( echo "$META_COMMENT" )" \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        $ARG_DURATION \
        $INPUT_DIRECTORY/../output/$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA )\.webm
