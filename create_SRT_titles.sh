#!/bin/bash
# Script that creates titles in SRT format from an input JSON file.

# FUNCTION: Calculates the timecode value in HH:MM:SS format when a time in seconds is supplied.
Calculate_Timecode () {
        num=$1
        min=0
        hour=0
        day=0
        if((num>59));
        then
                ((sec=num%60))
                ((num=num/60))
                if((num>59));
                then
                        ((min=num%60))
                        ((hour=num/60))
                else
                        ((min=num))
                fi
        else
                ((sec=num))
        fi

        echo $( printf "%02d" $hour ):$( printf "%02d" $min ):$( printf "%02d" $sec )
}

# Calculate timecodes for SRT file.
TC_DURATION_SECONDS=$( ffprobe -i $( jq -r '.edit_info.audio_file' $INPUT_METADATA ) -show_format -v quiet | sed -n 's/duration=//p' | cut -d. -f1 )
TC_AUDIO_INTRO_TITLE_START="00:00:03"
TC_AUDIO_INTRO_TITLE_END="00:00:10"
TC_VIDEO_INTRO_TITLE_START="00:00:13"
TC_VIDEO_INTRO_TITLE_END="00:00:20"
TC_AUDIO_OUTRO_TITLE_START=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 20 )) )
TC_AUDIO_OUTRO_TITLE_END=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 13 )) )
TC_VIDEO_OUTRO_TITLE_START=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 10 )) )
TC_VIDEO_OUTRO_TITLE_END=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 3 )) )

# Build the titles file in the format of an SRT file.
cat <<EOF > ../output/$( jq -r '.file.title' $INPUT_METADATA )/$( jq -r '.file.title' $INPUT_METADATA ).srt
$TC_AUDIO_INTRO_TITLE_START,000 --> $TC_AUDIO_INTRO_TITLE_END,000
[AUDIO]
$( jq -r '.file.audio_stream.author' $INPUT_METADATA ) / "$( jq -r '.file.audio_stream.title' $INPUT_METADATA )" / $( jq -r '.file.audio_stream.licence' $INPUT_METADATA )

2
$TC_VIDEO_INTRO_TITLE_START,000 --> $TC_VIDEO_INTRO_TITLE_END,000
[VIDEO]
$( jq -r '.file.video_stream.author' $INPUT_METADATA ) / "$( jq -r '.file.video_stream.title' $INPUT_METADATA )" / $( jq -r '.file.video_stream.licence' $INPUT_METADATA )

3
$TC_AUDIO_OUTRO_TITLE_START,000 --> $TC_AUDIO_OUTRO_TITLE_END,000
[AUDIO]
$( jq -r '.file.audio_stream.author' $INPUT_METADATA ) / "$( jq -r '.file.audio_stream.title' $INPUT_METADATA )" / $( jq -r '.file.audio_stream.licence' $INPUT_METADATA )

4
$TC_VIDEO_OUTRO_TITLE_START,000 --> $TC_VIDEO_OUTRO_TITLE_END,000
[VIDEO]
$( jq -r '.file.video_stream.author' $INPUT_METADATA ) / "$( jq -r '.file.video_stream.title' $INPUT_METADATA )" / $( jq -r '.file.video_stream.licence' $INPUT_METADATA )
EOF
