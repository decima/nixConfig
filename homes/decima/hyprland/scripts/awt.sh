limitTop=60
limitLeft=2
limitRight=2
limitBottom=2
moveStep=50
resizeStep=$moveStep
currentWindow=$(hyprctl activewindow -j)
isFloating=$(echo $currentWindow|jq -r ".floating")
isFullscreen=$(echo $currentWindow|jq -r ".fullscreen")

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
        if [[ "$isFloating" == "true" ]]; then
            hyprctl dispatch moveactive exact $limitLeft $limitTop
            hyprctl dispatch resizeactive exact $(echo "$currentMonitorWidth/2-$limitLeft"|bc) $(echo "$currentMonitorHeight-$limitTop-$limitBottom"|bc)
        else
            hyprctl dispatch movefocus l
        fi

    elif [[ "$1" == "right" ]];then
        if [[ "$isFloating" == "true" ]]; then
            hyprctl dispatch moveactive exact 50% $limitTop
            hyprctl dispatch resizeactive exact $(echo "$currentMonitorWidth/2-$limitLeft"|bc) $(echo "$currentMonitorHeight-$limitTop-$limitBottom"|bc)
        else
            hyprctl dispatch movefocus r
        fi
    elif [[ "$1" == "top" ]];then
        if [[ "$isFloating" == "true" ]]; then
            hyprctl dispatch resizeactive exact $(echo "$currentMonitorWidth-$limitLeft-$limitRight"|bc) $(echo "$currentMonitorHeight-$limitTop-$limitBottom"|bc)
            hyprctl dispatch moveactive exact $limitLeft $limitTop
        else
            hyprctl dispatch movefocus u
        fi


    elif [[ "$1" == "bottom" ]];then
        #hyprctl dispatch resizeactive exact 60% 60%
        #hyprctl dispatch centerwindow
        if [[ "$isFloating" == "false" ]]; then
            hyprctl dispatch movefocus d
        else
            hyprctl dispatch setfloating
            hyprctl dispatch resizeactive exact 60% 60%
            hyprctl dispatch centerwindow
        fi
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

state(){
    if [[ "$1" == "tiled" ]]; then
        hyprctl dispatch settiled
    elif [[ "$1" == "floating" ]];then
        hyprctl dispatch setfloating
    else 
        hyprctl dispatch togglefloating
    fi
}

expand(){
    if [[ "$1" == "left" ]]; then
        move "left"
        if [[ $(echo "$windowWidth > $currentMonitorWidth - ($limitLeft+$limitRight)"|bc) == "1" ]]; then
            echo "do nothing"
        elif [[ $(echo "$windowWidth + $resizeStep < $currentMonitorWidth -  ($limitLeft+$limitRight)"|bc) == "1" ]]; then
            hyprctl dispatch resizeactive $resizeStep 0
        else
            hyprctl dispatch resizeactive $(echo "($currentMonitorWidth -  ($limitLeft+$limitRight)) - $windowWidth"|bc) 0
        fi
    elif [[ "$1" == "right" ]]; then
        if [[ $(echo "$windowX + $windowWidth + $resizeStep < $currentMonitorWidth - $limitRight"|bc) == "1" ]]; then
           hyprctl dispatch resizeactive $resizeStep 0             
        else
            move "left"
            newStep=$resizeStep
            if [[ $(echo "$windowMaxX-$windowX < $resizeStep"|bc) == "1" ]]; then
                newStep=$(echo "$windowMaxX-$windowX"|bc)
            fi  
            hyprctl dispatch resizeactive $newStep 0

        fi
    elif [[ "$1" == "top" ]]; then
        move "top"
        if [[ $(echo "$windowHeight > $currentMonitorHeight - ($limitTop+$limitBottom)"|bc) == "1" ]]; then
            echo "do nothing"
        elif [[ $(echo "$windowHeight + $resizeStep < $currentMonitorHeight -  ($limitTop+$limitBottom)"|bc) == "1" ]]; then
            hyprctl dispatch resizeactive 0 $resizeStep
        else
            hyprctl dispatch resizeactive 0 $(echo "($currentMonitorHeight -  ($limitTop+$limitBottom)) - $windowHeight"|bc)
        fi
    elif [[ "$1" == "bottom" ]]; then
        if [[ $(echo "$windowY + $windowHeight + $resizeStep < $currentMonitorHeight - $limitBottom"|bc) == "1" ]]; then
           hyprctl dispatch resizeactive 0 $resizeStep            
        else
            move "top"
            newStep=$resizeStep
            if [[ $(echo "$windowMaxY-$windowY < $resizeStep"|bc) == "1" ]]; then
                newStep=$(echo "$windowMaxY-$windowY"|bc)
            fi  
            hyprctl dispatch resizeactive 0 $newStep

        fi
    fi

}


if [[ "$action" == "title" ]]; then
    echo $currentWindow | jq -r '(.title // "")'
elif [[ "$action" == "close" ]]; then
    hyprctl dispatch killactive
elif [[ "$action" == "splash" ]]; then
    splash $arg
elif [[ "$action" == "move" ]]; then
    move $arg
elif [[ "$action" == "state" ]]; then
    state $arg
elif [[ "$action" == "expand" ]]; then
    expand $arg
else
    echo $currentWindow
fi
