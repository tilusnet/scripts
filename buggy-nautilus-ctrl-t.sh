# Opens target in a new tab of nautilus.
# Source: http://askubuntu.com/questions/55656/open-nautilus-as-new-tab-in-existing-window

# Requires: 
# - xclip
# - wmctrl
# - xdotool
# - realpath

set -x

pid=`pidof nautilus`
if [ -z $pid ]; then
    nautilus  $1 &
else  
    # save old clipboard value
    oldclip="$(xclip -o -sel clip)"

    echo -n `realpath $1` | xclip -i -sel clip

    #wmctrl -xF -R nautilus.Nautilus && xdotool key "ctrl+t" "ctrl+l" && xdotool type "${1}" && xdotool key Return
    wmctrl -xF -R nautilus.Nautilus && xdotool key ctrl+t && xdotool key ctrl+l && xdotool key ctrl+v && xdotool key Return

    # Restore old clipboard value
    echo -n "$oldclip" | xclip -i -sel clip
fi
