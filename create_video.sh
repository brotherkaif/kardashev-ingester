#/bin/bash
# Creates a file based on input JSON and edit parameters.

INPUT_FILE="" 
START_TIMECODE="" 
ARG_LENGTH="-shortest"

# Get input arguements and assign them to variables.
while getopts ":f:td" opt;
do
    case $opt in
        f)
            INPUT_FILE=$OPTARG 
            ;;
        t)
            START_TIMECODE=$OPTARG 
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
if [ -z "$INPUT_FILE" ] || [ -z "$START_TIMECODE" ]
then
        echo 'Something went wrong! You need to specify an input JSON (-f) and start timecode (-t).' >&2
    exit 1
fi


# Run the muxing job via FFmpeg.
ffmpeg  -ss $START_TIMECODE -i $( jq '.file.video_stream.source_file' $INPUT_FILE ) -i $( jq '.file.audio_stream.source_file' $INPUT_FILE ) \
        -map 0:0 -map 1:0 \
        -metadata title="$( jq '.file.title' $INPUT_FILE )" \
        -metadata artist="$( jq '.file.author' $INPUT_FILE )" \
        -metadata date="$( date +%Y )" \
#       -metadata comment="$( cat $META_COMMENT )" \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720'" \
        $ARG_LENGTH \
        $( jq '.file.title' $INPUT_FILE )\.mp4

# =============
# END OF SCRIPT
