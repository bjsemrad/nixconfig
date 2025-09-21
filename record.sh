#!/bin/bash

VID_FILE="video.mp4"
AUD_FILE="audio.wav"
OUT_FILE="screen-recording-$(date +%F_%T).mp4"

# Start audio recording
ffmpeg -f pulse -i default "$AUD_FILE" &
AUD_PID=$!

# Start video recording
wf-recorder -f "$VID_FILE"

# Stop audio after video ends
kill $AUD_PID

# Merge
ffmpeg -i "$VID_FILE" -i "$AUD_FILE" -c:v copy -c:a aac "$OUT_FILE"
