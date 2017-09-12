#/bin/bash
# Creates a file based on input JSON and edit parameters.

INPUT_VIDEO=""
INPUT_AUDIO=""
START_TIMECODE=""
INPUT_FILE="" 

ARG_LENGTH="-shortest"

# Get input arguements and assign them to variables.
while getopts ":v:a:t:f:d" opt;
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
        f)
            INPUT_FILE=$OPTARG
            ;;
        d)
            echo DRY RUN MODE
            echo ============
            echo Output file will be limited to 30 seconds.
            ARG_LENGTH="-t 00:00:30"
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
if [ -z "$INPUT_VIDEO" ] || [ -z "$INPUT_AUDIO" ] || [ -z "$START_TIMECODE" ] || [ -z "$INPUT_FILE" ]
then
    echo 'Something went wrong! You need to specify video (-v), audio (-a) and start timecode (-t).' >&2
    exit 1
fi

#       -metadata comment="$( cat $META_COMMENT )" \

# Run the muxing job via FFmpeg.
ffmpeg  -ss $START_TIMECODE -i $INPUT_VIDEO -i $INPUT_AUDIO \
        -map 0:0 -map 1:0 \
        -metadata title="$( jq -r '.file.title' $INPUT_FILE )" \
        -metadata artist="$( jq -r '.file.author' $INPUT_FILE )" \
        -metadata date="$( date +%Y )" \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        $ARG_LENGTH \
        $( jq -r '.file.title' $INPUT_FILE )\.mp4

# =============
# END OF SCRIPT
