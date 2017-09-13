#/bin/bash
# Testing multi line variables.

INPUT_METADATA=$1
META_COMMENT=$"[ATTRIBUTION DECLARATION]
This work, \"$( jq -r '.file.title' $INPUT_METADATA )\", is a derivative of the works listed below. $( jq -r '.file.title' $INPUT_METADATA ) was created by $( jq -r '.file.author' $INPUT_METADATA ) and is licenced under a $( jq -r '.file.licence' $INPUT_METADATA ) licence.


[AUDIO ATTRIBUTION]
Track: $( jq -r '.file.audio_stream.title' $INPUT_METADATA )"

echo "$META_COMMENT"
