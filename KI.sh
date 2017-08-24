#/bin/bash
# Ingesting script that uses FFmpeg to convert input video and audio into a standardised 1:1 format.

# Initialise our variables.
VIDEO=""
AUDIO=""
START_TIMECODE=""
META_TITLE=""
META_ARTIST=""
META_ALBUM_ARTIST=""
META_ALBUM=""
META_DATE=""
META_TRACK=""
META_GENRE=""
META_COPYRIGHT=""
META_COMMENT=""

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

# Extract the required metadata.
META_TITLE=$( ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_ARTIST=$( ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_ALBUM_ARTIST=$( ffprobe -v error -show_entries format_tags=album_artist -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_ALBUM=$( ffprobe -v error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_DATE=$( ffprobe -v error -show_entries format_tags=date -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_TRACK=$( ffprobe -v error -show_entries format_tags=track -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_GENRE=$( ffprobe -v error -show_entries format_tags=genre -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_COPYRIGHT=$( ffprobe -v error -show_entries format_tags=copyright -of default=noprint_wrappers=1:nokey=1 $AUDIO )
META_COMMENT=$( ffprobe -v error -show_entries format_tags=comment -of default=noprint_wrappers=1:nokey=1 $AUDIO )

# Run the muxing job via FFmpeg.
ffmpeg  -ss $START_TIMECODE -i $VIDEO -i $AUDIO \
        -map 0:0 -map 1:0 \
        -metadata title="$META_TITLE" \
        -metadata artist="$META_ARTIST" \
        -metadata album_artist="$META_ALBUM_ARTIST" \
        -metadata album="$META_ALBUM" \
        -metadata date="$META_DATE" \
        -metadata track="$META_TRACK" \
        -metadata genre="$META_GENRE" \
        -metadata comment="$META_COMMENT" \
        -vf "scale=iw*sar:ih,yadif,fps=fps=25,crop=in_h:in_h,scale=720:720" \
        -shortest \
        output.mp4
