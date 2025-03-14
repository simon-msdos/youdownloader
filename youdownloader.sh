#!/bin/bash
if ! command -v yt-dlp &>/dev/null; then
    echo -e "$RED[Error] yt-dlp is not installed.$RESET"
    read -p "Install yt-dlp now? (y/n): " install_choice
    if [[ "$install_choice" =~ ^[Yy]$ ]]; then
        echo -e "$YELLOW Installing yt-dlp... $RESET"
        (sudo apt install yt-dlp -y || sudo pip install yt-dlp) &
        show_progress 0.02
        echo -e "$GREEN[Success] yt-dlp installed!$RESET"
    else
        echo -e "$RED Installation skipped. Exiting... $RESET"
        exit 1
    fi
fi

read -p "Enter the YouTube playlist URL: " URL
if [[ -z "$URL" ]]; then
    echo "No URL provided. Exiting..."
    exit 1
fi

yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$URL"

echo "Downloads complete! Enjoy your music!"
