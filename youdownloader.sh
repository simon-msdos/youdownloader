#!/bin/bash
GREEN='\e[1;32m'

clear
echo -e "$GREEN"
cat << "EOF"
  ____ ___ __  __  ___  _   _           __  __ ____  ____   ___  ____  
 / ___|_ _|  \/  |/ _ \| \ | |         |  \/  / ___||  _ \ / _ \/ ___| 
 \___ \| || |\/| | | | |  \| |  _____  | |\/| \___ \| | | | | | \___ \ 
  ___) | || |  | | |_| | |\  | |_____| | |  | |___) | |_| | |_| |___) |
 |____/___|_|  |_|\___/|_| \_|         |_|  |_|____/|____/ \___/|____/  
EOF
echo -e "$RESET"

SCRIPT_URL="https://raw.githubusercontent.com/simon-msdos/youdownloader/main/youdownloader.sh"
echo -e "$GREEN Script by Simon - GitHub: $CYAN https://github.com/simon-msdos $RESET\n"

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
