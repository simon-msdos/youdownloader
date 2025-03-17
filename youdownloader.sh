#!/bin/bash

GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
BLUE='\e[1;34m'
RESET='\e[0m'
declare -A COLORS=(
    ["gradient1"]='\e[38;5;196m' ["gradient2"]='\e[38;5;208m'
    ["gradient3"]='\e[38;5;214m' ["gradient4"]='\e[38;5;220m'
    ["gradient5"]='\e[38;5;226m' ["gradient6"]='\e[38;5;190m'
)

show_fast_spinner() {
    local pid=$1
    local message=$2
    local spinchars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r${COLORS[gradient$((i%6+1))]}[%s] $message" "${spinchars:i++%${#spinchars}:1}"
        sleep 0.01
    done
    printf "\r${GREEN}[✓] $message${RESET}\n"
}

show_quick_progress() {
    local width=50
    local progress=0
    local bar_chars='▁▃▄▅▆▇'
    
    while [ $progress -le 100 ]; do
        local filled=$((progress*width/100))
        printf "\r${CYAN}["
        for ((i = 0; i < width; i++)); do
            if [ $i -lt $filled ]; then
                printf "${COLORS[gradient$((i%6+1))]}▓"
            else
                printf "░"
            fi
        done
        printf "]${RESET} %3d%%" $progress
        progress=$((progress + 2))
        sleep 0.001
    done
    echo
}

SCRIPT_URL="https://raw.githubusercontent.com/simon-msdos/youdownloader/main/youdownloader.sh"

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



echo -e "$GREEN Script by Simon - GitHub: $CYAN https://github.com/simon-msdos $RESET\n"

# Ensure yt-dlp is installed
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





DOWNLOAD_FOLDER="$HOME/Desktop/youdownload - simon-msdos"
mkdir -p "$DOWNLOAD_FOLDER"
if [[ -n "$1" ]]; then
    URL="$1"
else
    echo -ne "$GREEN Enter the YouTube URL (playlist or video): $RESET"
    read URL
fi
while [[ -z "$URL" || ! "$URL" =~ ^https?:// ]]; do
    echo -e "$RED[Error] Invalid URL. Please enter a valid YouTube URL.$RESET"
    echo -ne "$GREEN Enter the YouTube URL (playlist or video): $RESET"
    read URL
done
echo -e "$YELLOW Analyzing URL... $RESET"
(yt-dlp --flat-playlist --print "%(playlist_title)s;%(url)s" "$URL" 2>/dev/null) &
show_fast_spinner $! "Fetching "
IFS=';' read -r playlist_info video_urls <<< "$(yt-dlp --flat-playlist --print "%(playlist_title)s;%(url)s" "$URL" 2>/dev/null)"
if [[ -n "$playlist_info" ]]; then
    playlist_title="$playlist_info"
    video_count=$(echo "$video_urls" | wc -l)
    echo -e "$GREEN Playlist: $playlist_title $RESET"
    echo -e "$GREEN Total videos: $video_count $RESET"
else
    video_count=1
    echo -e "$GREEN Single video detected $RESET"
fi

echo -e "$BLUE Saving to: $DOWNLOAD_FOLDER $RESET\n"
download_video() {
    local video_url=$1
    local index=$2
    local title=$(yt-dlp --get-title "$video_url" 2>/dev/null)

    printf "\n${CYAN}➤ Download #%d/%d ${YELLOW}%s${RESET}\n" "$index" "$video_count" "$title"
    
    (yt-dlp -f bestaudio --extract-audio --audio-format mp3 \
        -o "$DOWNLOAD_FOLDER/%(title)s.%(ext)s" "$video_url" --quiet) &
    
    show_fast_spinner $! "Downloading "
    printf "${GREEN}✓ Complete: ${YELLOW}%s${RESET}\n" "$title"
}
if [[ "$video_count" -gt 1 ]]; then
    counter=0
    echo "$video_urls" | while IFS= read -r video_url; do
        counter=$((counter + 1))
        download_video "$video_url" "$counter"
    done
else
    download_video "$URL" 1
fi
echo -e "\n$BLUE#############################################$RESET"
echo -e "$BLUE#                                           #$RESET"
echo -e "$BLUE#      $GREEN All Downloads Complete!              $RESET$BLUE#$RESET"
echo -e "$BLUE#      $GREEN Enjoy your music!                   $RESET$BLUE#$RESET"
echo -e "$BLUE#                                           #$RESET"
echo -e "$BLUE#############################################$RESET"