#!/bin/bash
# Ingesting script that uses FFmpeg to convert input video and audio into a standardised 1:1 format.

# START OF SCRIPT
# ===============

DRY_RUN=FALSE

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
            echo Output file will be limited to 20 seconds.
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

mkdir -p ../output/$( jq -r '.file.title' $INPUT_METADATA )
jq -r '.file' $INPUT_METADATA > ../output/$( jq -r '.file.title' $INPUT_METADATA )/$( jq -r '.file.title' $INPUT_METADATA ).json

export INPUT_METADATA
export DRY_RUN
./create_SRT_titles.sh
./create_video.sh

# =============
# END OF SCRIPT
