# 🎵 YouTube Music Downloader

A fast and efficient bash script to download audio from YouTube videos and playlists with style!

![Version](https://img.shields.io/badge/version-1.0-blue)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## 🚀 Features

- Download single videos or entire playlists
- Extract high-quality audio (MP3 format)
- Beautiful terminal interface with animations
- Progress tracking and status indicators
- Easy installation and configuration
- Configurable aliases for quick access

## 📋 Prerequisites

- Linux-based system
- `bash` shell
- `yt-dlp` (auto-installer included)

## 🔧 Installation

1. Download the script:
```bash
curl -O https://raw.githubusercontent.com/simon-msdos/youdownload.sh/main/youdownload.sh
```

2. Make it executable:
```bash
chmod +x youdownload.sh
```

## 🎮 Usage

### Direct Execution
```bash
./youdownload.sh [URL]
```

### Using Aliases
The script will offer to create the following aliases:
- `youdownload [URL]`
- `youtubedownload [URL]`
- `ydown [URL]`

Example:
```bash
ydown https://youtube.com/watch?v=...
```

### Command Line Arguments
- No arguments: Script will prompt for URL
- URL as argument: Starts downloading immediately

## 📥 Download Location
Downloads are saved to:
```
~/Desktop/youdownload - simon-msdos/
```

## 🎨 Features & Functions

### Auto-Installation
- Automatically detects and offers to install `yt-dlp`
- Optional update check for `yt-dlp`

### URL Support
- Single video URLs
- Playlist URLs
- Validates URLs before processing

### Progress Indicators
- Spinning progress animation
- Download progress tracking
- Completion notifications

### Terminal Colors
Beautiful color-coded output for:
- Success messages (Green)
- Warnings (Yellow)
- Errors (Red)
- Info (Cyan)
- Headers (Blue)



<video width="640" height="360" controls>
  <source src="TUTO.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>


## 🤝 Contributing

Feel free to fork, improve, and submit pull requests!

## ⚖️ License

This project is licensed under the MIT License - see the LICENSE file for details

## 👤 Author

**Simon**
- GitHub: [@simon-msdos](https://github.com/simon-msdos)

## 🙏 Acknowledgments

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) for the awesome downloader
- All contributors and users of this script

## 📝 Notes

- For playlist downloads, each song is processed sequentially
- The script automatically skips already downloaded files
- Internet connection required
- Some videos might be restricted and cannot be downloaded
