#!/bin/bash
# Ingesting script that uses FFmpeg to convert input video and audio into a standardised 1:1 format.

function_process () {
    echo Processing $INPUT_METADATA ...
    jq -r '.file' $INPUT_DIRECTORY/$INPUT_METADATA > $INPUT_DIRECTORY/../output/$( jq -r '.file.title' $INPUT_DIRECTORY/$INPUT_METADATA ).json
    export INPUT_DIRECTORY
    export INPUT_METADATA
    export DRY_RUN
    # ./create_SRT_titles.sh
    ./create_ASS_titles.sh
    ./create_video.sh
    echo $INPUT_FILE done!
}

# START OF SCRIPT
# ===============

SINGLE=FALSE
BATCH=FALSE
DRY_RUN=FALSE

# Get input arguements and assign them to variables.
while getopts ":i:b:d" opt;
do
    case $opt in
        i)
            INPUT_DIRECTORY=$( dirname $OPTARG )
            INPUT_METADATA=$( echo ${OPTARG##*/} )
            SINGLE=TRUE
            ;;
        b)
            INPUT_DIRECTORY=$OPTARG
            BATCH=TRUE
            ;;
        d)
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

if [ $SINGLE == 'TRUE' ] && [ $BATCH == 'TRUE' ]
then
    echo 'You cannot run SINGLE MODE (-i) and BATCH MODE (-b) at the same time!' >&2
    exit 1
elif [ $SINGLE == 'TRUE' ] && [ -z "$INPUT_DIRECTORY" ]
then
    echo 'You need to supply a JSON file with (-i).' >&2
    exit 1
elif [ $BATCH == 'TRUE' ] && [ -z "$INPUT_DIRECTORY" ]
then
    echo 'You need to supply a valid directory with (-b).' >&2
    exit 1
fi

if [ $SINGLE == 'TRUE' ]
then
    echo SINGLE MODE
    echo ===========
    echo The file $INPUT_METADATA will be processed...
    echo
elif [ $BATCH == 'TRUE' ]
then
    echo BATCH MODE
    echo ==========
    echo The following files will be processed...
    echo
    for INPUT_FILE in $INPUT_DIRECTORY/*.json
    do
        echo $INPUT_FILE
    done
    echo
fi

if [ $DRY_RUN == 'TRUE' ]
then
    echo DRY RUN MODE
    echo ============
    echo Output will be limited to 20 seconds.
    echo
fi

read -p 'Do you want to proceed? (y/n): ' RUN_CONVERSION
mkdir -p $INPUT_DIRECTORY/../output

if [ $RUN_CONVERSION == 'y' ] && [ $BATCH == 'TRUE' ]
then
    for INPUT_FILE in $INPUT_DIRECTORY/*.json
    do
        INPUT_DIRECTORY=$( dirname $INPUT_FILE )
        INPUT_METADATA=$( echo ${INPUT_FILE##*/} )
        function_process
    done
elif [ $RUN_CONVERSION == 'y' ] && [ $SINGLE == 'TRUE' ]
then
    function_process
fi

# =============
# END OF SCRIPT
