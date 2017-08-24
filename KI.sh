#/bin/bash
# Ingesting script that uses FFmpeg to convert input video and audio into a standardised 1:1 format.

# Initialise our variables.
VIDEO=""
AUDIO=""
START_TIMECODE=""

# Get input arguements and assign them to variables.
while getopts ":v:a:t:" opt;
do
    case $opt in
        v)
            VIDEO=$OPTARG 
            ;;
        a)
            AUDIO=$OPTARG 
            ;; 
        t)
            START_TIMECODE=$OPTARG 
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
if [ -z "$VIDEO" ] || [ -z "$AUDIO" ] || [ -z "$START_TIMECODE" ] 
then
    echo 'Something went wrong! You need to specify video (-v), audio (-a) and start timecode (-t).' >&2
    exit 1
fi

# Run the muxing job via FFmpeg.
ffmpeg  -ss $START_TIMECODE -i $VIDEO -i $AUDIO \
        -map 0:0 -map 1:0 \
        -map_metadata 1 \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        -shortest \
        output.mp4
