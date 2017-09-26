# kardashev-ingester

A video ingesting and muxing script made for a video based web project I am working on. The script uses FFMPEG and JQ to streamline the creation of video content. It is quite specific to this project so may be of little use to anyone else, but may be of interest to people who wish to learn FFMPEG.

## Getting Started

If you are interested in running this script the following information will assist to get this up and running.

### Prerequisites

This script uses BASH, jq and FFMPEG. You should be able to install jq and FFMPEG on your flavour of Linux without many issues. This will even work with the Windows 10 implementation of BASH so long as jq and FFMPEG is installed within the Linux subsystem.

### Installing
Simply unzip the repository to your machine, you may need to change permissions to ensure the SH files are executable.

## Usage
The script requires three inputs:

* An input video file.
* An input audio file.
* An input JSON metadata file.

The script will process this and output the following:

* An output video file.
* An output ASS subtitle file.
* An output JSON metadata file.

The output video itself is a the video stream of the input video file muxed with the audio stream of the input audio file. The video is then cropped to a 1x1 aspect ratio and trimmed to be the length of the shortest input file. Finally ASS and JSON files are generated based off the metadata from the input JSON file.

### JSON Metadata File

Inside the JSON folder in the repository is a schema and a sample JSON file. This file needs to be supplied along with the audio and video file so that the script can create subtitle files and handle metadata correctly.

### Running The Script

The script requires the following arguements to be passed through it.

* -v: The input video file.
* -a: The input audio file.
* -i: The input JSON metadata file.

```
./KI.sh -i input.json -v video.mpeg -a audio.mp3
```

## Built With

* [FFMPEG](https://www.ffmpeg.org/) - The video processing library used.
* [jq](https://stedolan.github.io/jq/) - A JSON parser used for both input and output.
