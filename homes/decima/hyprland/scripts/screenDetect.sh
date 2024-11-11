#!/usr/bin/env bash
# hyprctl dispatch moveworkspacetomonitor "1 1"
    # hyprctl dispatch moveworkspacetomonitor "2 1"
    # hyprctl dispatch moveworkspacetomonitor "4 1"
    # hyprctl dispatch moveworkspacetomonitor "5 1"

handle() {
    if [[ "$1" == monitoradded* ]];then 
    echo "screen plugged"
    elif [[ "$1" == monitorremoved* ]]; then
        echo "screen unplugged"
    fi
}



socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" | while read -r line; do handle "$line"; done