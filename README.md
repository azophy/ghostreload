# GhostReload
A short bash script to automate browser reload based on file change

Created by : Abdurrahman Shofy Adianto <azophy@gmail.com>
This script is a modified version of scripts by Silviu Tantos <http://www.razius.com> and L Nix <lornix@lornix.com>

Watches the folder/files passed as arguments to the script and when it detects a change it automatically refreshes the current selected Browser (also passed as argument) tab or window.

#Requirement

* inotifywait
* xdotools

#installation

install inotify and xdotool first:
> apt-get install inotify-tools xdotool

then download this script and make it executable:

> cd ghostreload
> chmod +x GhostReload.sh

(otional) link it to bin directory so you could just "ghostreload" from everywhere:

> ln -s /path/to/GhostReload.sh /usr/local/bin/ghostreload

#Usage:
> ghostreload browser_name /folder/to/watch /some/folder/file_to_watch.html

Notes: It seems that xdotool sometimes fail to recognize window by searching, so I suggest to use "-s" option which allows you to click the window you want to automatically reload rather then search for the browser name or class. The usage should be:

> ghostreload -s /folder/to/watch

#More interesting usages:
Please refer to the script's help ( ghostreload -h )
