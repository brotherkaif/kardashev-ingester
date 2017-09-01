#/bin/bash
# Ingesting script that uses FFmpeg to convert input video and audio into a standardised 1:1 format.

# START OF FUNCTION DECLARATIONS
# ==============================

# FUNCTION: Gets metadata for final file. Set MANUAL_META before calling to toggle manual entry.
Get_Metadata () {

        # Iterate through all of the META_KEYS and get the META_VALUES.
        for ITERATION in {0..10}
        do
                # If manual override has not been activated, attempt to get info from INPUT_AUDIO.
                if [ $MANUAL_META = false ]
                then
                        META_VALUES[$ITERATION]="$( ffprobe -v error -show_entries format_tags=${META_KEYS[$ITERATION]} -of default=noprint_wrappers=1:nokey=1 $INPUT_AUDIO )"
                fi

                # If the META_VALUE is empty for some reason, ask the user to input it manually.
                if [ -z "${META_VALUES[$ITERATION]}" ]
                then
                        read -p "Enter the ${META_KEYS[$ITERATION]}: " META_VALUES[$ITERATION]
                fi
        done

        # Once all the META_VALUES have been collected create the META_COMMENT value
        META_COMMENT="[AUDIO DETAILS]
        URL: ${META_VALUES[7]}
        Copyright: ${META_VALUES[8]}

        [VIDEO DETAILS]
        URL: ${META_VALUES[9]}
        Copyright: ${META_VALUES[10]}"

 }

# ============================
# END OF FUNCTION DECLARATIONS
 


# START OF SCRIPT
# ===============

# Initialise our variables.
INPUT_VIDEO=""
INPUT_AUDIO=""
START_TIMECODE=""
META_KEYS=(title artist album_artist album date track genre audio_URL audio_copyright video_URL video_copyright)
META_VALUES=()
META_COMMENT=""
MANUAL_META=false


# Get input arguements and assign them to variables.
while getopts ":v:a:t:m" opt;
do
    case $opt in
        v)
            INPUT_VIDEO=$OPTARG 
            ;;
        a)
            INPUT_AUDIO=$OPTARG 
            ;; 
        t)
            START_TIMECODE=$OPTARG 
            ;;
        m)
            MANUAL_META=true
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
if [ -z "$INPUT_VIDEO" ] || [ -z "$INPUT_AUDIO" ] || [ -z "$START_TIMECODE" ] 
then
    echo 'Something went wrong! You need to specify video (-v), audio (-a) and start timecode (-t).' >&2
    exit 1
fi

Get_Metadata

# Run the muxing job via FFmpeg.
ffmpeg  -ss $START_TIMECODE -i $INPUT_VIDEO -i $INPUT_AUDIO \
        -map 0:0 -map 1:0 \
        -metadata ${META_KEYS[0]}="${META_VALUES[0]}" \
        -metadata ${META_KEYS[1]}="${META_VALUES[1]}" \
        -metadata ${META_KEYS[2]}="${META_VALUES[2]}" \
        -metadata ${META_KEYS[3]}="${META_VALUES[3]}" \
        -metadata ${META_KEYS[4]}="${META_VALUES[4]}" \
        -metadata ${META_KEYS[5]}="${META_VALUES[5]}" \
        -metadata ${META_KEYS[6]}="${META_VALUES[6]}" \
        -metadata ${META_KEYS[7]}="${META_VALUES[7]}" \
        -metadata comment="$META_COMMENT" \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        -shortest \
        output.mp4

# =============
# END OF SCRIPT
