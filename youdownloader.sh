#!/bin/bash

read -p "Enter the YouTube playlist URL: " URL
if [[ -z "$URL" ]]; then
    echo "No URL provided. Exiting..."
    exit 1
fi

yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$URL"

echo "Downloads complete! Enjoy your music!"
