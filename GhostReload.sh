#!/bin/bash
#
# Abdurrahman Shofy Adianto <azophy@gmail.com>
# A modified version of scripts by Silviu Tantos <http://www.razius.com> 
# and L Nix <lornix@lornix.com>
#
# Watches the folder/files passed as arguments to the script and when it
# detects a change it automatically refreshes the current selected Browser 
# (also passed as argument) tab or window.
#
# Usage:
# ./GhostReload.sh browser_name /folder/to/watch /some/folder/file_to_watch.html

# whether to use SHIFT+CTRL+R to force reload without cache
RELOAD_KEYS="CTRL+R"
#RELOAD_KEYS="SHIFT+CTRL+R"

# set to whatever's given as argument
BROWSER=$1

# if was empty, default set to name of browser, firefox/chrome/opera/etc..
if [ -z "${BROWSER}" ]; then
    BROWSER=firefox
fi

args=("$@")
WATCHED_FOLDERS=(${args[@]:1})
TIME_FORMAT='%F %H:%M'
OUTPUT_FORMAT='%T Event(s): %e fired for file: %w. Refreshing.'
WATCHED_EVENT="modify"

while inotifywait -e "${WATCHED_EVENT}" -q -r --timefmt "${TIME_FORMAT}" --format "${OUTPUT_FORMAT}" "${WATCHED_FOLDERS[@]}"; do
    #WINDOW_ID=$(xdotool search --onlyvisible --class google-chrome | tail -1)
    WINDOW_ID=$(xdotool search --onlyvisible --name ${BROWSER} | tail -1)
    echo "Current Window ID = " $WINDOW_ID
    xdotool key --window $WINDOW_ID $RELOAD_KEYS
done

# auto focus (optional)
# xdotool windowfocus --sync ${WINDOW_ID}
# xdotool windowactivate --sync ${WINDOW_ID}
