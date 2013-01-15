#!/bin/bash

set -x

if [ -z "$1" ]; then
  echo "Usage: $(basename $0) <next|prev|pause>"
  echo "Note: the main Spotify window must be open."
  exit 1
fi

# Get spotify window id, this works only if spotify is runnin and playing
# There seems to be two instances of Spotify "windows", the other probably
# being the systray icon
id=$(xdotool search --name "Spotify Premium")
[ $? -ne 0 ] && echo "Failed" && exit 1

# So we want to change the track. First store current focused window
cid=$(xdotool getwindowfocus)
# Make sure spotify window is not minimized, otherwise focus will fail
xdotool windowmap $id
# Change focus to Spotify window
xdotool windowfocus $id
case "$1" in
  next)
    xdotool key Control_L+Right
    ;;
  prev)
    xdotool key Control_L+Left
    ;;
  pause)
    xdotool key space
    ;;
esac
# And nicely return the focus to the window where we were before
xdotool windowfocus $cid
# Wait for moment so that song title has time to change 
sleep 1



## Resolve the song from full window title, which is in format "Spotify - Artist - Track"
#title=$(xwininfo -id $id|grep xwininfo|cut -d\" -f2)
#title="${title#*- }"
## Pop up notification with song info
#notify-send -i /usr/share/pixmaps/spotify-linux-48x48.png -t 2000 "$title"

## Now playing to clipboard request
#if [ "$1" = "np" ]; then 
#  # Push the title to clipboard with xclip and also to standard out
#  echo "np: $title"|xclip -in
#  echo "np: $title"
#fi

