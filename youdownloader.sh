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
echo -e "$YELLOW Update yt-dlp to the latest version? (y/n, default: no): $RESET"
read -t 3 update_choice
if [[ "$update_choice" =~ ^[Yy]$ ]]; then
    echo -e "$YELLOW Updating yt-dlp... $RESET"
    (sudo yt-dlp -U) &
    show_progress 0.02
    echo -e "$GREEN[Success] yt-dlp updated!$RESET\n"
else
    echo -e "$YELLOW[Info] Skipping update...$RESET\n"
fi

if ! grep -q "youdownload" ~/.bashrc ~/.zshrc 2>/dev/null; then
    echo -e "$YELLOW Create alias for 'youdownload' command? (y/n, default: no): $RESET"
    read -t 3 alias_choice
    if [[ "$alias_choice" =~ ^[Yy]$ ]]; then
        SHELL_CONFIG="$HOME/.bashrc"
        [[ "$SHELL" =~ zsh ]] && SHELL_CONFIG="$HOME/.zshrc"
        echo "alias youdownload='bash <(curl -s $SCRIPT_URL)'" >> "$SHELL_CONFIG"
        echo "alias youtubedownload='bash <(curl -s $SCRIPT_URL)'" >> "$SHELL_CONFIG"
        echo "alias ydown='bash <(curl -s $SCRIPT_URL)'" >> "$SHELL_CONFIG"
        source "$SHELL_CONFIG"
        echo -e "$GREEN[Success] Aliases {youdownload OR youtubedownload OR ydown } added! \n usage : ydown[link] \n Restart terminal to use them.$RESET\n"
    else
        echo -e "$YELLOW[Info] Skipping alias creation...$RESET\n"
    fi
fi


read -p "Enter the YouTube playlist URL: " URL
if [[ -z "$URL" ]]; then
    echo "No URL provided. Exiting..."
    exit 1
fi

yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "$URL"

echo "Downloads complete! Enjoy your music!"
