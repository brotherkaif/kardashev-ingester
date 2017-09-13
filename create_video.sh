#/bin/bash
# Creates a file based on input JSON and edit parameters.

INPUT_METADATA=$1
ARG_LENGTH="-shortest"
META_COMMENT="[ATTRIBUTION DECLARATION]\n
This work, "$( jq -r '.file.title' $INPUT_METADATA )", is a derivative of the works listed below. "$( jq -r '.file.title' $INPUT_METADATA )" was created by $( jq -r '.file.author' $INPUT_METADATA ) and is licenced under a $( jq -r '.file.licence' $INPUT_METADATA ) licence.\n
\n
\n
[AUDIO ATTRIBUTION]\n
Track: $( jq -r '.file.audio_stream.title' $INPUT_METADATA )\n
Artist: $( jq -r '.file.audio_stream.author' $INPUT_METADATA )\n
Licence: $( jq -r '.file.audio_stream.licence' $INPUT_METADATA )\n
Modifications: $( jq -r '.file.audio_stream.modifications' $INPUT_METADATA )\n
\n
(further audio information)\n
$( jq -r '.file.audio_stream.source_URI' $INPUT_METADATA )\n
$( jq -r '.file.audio_stream.author_URI' $INPUT_METADATA )\n
$( jq -r '.file.audio_stream.licence_URI' $INPUT_METADATA )\n
\n
\n
[VIDEO ATTRIBUTION]\n
Track: $( jq -r '.file.video_stream.title' $INPUT_METADATA )\n
Artist: $( jq -r '.file.video_stream.author' $INPUT_METADATA )\n
Licence: $( jq -r '.file.video_stream.licence' $INPUT_METADATA )\n
Modifications: $( jq -r '.file.video_stream.modifications' $INPUT_METADATA )\n
\n
(further video information)\n
$( jq -r '.file.video_stream.source_URI' $INPUT_METADATA )\n
$( jq -r '.file.video_stream.author_URI' $INPUT_METADATA )\n
$( jq -r '.file.video_stream.licence_URI' $INPUT_METADATA )"

echo $META_COMMENT

# Run the muxing job via FFmpeg.
ffmpeg  -ss $( jq -r '.edit_info.start_timecode' $INPUT_METADATA ) \
        -i $( jq -r '.edit_info.video_file' $INPUT_METADATA ) \
        -i $( jq -r '.edit_info.audio_file' $INPUT_METADATA ) \
        -map 0:0 -map 1:0 \
        -metadata title="$( jq -r '.file.title' $INPUT_METADATA )" \
        -metadata artist="$( jq -r '.file.author' $INPUT_METADATA )" \
        -metadata comment="$( echo $META_COMMENT )" \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        $ARG_LENGTH \
        $( jq -r '.file.title' $INPUT_METADATA )\.mp4

# =============
# END OF SCRIPT
