#!/bin/bash
# Ingesting script that uses FFmpeg to convert input video and audio into a standardised 1:1 format.

# START OF FUNCTION DECLARATIONS
# ==============================

## FUNCTION: Calculates the timecode value in HH:MM:SS format when a time in seconds is supplied.
#Calculate_Timecode () {
#        num=$1
#        min=0
#        hour=0
#        day=0
#        if((num>59));
#        then
#                ((sec=num%60))
#                ((num=num/60))
#                if((num>59));
#                then
#                        ((min=num%60))
#                        ((hour=num/60))
#                else
#                        ((min=num))
#                fi
#        else
#                ((sec=num))
#        fi
#
#        echo $( printf "%02d" $hour ):$( printf "%02d" $min ):$( printf "%02d" $sec )
#}

## FUNCTION: Constructs the titles.
#Construct_Titles () {
#        
#        # Get duration of track using FFprobe.
#        TC_DURATION_SECONDS=$(ffprobe -i $INPUT_AUDIO -show_format -v quiet | sed -n 's/duration=//p' | cut -d. -f1 )
#        TC_AUDIO_INTRO_TITLE_START="00:00:03"
#        TC_AUDIO_INTRO_TITLE_END="00:00:10"
#        TC_VIDEO_INTRO_TITLE_START="00:00:13"
#        TC_VIDEO_INTRO_TITLE_END="00:00:20"
#        TC_AUDIO_OUTRO_TITLE_START=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 20 )) )
#        TC_AUDIO_OUTRO_TITLE_END=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 13 )) )
#        TC_VIDEO_OUTRO_TITLE_START=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 10 )) )
#        TC_VIDEO_OUTRO_TITLE_END=$( Calculate_Timecode $(( $TC_DURATION_SECONDS - 3 )) )
#
#
#        # Build the titles file in the format of an SRT file.
#        echo "1" >> $TITLES
#        echo "$TC_AUDIO_INTRO_TITLE_START,000 --> $TC_AUDIO_INTRO_TITLE_END,000" >> $TITLES
#        echo "[AUDIO]" >> $TITLES
#        echo "${META_VALUES[0]} / '${META_VALUES[1]}' / ${META_VALUES[8]}" >> $TITLES
#
#        echo "2" >> $TITLES
#        echo "$TC_VIDEO_INTRO_TITLE_START,000 --> $TC_VIDEO_INTRO_TITLE_END,000" >> $TITLES
#        echo "[VIDEO]" >> $TITLES
#        echo "${META_VALUES[9]} / '${META_VALUES[10]}' / ${META_VALUES[12]}" >> $TITLES
#
#        echo "3" >> $TITLES
#        echo "$TC_AUDIO_OUTRO_TITLE_START,000 --> $TC_AUDIO_OUTRO_TITLE_END,000" >> $TITLES
#        echo "[AUDIO]" >> $TITLES
#        echo "${META_VALUES[0]} / '${META_VALUES[1]}' / ${META_VALUES[8]}" >> $TITLES
#
#        echo "4" >> $TITLES
#        echo "$TC_VIDEO_OUTRO_TITLE_START,000 --> $TC_VIDEO_OUTRO_TITLE_END,000" >> $TITLES
#        echo "[VIDEO]" >> $TITLES
#        echo "${META_VALUES[9]} / '${META_VALUES[10]}' / ${META_VALUES[12]}" >> $TITLES
# }

# ============================
# END OF FUNCTION DECLARATIONS
 


# START OF SCRIPT
# ===============

## Initialise our variables.
#INPUT_VIDEO=""
#INPUT_AUDIO=""
#START_TIMECODE=""
#
#TITLES=$(mktemp)
#
#TC_DURATION_SECONDS=""
#TC_AUDIO_INTRO_TITLE_START=""
#TC_AUDIO_INTRO_TITLE_END=""
#TC_VIDEO_INTRO_TITLE_START=""
#TC_VIDEO_INTRO_TITLE_END=""
#TC_AUDIO_OUTRO_TITLE_START=""
#TC_AUDIO_OUTRO_TITLE_END=""
#TC_VIDEO_OUTRO_TITLE_START=""
#TC_VIDEO_OUTRO_TITLE_END=""
#
#META_KEYS=(title artist album_artist album date track genre audio_URL audio_copyright video_title video_author video_URL video_copyright)
#META_VALUES=()
#META_COMMENT=$(mktemp)
#
#OPT_MANUAL_META=false
#
#ARG_LENGTH="-shortest"
#
#OUTPUT_FILENAME=$( date | md5sum | cut -c -7 )

# Get input arguements and assign them to variables.
while getopts ":i:d" opt;
do
    case $opt in
        i)
            INPUT_METADATA=$OPTARG 
            ;;
        d)
            echo DRY RUN MODE
            echo ============
            echo Output file will be limited to 30 seconds.
            DRY_RUN=TRUE
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an arguement." >&2
            exit 1
            ;;
    esac
done


# If no arguments passed through, exit gracefully.
if [ -z "$INPUT_METADATA" ]
then
    echo 'You need to supply a JSON file with -i.' >&2
    exit 1
fi

export INPUT_METADATA
echo Exported out the metadata...
echo Invoking create video script...
./create_video.sh

# =============
# END OF SCRIPT
