limitTop=60
limitLeft=30
limitRight=30
limitBottom=60
moveStep=50
currentWindow=$(hyprctl activewindow -j)
echo $currentWindow
currentWorkspace=$(hyprctl activeworkspace -j)
monitorId=`echo $currentWorkspace|jq -r ".monitorID"`
currentMonitorList=$(hyprctl monitors $monitorId -j)
currentMonitor=$(echo $currentMonitorList|jq -r ".[0]")
currentMonitorHeight=$(echo $currentMonitor|jq -r ".height")
currentMonitorWidth=$(echo $currentMonitor|jq -r ".width")
windowWidth=$(echo $currentWindow|jq -r ".size[0]")
windowHeight=$(echo $currentWindow|jq -r ".size[1]")
windowX=$(echo $currentWindow|jq -r ".at[0]")
windowY=$(echo $currentWindow|jq -r ".at[1]")

windowMinX=$limitLeft
windowMinY=$limitTop
windowMaxX=$(echo "$currentMonitorWidth-$windowWidth-$limitRight"|bc)
windowMaxY=$(echo "$currentMonitorHeight-$windowHeight-$limitBottom"|bc)



action=$1
arg=$2

splash() {
	if [[ "$1" == "left" ]]; then
         hyprctl dispatch resizeactive exact $(echo "$currentMonitorWidth/2-$limitLeft"|bc) $(echo "$currentMonitorHeight-$limitTop-$limitBottom"|bc)
        hyprctl dispatch moveactive exact $limitLeft $limitTop

    elif [[ "$1" == "right" ]];then
         hyprctl dispatch resizeactive exact $(echo "$currentMonitorWidth/2-$limitLeft"|bc) $(echo "$currentMonitorHeight-$limitTop-$limitBottom"|bc)
        hyprctl dispatch moveactive exact 50% $limitTop
    
    elif [[ "$1" == "top" ]];then
        hyprctl dispatch resizeactive exact $(echo "$currentMonitorWidth-$limitLeft-$limitRight"|bc) $(echo "$currentMonitorHeight-$limitTop-$limitBottom"|bc)
        hyprctl dispatch moveactive exact $limitLeft $limitTop

    elif [[ "$1" == "bottom" ]];then
        hyprctl dispatch resizeactive exact 60% 60%
        hyprctl dispatch centerwindow
    fi
}

move(){
    if [[ "$1" == "left" ]]; then
        if [[ $(echo "$windowX-$moveStep>$windowMinX"|bc) == "1" ]];then
            hyprctl dispatch moveactive "-$moveStep" 0
        else 
            hyprctl dispatch moveactive $(echo "-$windowX + $windowMinX"|bc) 0
        fi
    elif [[ "$1" == "right" ]];then
        if [[ $(echo "$windowX+$moveStep<$windowMaxX"|bc) == "1" ]];then
            hyprctl dispatch moveactive "$moveStep" 0
        else 
            hyprctl dispatch moveactive $(echo " -$windowX + $windowMaxX"|bc) 0
        fi      

    elif [[ "$1" == "top" ]];then
        if [[ $(echo "$windowY-$moveStep>$windowMinY"|bc) == "1" ]];then
            hyprctl dispatch moveactive 0 "-$moveStep"
        else 
            hyprctl dispatch moveactive 0 $(echo "-$windowY + $windowMinY"|bc)
        fi    
    elif [[ "$1" == "bottom" ]];then
        if [[ $(echo "$windowY+$moveStep<$windowMaxY"|bc) == "1" ]];then
            hyprctl dispatch moveactive 0 "$moveStep"
        else 
            hyprctl dispatch moveactive 0 $(echo " -$windowY + $windowMaxY"|bc)
        fi  

    fi
}

resize(){
    
}


if [[ "$action" == "title" ]]; then
    echo $currentWindow | jq -r '(.title // "")'
elif [[ "$action" == "close" ]]; then
    hyprctl dispatch killactive
elif [[ "$action" == "splash" ]]; then
    splash $arg
elif [[ "$action" == "move" ]]; then
    move $arg
else
    echo $currentWindow
fi
