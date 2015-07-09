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

# Read another optional parameter
while getopts ":hsf:" opt; do
case $opt in
   h)
     HELP_TEXT="GhostReload
A short bash script to automate browser reload based on file change
Usage: ghostreload [options] browser_name <file/folder 1> [file/folder 2] ....
Options:
	-h	Show this help text
	-f <file_name>
		Read file_name and use it as list of files/folders to be 
		watched. The content is just list of all files/folders to be 
		watched.
	-s	Alternative way to select window to be reloaded. GhostReaload 
		will show a cursor, use it to select a window you want to be 
		automatically reload.
	@<file>	Exclude the specified file from being watched. Could be used 
		for parameters, or inserted to the source file list
"
     echo "$HELP_TEXT"
     exit 1
     ;;
   f)
     SOURCE_FILE=$OPTARG
     ;;
   s)
     WINDOW_ID=$(xdotool selectwindow)
     PID_EXIST=true
     echo "WINDOW_ID = $WINDOW_ID"
     ;;
   \?)
     echo "Invalid option: -$OPTARG" >&2
     echo "Type 'ghostscript -h' for helps"
     exit 1
     ;;
   :)
     echo "Option -$OPTARG requires an argument." >&2
     echo "Type 'ghostscript -h' for helps"
     exit 1
     ;;
esac
done

shift $((OPTIND-1))

# set to whatever's given as argument
BROWSER=$1
# if was empty, default set to name of browser, firefox/chrome/opera/etc..
if [ -z "${BROWSER}" ]; then
    BROWSER=google-chrome
fi

# default search method
SEARCH_METHOD="--class"

shift 1
TIME_FORMAT='%F %H:%M'
OUTPUT_FORMAT='%T Event(s): %e fired for file: %w. Refreshing.'
WATCHED_EVENT="modify"

# other custom params
CUSTOM_PARAMS=""
if [ -n "${SOURCE_FILE}" ]; then
  CUSTOM_PARAMS+="--fromfile $SOURCE_FILE "
fi

while inotifywait ${CUSTOM_PARAMS} -e "${WATCHED_EVENT}" -q -r --timefmt "${TIME_FORMAT}" --format "${OUTPUT_FORMAT}" "${@}"; do
    if [ -z "${PID_EXIST}" ]; then
        WINDOW_ID=$(xdotool search --onlyvisible ${SEARCH_METHOD} ${BROWSER} | head -1)
	echo "Current Window ID = " $WINDOW_ID
    fi

    xdotool key --window $WINDOW_ID $RELOAD_KEYS
done

# auto focus (optional)
# xdotool windowfocus --sync ${WINDOW_ID}
# xdotool windowactivate --sync ${WINDOW_ID}
