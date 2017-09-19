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

## FUNCTION: Gets metadata for final file. Set MANUAL_META before calling to toggle manual entry.
#Get_Metadata () {
#
#        # Iterate through all of the META_KEYS and get the META_VALUES.
#        for ITERATION in {0..12}
#        do
#                # If manual override has not been activated, attempt to get info from INPUT_AUDIO.
#                if [ $OPT_MANUAL_META = false ]
#                then
#                        META_VALUES[$ITERATION]="$( ffprobe -v error -show_entries format_tags=${META_KEYS[$ITERATION]} -of default=noprint_wrappers=1:nokey=1 $INPUT_AUDIO )"
#                fi
#
#                # If the META_VALUE is empty for some reason, ask the user to input it manually.
#                if [ -z "${META_VALUES[$ITERATION]}" ]
#                then
#                        read -p "Enter the ${META_KEYS[$ITERATION]}: " META_VALUES[$ITERATION]
#                fi
#        done
#
#        # Once all the META_VALUES have been collected create the META_COMMENT value
#        echo "[AUDIO DETAILS]" >> $META_COMMENT
#        echo "TITLE: ${META_VALUES[0]}" >> $META_COMMENT
#        echo "ARTIST: ${META_VALUES[1]}" >> $META_COMMENT
#        echo "URL: ${META_VALUES[7]}" >> $META_COMMENT
#        echo "Copyright: ${META_VALUES[8]}" >> $META_COMMENT
#        echo >> $META_COMMENT
#        echo "[VIDEO DETAILS]" >> $META_COMMENT
#        echo "TITLE: ${META_VALUES[9]}" >> $META_COMMENT
#        echo "AUTHOR: ${META_VALUES[10]}" >> $META_COMMENT
#        echo "URL: ${META_VALUES[11]}" >> $META_COMMENT
#        echo "Copyright: ${META_VALUES[12]}" >> $META_COMMENT
#                
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

#Get_Metadata
#Construct_Titles
#
## Run the muxing job via FFmpeg.
#ffmpeg  -ss $START_TIMECODE -i $INPUT_VIDEO -i $INPUT_AUDIO \
#        -map 0:0 -map 1:0 \
#        -metadata ${META_KEYS[0]}="${META_VALUES[0]}" \
#        -metadata ${META_KEYS[1]}="${META_VALUES[1]}" \
#        -metadata ${META_KEYS[2]}="${META_VALUES[2]}" \
#        -metadata ${META_KEYS[3]}="${META_VALUES[3]}" \
#        -metadata ${META_KEYS[4]}="${META_VALUES[4]}" \
#        -metadata ${META_KEYS[5]}="${META_VALUES[5]}" \
#        -metadata ${META_KEYS[6]}="${META_VALUES[6]}" \
#        -metadata ${META_KEYS[7]}="${META_VALUES[7]}" \
#        -metadata comment="$( cat $META_COMMENT )" \
#        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720,subtitles=$TITLES:force_style='FontName=DejaVu Mono,Alignment=1,Fontsize=12,BorderStyle=3'" \
#        $ARG_LENGTH \
#        $OUTPUT_FILENAME\.mp4

# =============
# END OF SCRIPT
